<#
.SYNOPSIS
  What the game actually does with this mod, checked outside the game.

.DESCRIPTION
  This mod is four Harmony patches and one Need. Every one of those patches is a bet on a vanilla
  member keeping its name, its shape and its behaviour, and every one of those bets fails SILENTLY
  when it is lost: a patch whose target has been renamed throws once into the log at startup and
  the mod then does nothing, while a patch whose target no longer writes the field it used to
  wrap goes on running and scales a delta that is always zero. Neither shows up as a crash, and
  neither shows up in a save.

  This standalone repository checks its own shipped XML as well as the runtime contracts.
  No monorepo scripts are required.

  Nothing is simulated. RimWorld cannot be run outside itself: most of its types touch Unity and
  throw on construction, its XML loader among them. Three things do work, and they are enough:

    reading IL       a method body comes back as bytes through plain reflection, and the field
                     tokens inside it resolve against the same module. That is how "CompTick is
                     what writes fullness" gets READ off the compiled game instead of asserted.
    reflection       every member this mod names is looked up on the real Assembly-CSharp, with
                     the signature the patch expects, not just the name.
    construction     the mod's own classes with no Unity state - the settings, the static rules
                     class - really are instantiated and called here.

  Thirty-five tests, including the settings gate added in Settings-Tests.ps1:

    The hooks         why CompTick and Thing.Ingested were the only possible targets, and whether
                      that is still true of 1.6
    The patches       every [HarmonyPatch] in the assembly resolved against the game, parameters
                      included, plus the access rights the publicised build needs at runtime
    The mod's code    the settings and the neutral-value rule, instantiated and called
    Defs and text     the need's def, its DefOf, and every translation key the code asks for
    Settings          actual numeric logic, scalar Scribe round-trips, XML/IL access contracts

  Exit code 0 when everything passes, 1 otherwise. About ten seconds.

  TWELVE OF THE SEVENTEEN HAVE BEEN SEEN TO FAIL, one fault at a time in a copy of the mod in a
  scratch directory, never in the real files. The other five assert facts about the game's own
  assembly and cannot be made to fail without rewriting it. Both lists are at the bottom of this
  file, and the distinction is kept rather than glossed: a test never seen red is a test that has
  only ever been read.

.PARAMETER ModPath
  The mod folder. Defaults to the parent of this script.

.PARAMETER Managed
  RimWorld's Managed folder. Reference assemblies will NOT do: Krafs.Rimworld.Ref ships method
  signatures with no bodies, and half of this file reads bodies.

.PARAMETER GameData
  RimWorld's Data folder. Point it at a doctored copy to see a data test fail.

.PARAMETER HarmonyPath
  Assemblies directory selected by the installed Harmony mod's LoadFolders for RimWorld 1.6.
  No NuGet fallback is used: tests must resolve the actual runtime provider.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File _tools\Run-Functional-Tests.ps1

  The -ExecutionPolicy is needed when launching from Git Bash, where this machine's policy
  refuses -File outright and leaves you with an empty output rather than an error.
#>
param(
    [string]$ModPath  = (Split-Path -Parent $PSScriptRoot),
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$HarmonyPath = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2009463077\Current\Assemblies'
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------- assembly resolution

# Same handler as scripts/Check-XmlFields.ps1 in the monorepo, and it carries the same guard:
# an unresolvable name asked for twice recurses to a stack overflow rather than to an error.
# One probe directory is specific to this mod: HarmonyLib is NOT in the game's Managed
# folder in 1.6. Resolve the provider declared in About.xml, not the build's NuGet reference.
# Use the real runtime provider. A NuGet fallback would hide a missing dependency.
if (-not (Test-Path (Join-Path $HarmonyPath '0Harmony.dll'))) {
    throw 'Install Harmony for RimWorld 1.6, or pass -HarmonyPath to its active Assemblies folder.'
}
$probeDirs = @($Managed, $HarmonyPath)
$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$gameDll = Join-Path $Managed 'Assembly-CSharp.dll'
$modDll  = Join-Path $ModPath 'Mod\Assemblies\ContentedLivestock.dll'
if (-not (Test-Path $gameDll)) { throw "Assembly-CSharp.dll not found under $Managed" }
if (-not (Test-Path $modDll))  { throw "ContentedLivestock.dll not found - build Source/ first" }

$gameAsm   = [System.Reflection.Assembly]::LoadFrom($gameDll)
$gameTypes = Get-AssemblyTypes $gameDll
$modAsm    = [System.Reflection.Assembly]::LoadFrom($modDll)
$modTypes  = Get-AssemblyTypes $modDll

$byName = @{}
foreach ($t in $gameTypes) { if ($t.FullName) { $byName[$t.FullName] = $t } }

$ALL = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'
$DECL = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'

function Get-GameType([string]$full) {
    if ($byName.ContainsKey($full)) { return $byName[$full] }
    return $null
}

# ---------------------------------------------------------------- IL helpers

# Field access instructions carry a 4-byte metadata token. Within one module that token IS the
# field's MetadataToken, so no ResolveMember call is needed per instruction - which is what makes
# scanning a whole method body cheap. A field reached only through reflection would be a false
# negative here; none of the ones asked about below are.
function Test-FieldTouched {
    param([System.Reflection.MethodBase]$Method, [System.Reflection.FieldInfo]$Field, [byte]$OpCode)

    $body = $Method.GetMethodBody()
    if ($null -eq $body) { return $false }
    $il = $body.GetILAsByteArray()
    if ($null -eq $il) { return $false }

    $token = $Field.MetadataToken
    for ($i = 0; $i -lt $il.Length - 4; $i++) {
        if ($il[$i] -ne $OpCode) { continue }
        $t = [BitConverter]::ToInt32($il, $i + 1)
        if ($t -eq $token) { return $true }
    }
    return $false
}

function Get-StringLiterals([System.Reflection.MethodBase]$Method) {
    $out = @()
    $body = $Method.GetMethodBody()
    if ($null -eq $body) { return $out }
    $il = $body.GetILAsByteArray()
    if ($null -eq $il) { return $out }
    $module = $Method.Module
    for ($i = 0; $i -lt $il.Length - 4; $i++) {
        if ($il[$i] -ne 0x72) { continue }   # ldstr
        $t = [BitConverter]::ToInt32($il, $i + 1)
        try { $out += $module.ResolveString($t) } catch { }
    }
    return $out
}

# ---------------------------------------------------------------- harness

$script:total = 0
$script:failed = 0
$script:currentGroup = ''

function Group([string]$Name) {
    $script:currentGroup = $Name
    Write-Host ''
    Write-Host "  $Name" -ForegroundColor Cyan
}

# A test body returns nothing when it passes, or a string saying what is wrong. Throwing counts
# as a failure too, and the message is kept: a member that has vanished usually shows up as a
# null-reference three lines into the body rather than as a tidy verdict.
function Test-Case([string]$Name, [scriptblock]$Body) {
    $script:total++
    $verdict = $null
    try { $verdict = & $Body }
    catch { $verdict = "threw: $($_.Exception.Message)" }

    if ([string]::IsNullOrWhiteSpace([string]$verdict)) {
        Write-Host "    PASS  $Name" -ForegroundColor DarkGray
    } else {
        $script:failed++
        Write-Host "    FAIL  $Name" -ForegroundColor Red
        foreach ($line in ([string]$verdict -split "`n")) { Write-Host "          $line" -ForegroundColor Red }
    }
}

Write-Host ''
Write-Host 'Contented Livestock - functional tests' -ForegroundColor White
Write-Host "  game    $Managed"
Write-Host "  mod     $modDll"

# ================================================================ 1. The hooks

Group 'The hooks, and whether they are still the only ones'

# The central claim of the mod, and the reason it is one patch rather than a dozen. If a vanilla
# subclass ever overrides CompTick, that subclass's animals stop being scaled - no error, no log
# line, just a cow that ignores its pasture while the sheep next to it does not.
Test-Case 'CompTick is declared once on the gatherable comp and overridden by no vanilla subclass' {
    $base = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    if ($null -eq $base) { return 'CompHasGatherableBodyResource is gone from the game' }

    $declared = $base.GetMethod('CompTick', $DECL)
    if ($null -eq $declared) { return 'CompHasGatherableBodyResource no longer declares CompTick' }

    $offenders = @()
    foreach ($t in $gameTypes) {
        if ($t -eq $base) { continue }
        if (-not $base.IsAssignableFrom($t)) { continue }
        if ($t.GetMethod('CompTick', $DECL)) { $offenders += $t.FullName }
    }
    if ($offenders.Count -gt 0) {
        return "these subclasses override CompTick and so escape the patch: $($offenders -join ', ')"
    }
}

# The other half of the same decision, stated as a fact about the game rather than as an opinion
# in a comment. ResourceAmount IS overridden, which is why patching it would have caught some
# animals and missed others.
Test-Case 'ResourceAmount is overridden by subclasses, which is why the tick was chosen instead' {
    $base = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    $overriders = @()
    foreach ($t in $gameTypes) {
        if ($t -eq $base) { continue }
        if (-not $base.IsAssignableFrom($t)) { continue }
        if ($t.GetProperty('ResourceAmount', $DECL)) { $overriders += $t.Name }
    }
    if ($overriders.Count -eq 0) {
        return 'no subclass overrides ResourceAmount any more - the comment in Patch_Production.cs
now describes a game that no longer exists, and the simpler patch may be available'
    }
}

# The one that catches a silent no-op. The patch wraps CompTick and scales whatever CompTick added
# to the field; if the increment moves elsewhere, the patch still runs, still finds a delta of
# zero, and quietly scales nothing at all.
Test-Case 'CompTick is what writes fullness, and CompEggLayer.CompTick what writes eggProgress' {
    $problems = @()

    $gather = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    $field  = $gather.GetField('fullness', $ALL)
    $tick   = $gather.GetMethod('CompTick', $DECL)
    if ($null -eq $field) { $problems += 'CompHasGatherableBodyResource has no fullness field' }
    elseif (-not (Test-FieldTouched -Method $tick -Field $field -OpCode 0x7D)) {
        $problems += 'CompHasGatherableBodyResource.CompTick no longer stores into fullness: the
prefix/postfix pair would wrap a method that changes nothing, and the mod would go silently inert'
    }

    $egg   = Get-GameType 'RimWorld.CompEggLayer'
    $prog  = $egg.GetField('eggProgress', $ALL)
    $etick = $egg.GetMethod('CompTick', $DECL)
    if ($null -eq $prog)  { $problems += 'CompEggLayer has no eggProgress field' }
    elseif ($null -eq $etick) { $problems += 'CompEggLayer no longer declares CompTick' }
    elseif (-not (Test-FieldTouched -Method $etick -Field $prog -OpCode 0x7D)) {
        $problems += 'CompEggLayer.CompTick no longer stores into eggProgress: same silent no-op'
    }

    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# Why Thing.Ingested and not IngestedCalculateAmounts: one is a funnel, the other is an override
# point. Patching a virtual method reaches only the declaring class, so every food whose def
# overrides it would go unseen.
Test-Case 'Thing.Ingested is the non-virtual funnel, and IngestedCalculateAmounts is not' {
    $thing = Get-GameType 'Verse.Thing'
    $ing   = $thing.GetMethod('Ingested', $ALL)
    if ($null -eq $ing) { return 'Verse.Thing no longer declares Ingested' }
    if ($ing.IsVirtual) {
        return 'Thing.Ingested has become virtual: subclasses can now override it, and a postfix
on the base would miss every food that does'
    }

    $calc = $thing.GetMethod('IngestedCalculateAmounts', $ALL)
    if ($null -eq $calc) {
        return 'IngestedCalculateAmounts is gone, so the comparison the remarks rest on is stale'
    }
    if (-not $calc.IsVirtual) {
        return 'IngestedCalculateAmounts is no longer virtual, which removes the reason for
preferring Ingested; the choice should be re-examined rather than inherited'
    }
}

# ================================================================ 2. The patches

Group 'Every patch still lands on something'

# The attribute is read as data rather than instantiated, so this works whatever Harmony version
# is on the machine. A patch whose target has been renamed throws once at startup and the whole
# mod is then inert.
$patchAttr = 'HarmonyLib.HarmonyPatch'
$script:patchedTargets = @()

Test-Case 'Every [HarmonyPatch] in the assembly names a method the game still has' {
    $problems = @()
    foreach ($t in $modTypes) {
        foreach ($a in $t.GetCustomAttributesData()) {
            if ($a.AttributeType.FullName -ne $patchAttr) { continue }
            $args = @($a.ConstructorArguments)
            if ($args.Count -lt 2) { continue }

            $targetType = [Type]$args[0].Value
            $methodName = [string]$args[1].Value
            if ($null -eq $targetType) { $problems += "$($t.Name): patches a type that no longer resolves"; continue }

            $m = $targetType.GetMethod($methodName, $ALL)
            if ($null -eq $m) {
                $problems += "$($t.Name): $($targetType.Name).$methodName does not exist any more"
            } else {
                $script:patchedTargets += ,@($t, $targetType, $m)
            }
        }
    }
    if ($script:patchedTargets.Count -eq 0) { $problems += 'no HarmonyPatch attribute found at all' }
    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# Harmony matches injected parameters by name and checks their types at patch time. A __instance
# typed against the wrong class, or a __state whose two halves disagree, is refused at startup
# with the rest of the mod.
Test-Case 'Injected parameters agree with the methods they are injected into' {
    $problems = @()
    foreach ($entry in $script:patchedTargets) {
        $patchClass = $entry[0]; $targetType = $entry[1]; $target = $entry[2]

        $stateTypes = @{}
        foreach ($fn in @('Prefix', 'Postfix')) {
            $fix = $patchClass.GetMethod($fn, $DECL)
            if ($null -eq $fix) { continue }

            foreach ($p in $fix.GetParameters()) {
                $pt = $p.ParameterType
                if ($pt.IsByRef) { $pt = $pt.GetElementType() }

                if ($p.Name -eq '__instance' -and -not $pt.IsAssignableFrom($targetType)) {
                    $problems += "$($patchClass.Name).$fn : __instance is $($pt.Name) but the patch targets $($targetType.Name)"
                }
                if ($p.Name -eq '__result' -and $pt -ne $target.ReturnType) {
                    $problems += "$($patchClass.Name).$fn : __result is $($pt.Name) but $($target.Name) returns $($target.ReturnType.Name)"
                }
                if ($p.Name -eq '__state') { $stateTypes[$fn] = $pt.FullName }
            }
        }

        if ($stateTypes.Count -eq 2 -and $stateTypes['Prefix'] -ne $stateTypes['Postfix']) {
            $problems += "$($patchClass.Name): __state is $($stateTypes['Prefix']) in the prefix and $($stateTypes['Postfix']) in the postfix"
        }
    }
    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# The trap of a publicised build, and the test that found it. fullness is protected and
# eggProgress is private in the real Assembly-CSharp; Krafs.Rimworld.Ref ships them public, so the
# source compiles clean and the compiler emits a plain cross-assembly ldfld. That instruction is
# legal only if the assembly carries IgnoresAccessChecksTo("Assembly-CSharp"), and nothing in a
# build log says whether it does.
#
# So this does not look for the attribute - it performs the access. The two comps are plain
# classes with no Unity state, they construct here, and the mod's own prefix is called on one.
# A verdict from a FieldAccessException raised by the CLR is worth more than one read off metadata.
Test-Case 'The patches can really touch the fields they wrap' {
    $problems = @()

    $cases = New-Object System.Collections.ArrayList
    [void]$cases.Add(@('RimWorld.CompMilkable',  'Patch_GatherableFullness', 'fullness'))
    [void]$cases.Add(@('RimWorld.CompEggLayer',  'Patch_EggProgress',        'eggProgress'))

    foreach ($case in $cases) {
        $compType  = Get-GameType $case[0]
        $patchType = $modTypes | Where-Object { $_.Name -eq $case[1] } | Select-Object -First 1
        if ($null -eq $compType)  { $problems += "$($case[0]) is gone from the game"; continue }
        if ($null -eq $patchType) { $problems += "$($case[1]) is gone from the mod"; continue }

        $prefix = $patchType.GetMethod('Prefix', [System.Reflection.BindingFlags]'Public,Static,DeclaredOnly')
        if ($null -eq $prefix) { $problems += "$($case[1]) has no public static Prefix"; continue }

        try {
            $comp = [Activator]::CreateInstance($compType)
            $call = [object[]]@($comp, [float]0)
            [void]$prefix.Invoke($null, $call)
        } catch {
            $e = $_.Exception
            while ($e.InnerException) { $e = $e.InnerException }
            if ($e -is [System.FieldAccessException]) {
                $problems += "$($case[1]).Prefix cannot read $($case[0]).$($case[2]) at runtime.
The field is not public in the real assembly, the reference assembly says it is, and the mod
carries no IgnoresAccessChecksTo(`"Assembly-CSharp`") to make the access legal. Every animal of
this kind throws on its first tick and the whole scaling half of the mod is dead."
            } else {
                $problems += "$($case[1]).Prefix threw $($e.GetType().Name): $($e.Message)"
            }
        }
    }

    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# The test above performs the access, which is the strongest evidence there is, but it can only do
# it where an instance can be built - two comps. This one asks the wider question by reading the
# mod's whole IL: which members of the game does it touch that are not public, and is the waiver
# that makes those legal actually declared?
#
# Written after the first version of this file hardcoded two fields and would have missed a third.
# Pawn_NeedsTracker.pawn is private and is read by the ShouldHaveNeed postfix, which is the path
# that grants the need at all - so the fault that shipped once was wider than it first looked.
#
# Four other non-public members come up and are deliberately NOT faults: Need.pawn,
# Need.threshPercents, Need.IsFrozen and the ModSettings constructor are protected, and reached
# from a class that derives from their own. That is legal C# with no waiver of any kind, so the
# scan excludes an access whose own type is a subclass of the declaring one. Without that rule the
# test would cry wolf on every well-formed Need subclass in existence.
Test-Case 'Every non-public game member the mod touches is covered by the waiver' {
    $fieldOps  = @{ 0x7B=1; 0x7C=1; 0x7D=1; 0x7E=1; 0x7F=1; 0x80=1 }
    $methodOps = @{ 0x28=1; 0x6F=1; 0x73=1 }

    $atRisk = @{}
    foreach ($t in $modTypes) {
        $members = @($t.GetMethods($DECL)) + @($t.GetConstructors($DECL))
        foreach ($meth in $members) {
            $body = $null
            try { $body = $meth.GetMethodBody() } catch { }
            if ($null -eq $body) { continue }
            $il = $body.GetILAsByteArray()
            if ($null -eq $il) { continue }

            for ($i = 0; $i -lt $il.Length - 4; $i++) {
                $op = [int]$il[$i]
                $isField = $fieldOps.ContainsKey($op)
                if (-not ($isField -or $methodOps.ContainsKey($op))) { continue }
                $tok = [BitConverter]::ToInt32($il, $i + 1)

                $member = $null
                try {
                    if ($isField) { $member = $meth.Module.ResolveField($tok) }
                    else { $member = $meth.Module.ResolveMethod($tok) }
                } catch { continue }
                if ($null -eq $member -or $null -eq $member.DeclaringType) { continue }
                if ($member.DeclaringType.Assembly.GetName().Name -ne 'Assembly-CSharp') { continue }
                if ($member.IsPublic) { continue }

                # protected, reached from a subclass through `this`: legal, no waiver involved
                if ($member.DeclaringType.IsAssignableFrom($t)) { continue }

                $atRisk['{0}.{1}' -f $member.DeclaringType.FullName, $member.Name] = $t.Name
            }
        }
    }

    if ($atRisk.Count -eq 0) { return }

    $waived = $false
    foreach ($a in [System.Reflection.CustomAttributeData]::GetCustomAttributes($modAsm)) {
        if ($a.AttributeType.Name -notlike 'IgnoresAccessChecksTo*') { continue }
        foreach ($arg in $a.ConstructorArguments) {
            if ([string]$arg.Value -eq 'Assembly-CSharp') { $waived = $true }
        }
    }

    if (-not $waived) {
        $lines = foreach ($k in ($atRisk.Keys | Sort-Object)) { "  $k  (from $($atRisk[$k]))" }
        return ("the mod touches these non-public members of the game:`n" + ($lines -join "`n") + "`n
and its assembly declares no IgnoresAccessChecksTo(`"Assembly-CSharp`"). Each of them throws
FieldAccessException or MethodAccessException the first time it is reached.")
    }
}

# The reason the need cannot be restricted by its def alone, stated as a fact about NeedDef rather
# than as a claim in a comment. If a ceiling ever appears, the ShouldHaveNeed postfix becomes
# removable, and the mod gets smaller.
Test-Case 'NeedDef still has a floor on intelligence and no ceiling' {
    $nd = Get-GameType 'RimWorld.NeedDef'
    if ($null -eq $nd) { return 'RimWorld.NeedDef is gone' }
    if ($null -eq $nd.GetField('minIntelligence', $ALL)) {
        return 'NeedDef.minIntelligence no longer exists, so the remarks in Patch_ShouldHaveNeed
describe a game that has changed'
    }
    $ceiling = $nd.GetFields($ALL) | Where-Object { $_.Name -match 'max.*Intelligence' }
    if ($ceiling) {
        return "NeedDef now has $($ceiling[0].Name): the postfix on ShouldHaveNeed may no longer
be necessary, and a def-only restriction would be simpler"
    }
}

# Computed from the game's own data at every run rather than copied into this file, on the same
# principle as the trait ceilings in A Perfect Mind: a recopied table ages in silence.
Test-Case 'Food and Rest are still the only Core needs that leave minIntelligence at its default' {
    $dir = Join-Path $GameData 'Core\Defs\NeedDefs'
    if (-not (Test-Path $dir)) { return "Core NeedDefs not found under $dir" }

    $open = @()
    foreach ($file in Get-ChildItem $dir -Filter '*.xml') {
        [xml]$doc = Get-Content $file.FullName -Raw
        foreach ($def in $doc.SelectNodes('//NeedDef')) {
            $name = $def.SelectSingleNode('defName')
            if ($null -eq $name) { continue }
            if ($null -eq $def.SelectSingleNode('minIntelligence')) { $open += $name.InnerText }
        }
    }

    $expected = @('Food', 'Rest')
    $extra   = @($open | Where-Object { $expected -notcontains $_ })
    $missing = @($expected | Where-Object { $open -notcontains $_ })
    if ($extra.Count -gt 0 -or $missing.Count -gt 0) {
        return "Core needs open to animals are now: $($open -join ', ').
That set is the whole reason animals carry two needs and no more; a change here changes what
this mod is adding to."
    }
}

# ================================================================ 3. The mod's own code

Group 'The mod, instantiated and called'

$settingsType = $modTypes | Where-Object { $_.Name -eq 'ContentedLivestockSettings' } | Select-Object -First 1
$contentment  = $modTypes | Where-Object { $_.Name -eq 'Contentment' } | Select-Object -First 1

# The corollary the README rests on: absence of the need is the neutral value, not a special case.
# It is what makes the mod safe to add to and remove from a running save, and it is reachable
# from here because every one of these paths bails out before it touches anything Unity holds.
#
# The settings have to be planted first, and that is not a detail. RateFactor opens with
# "if (settings == null) return 1f", so outside the game it returns 1 at the FIRST guard and never
# reaches the one this test is about. Written without this, the test passed while the branch it
# claimed to cover was dead - the mutation that made that branch return 0.5 woke nothing at all.
Test-Case 'An animal with no need is worth exactly the vanilla rate, and nothing throws' {
    if ($null -eq $contentment) { return 'the Contentment class is missing from the assembly' }
    if ($null -eq $settingsType) { return 'the settings class is missing from the assembly' }
    $problems = @()

    $modClass = $modTypes | Where-Object { $_.Name -eq 'ContentedLivestockMod' } | Select-Object -First 1
    $backing = $null
    if ($null -ne $modClass) {
        $backing = $modClass.GetField('<Settings>k__BackingField', [System.Reflection.BindingFlags]'NonPublic,Static')
    }
    if ($null -eq $backing) {
        $problems += 'ContentedLivestockMod.Settings has no static backing field to plant: this
test cannot reach past the settings guard in RateFactor, and would pass without proving anything'
    } else {
        $backing.SetValue($null, [Activator]::CreateInstance($settingsType))
    }

    $rate = $contentment.GetMethod('RateFactor', $ALL).Invoke($null, @($null))
    if ($rate -ne 1.0) { $problems += "RateFactor(no animal) returned $rate, expected exactly 1" }

    # And the other guard, on its own: no settings at all is neutral too.
    if ($null -ne $backing) {
        $backing.SetValue($null, $null)
        $rateOff = $contentment.GetMethod('RateFactor', $ALL).Invoke($null, @($null))
        if ($rateOff -ne 1.0) { $problems += "RateFactor with no settings loaded returned $rateOff, expected exactly 1" }
    }

    $level = $contentment.GetMethod('LevelOf', $ALL).Invoke($null, @($null))
    if ($level -ne 1.0) { $problems += "LevelOf(no animal) returned $level, expected exactly 1" }

    $applies = $contentment.GetMethod('AppliesTo', $ALL).Invoke($null, @($null))
    if ($applies) { $problems += 'AppliesTo(no animal) returned true' }

    $produces = $contentment.GetMethod('Produces', $ALL).Invoke($null, @($null))
    if ($produces) { $problems += 'Produces(no animal) returned true' }

    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# The four numbers the README and the CHANGELOG quote in percent. They are the curve, so a change
# to one of them without a change to the prose leaves the documentation lying.
Test-Case 'The documented curve is the shipped default, and it is monotonic' {
    if ($null -eq $settingsType) { return 'the settings class is missing from the assembly' }
    $s = [Activator]::CreateInstance($settingsType)

    $expected = @{ floorLevel = 0.25; plateauLevel = 0.60; minRateFactor = 0.40; maxRateFactor = 1.40 }
    $problems = @()
    foreach ($k in $expected.Keys) {
        $got = $settingsType.GetField($k, $ALL).GetValue($s)
        if ([Math]::Abs($got - $expected[$k]) -gt 0.0001) {
            $problems += "$k is $got, but the documentation says $($expected[$k])"
        }
    }

    $floor   = $settingsType.GetField('floorLevel', $ALL).GetValue($s)
    $plateau = $settingsType.GetField('plateauLevel', $ALL).GetValue($s)
    $minR    = $settingsType.GetField('minRateFactor', $ALL).GetValue($s)
    $maxR    = $settingsType.GetField('maxRateFactor', $ALL).GetValue($s)

    if ($floor -ge $plateau) { $problems += "floor $floor is not below plateau ${plateau}: the ramp between them would be a division by zero if the code did not guard it" }
    if ($minR -ge 1.0)       { $problems += "minRateFactor $minR is not below 1: a barely-fed animal would out-produce a well-kept one" }
    if ($maxR -le 1.0)       { $problems += "maxRateFactor $maxR is not above 1: contentment could never beat the vanilla rate, and the mod would only ever be a penalty" }

    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# Reset() is written by hand, field by field. Adding a setting and forgetting this method leaves
# a "restore defaults" button that restores all but one - the kind of thing nobody notices until
# a player reports it.
Test-Case 'Reset restores every field of the settings, not just the ones someone remembered' {
    $fields = $settingsType.GetFields([System.Reflection.BindingFlags]'Public,Instance') |
        Where-Object { $_.FieldType -eq [float] -or $_.FieldType -eq [bool] }
    if ($fields.Count -eq 0) { return 'the settings class has no float or bool fields to check' }

    $fresh = [Activator]::CreateInstance($settingsType)
    $dirty = [Activator]::CreateInstance($settingsType)

    foreach ($f in $fields) {
        if ($f.FieldType -eq [bool]) { $f.SetValue($dirty, -not [bool]$f.GetValue($fresh)) }
        else { $f.SetValue($dirty, [float]([float]$f.GetValue($fresh) + 0.123)) }
    }

    $settingsType.GetMethod('Reset', $ALL).Invoke($dirty, @())

    $stale = @()
    foreach ($f in $fields) {
        $a = $f.GetValue($fresh); $b = $f.GetValue($dirty)
        if ($f.FieldType -eq [float]) { if ([Math]::Abs([float]$a - [float]$b) -gt 0.0001) { $stale += $f.Name } }
        elseif ($a -ne $b) { $stale += $f.Name }
    }
    if ($stale.Count -gt 0) {
        return "Reset() leaves these fields untouched: $($stale -join ', ')"
    }
}

# Scribe keys are string literals sitting next to the field they save. A typo in one of them does
# not fail to compile and does not fail to save: it saves under a name nothing reads back, and the
# setting silently returns to its default at the next launch.
Test-Case 'Every setting is saved under its own name' {
    $expose = $settingsType.GetMethod('ExposeData', $DECL)
    if ($null -eq $expose) { return 'the settings class does not override ExposeData, so nothing is saved at all' }

    $literals = Get-StringLiterals $expose
    $fields = $settingsType.GetFields([System.Reflection.BindingFlags]'Public,Instance') |
        Where-Object { $_.FieldType -eq [float] -or $_.FieldType -eq [bool] }

    $unsaved = @()
    foreach ($f in $fields) { if ($literals -notcontains $f.Name) { $unsaved += $f.Name } }
    if ($unsaved.Count -gt 0) {
        return "these settings are not written under their own field name: $($unsaved -join ', ').
Literals actually found in ExposeData: $($literals -join ', ')"
    }
}

# ================================================================ 4. Defs and text

Group 'The def, its DefOf and the text'

$needDefFile = Join-Path $ModPath 'Mod\Defs\NeedDefs\Needs_Contentment.xml'

Test-Case 'The need def names this mod class, and leaves minIntelligence alone' {
    if (-not (Test-Path $needDefFile)) { return "the need def is missing: $needDefFile" }
    [xml]$doc = Get-Content $needDefFile -Raw

    $def = $doc.SelectSingleNode('//NeedDef')
    if ($null -eq $def) { return 'no NeedDef in the file' }

    $problems = @()
    $needClass = $def.SelectSingleNode('needClass')
    if ($null -eq $needClass) { $problems += 'the def declares no needClass' }
    else {
        $t = $modTypes | Where-Object { $_.FullName -eq $needClass.InnerText -or $_.Name -eq $needClass.InnerText } | Select-Object -First 1
        if ($null -eq $t) { $problems += "needClass $($needClass.InnerText) is in no assembly this mod ships" }
        else {
            $need = Get-GameType 'RimWorld.Need'
            if (-not $need.IsAssignableFrom($t)) { $problems += "$($t.FullName) does not derive from RimWorld.Need" }
        }
    }

    # The one line that would silently kill the mod: minIntelligence is a floor, and Humanlike on
    # this def would keep the need off every animal while leaving everything else looking healthy.
    $mi = $def.SelectSingleNode('minIntelligence')
    if ($null -ne $mi -and $mi.InnerText -ne 'Animal') {
        $problems += "the def sets minIntelligence to $($mi.InnerText): that is a floor, and
anything above Animal keeps the need off the animals this mod is for"
    }

    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# A DefOf field whose name is not a defName throws at startup, before anything else of the mod
# runs. The field is read by type here rather than by name, so the test still reports the truth
# when it is the name that is wrong.
Test-Case 'Every DefOf field is a defName this mod actually declares' {
    $defOf = $modTypes | Where-Object { $_.Name -eq 'ContentedLivestockDefOf' } | Select-Object -First 1
    if ($null -eq $defOf) { return 'no DefOf class in the assembly' }

    $declared = @()
    foreach ($file in Get-ChildItem (Join-Path $ModPath 'Mod\Defs') -Recurse -Filter '*.xml') {
        [xml]$doc = Get-Content $file.FullName -Raw
        foreach ($n in $doc.SelectNodes('//defName')) { $declared += $n.InnerText }
    }

    $missing = @()
    foreach ($f in $defOf.GetFields([System.Reflection.BindingFlags]'Public,Static')) {
        if ($declared -notcontains $f.Name) { $missing += $f.Name }
    }
    if ($missing.Count -gt 0) {
        return "these DefOf fields match no defName in Mod/Defs: $($missing -join ', ').
DefOfHelper throws on the first of them at startup, before any patch is applied."
    }
}

# Translate() on a key nobody defined renders the key itself in the interface. It is not an error,
# it is a label reading "ContentedLivestock.Tip.Feed" in the middle of an inspect pane.
Test-Case 'Every key the code asks to translate exists in English and in French' {
    $asked = @()
    foreach ($t in $modTypes) {
        foreach ($m in $t.GetMethods($DECL)) {
            foreach ($s in (Get-StringLiterals $m)) {
                if ($s -like 'ContentedLivestock.*') { $asked += $s }
            }
        }
    }
    $asked = $asked | Select-Object -Unique
    if ($asked.Count -eq 0) { return 'no translation key found in the assembly at all' }

    $problems = @()
    foreach ($lang in @('English', 'French')) {
        $dir = Join-Path $ModPath "Mod\Languages\$lang\Keyed"
        if (-not (Test-Path $dir)) { $problems += "$lang has no Keyed folder"; continue }

        $have = @()
        foreach ($file in Get-ChildItem $dir -Filter '*.xml') {
            [xml]$doc = Get-Content $file.FullName -Raw
            foreach ($n in $doc.DocumentElement.ChildNodes) {
                if ($n.NodeType -eq 'Element') { $have += $n.Name }
            }
        }

        $missing = @($asked | Where-Object { $have -notcontains $_ })
        if ($missing.Count -gt 0) { $problems += "$lang is missing: $($missing -join ', ')" }
    }
    if ($problems.Count -gt 0) { return ($problems -join "`n") }
}

# ---------------------------------------------------------------- verdict

Test-Case 'All shipped XML parses and translation keys are unique' {
    foreach ($file in Get-ChildItem (Join-Path $ModPath 'Mod') -Recurse -Filter '*.xml') {
        [xml]$doc = Get-Content $file.FullName -Raw
        if ($doc.DocumentElement.Name -eq 'LanguageData') {
            $duplicates = $doc.DocumentElement.ChildNodes | Where-Object NodeType -eq 'Element' |
                Group-Object Name | Where-Object Count -gt 1
            if ($duplicates) { return "Duplicate translation keys in $($file.FullName): $($duplicates.Name -join ', ')" }
        }
    }
}

Test-Case 'NeedDef XML fields exist in the actual game and scalar values have valid types' {
    [xml]$doc = Get-Content $needDefFile -Raw
    $type = Get-GameType 'RimWorld.NeedDef'
    foreach ($node in $doc.SelectSingleNode('//NeedDef').ChildNodes) {
        if ($node.NodeType -ne 'Element') { continue }
        $field = $type.GetField($node.Name, $ALL)
        if ($null -eq $field) { return "Unknown NeedDef field: $($node.Name)" }
        $ft = $field.FieldType
        if ($ft.IsEnum) { $null = [Enum]::Parse($ft, $node.InnerText, $false) }
        elseif ($ft.IsPrimitive) {
            $null = [Convert]::ChangeType($node.InnerText, $ft, [Globalization.CultureInfo]::InvariantCulture)
        }
    }
}

Test-Case 'DefInjected translations target declared Defs and translatable fields' {
    $declared = @{}
    foreach ($file in Get-ChildItem (Join-Path $ModPath 'Mod/Defs') -Recurse -Filter '*.xml') {
        [xml]$doc = Get-Content $file.FullName -Raw
        foreach ($def in $doc.Defs.ChildNodes | Where-Object NodeType -eq Element) {
            $declared[$def.defName] = $def.Name
        }
    }
    foreach ($file in Get-ChildItem (Join-Path $ModPath 'Mod/Languages') -Recurse -Filter '*.xml' |
        Where-Object { $_.FullName -match '[\\/]DefInjected[\\/]' }) {
        [xml]$translation = Get-Content $file.FullName -Raw
        foreach ($node in $translation.DocumentElement.ChildNodes) {
            if ($node.NodeType -ne 'Element') { continue }
            $parts = $node.Name.Split('.')
            if ($parts.Count -ne 2 -or $declared[$parts[0]] -ne $file.Directory.Name -or
                @('label', 'description') -notcontains $parts[1]) {
                return "Invalid DefInjected target: $($node.Name)"
            }
        }
    }
}

Test-Case 'About metadata identifies this repository and includes GitHub in its description' {
    [xml]$about = Get-Content (Join-Path $ModPath 'Mod/About/About.xml') -Raw
    $url = 'https://github.com/vbardales/Rimworld-Contented-Livestock'
    if ($about.ModMetaData.packageId -ne 'nelim.contentedlivestock') { return 'Wrong packageId' }
    if ($about.ModMetaData.url -ne $url) { return 'Wrong source URL' }
    if (-not $about.ModMetaData.description.Contains($url)) { return 'Description has no GitHub link' }
}

. (Join-Path $PSScriptRoot 'Settings-Tests.ps1')

[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)

Write-Host ''
if ($script:failed -eq 0) {
    Write-Host "  $($script:total) tests, all passing." -ForegroundColor Green
    exit 0
} else {
    Write-Host "  $($script:total) tests, $($script:failed) failing." -ForegroundColor Red
    exit 1
}


<#
  SEEN TO FAIL

  Twelve tests, each woken by one fault applied on its own to a copy of the mod in a scratch
  directory, never to the real files. The test named is the one that went red.

    the access waiver removed             The patches can really touch the fields they wrap
                                          Every non-public game member ... covered by the waiver
    a patched method misspelt             Every [HarmonyPatch] ... names a method the game still has
    __state typed double in a prefix      Injected parameters agree ...
    __result typed int                    Injected parameters agree ...
    maxRateFactor lowered to 0.9          The documented curve is the shipped default ...
    companyMatters dropped from Reset()   Reset restores every field of the settings ...
    a scribe key misspelt                 Every setting is saved under its own name
    the DefOf field renamed               Every DefOf field is a defName this mod actually declares
    minIntelligence Humanlike on the def  The need def names this mod class ...
    needClass pointed at a non-Need       The need def names this mod class ...
    a French key removed                  Every key the code asks to translate ...
    a key renamed in the code             Every key the code asks to translate ...
    RateFactor made to return 0.5         An animal with no need is worth exactly the vanilla rate
    a Core need opened to animals         Food and Rest are still the only Core needs ...
                                          (on a doctored copy of Data passed as -GameData)

  NOT SEEN TO FAIL, and why

  Five tests assert facts about Assembly-CSharp itself - that CompTick is declared once and
  overridden by nobody, that ResourceAmount is overridden, that CompTick is what stores into
  fullness and eggProgress, that Thing.Ingested is not virtual, and that NeedDef has a floor on
  intelligence and no ceiling. Making any of them fail would mean rewriting the game's assembly,
  which is not worth building a rig for. What stands in for a mutation is that each one READS the
  game rather than restating the mod: none of them can pass by agreeing with a comment.

  WHAT THE MUTATIONS TAUGHT, and it is the point of running them

    - The neutral-value test passed while the branch it named was dead. RateFactor opens with
      "if (settings == null) return 1f", and outside the game that is always true, so the test
      never reached the "no need" branch it claimed to cover. Making that branch return 0.5 woke
      nothing at all. The test now plants a settings instance in the static backing field first.
    - Two mutations woke a second test as well, and in both cases the second was right, not noise.
      Lowering maxRateFactor to 0.9 also breaks Reset(), because the field initialiser and Reset()
      then disagree about the default - which is a real fault of its own. Typing __state as double
      also stops the access test from calling that prefix at all, and it says so.
    - A mutation has to be buildable. Renaming the DefOf field in two files left a third
      referring to the old name, and the copy simply failed to compile: the run reported a build
      failure rather than a sleeping test, which is the honest outcome but not a result.
    - A guard written around the two members someone happened to think of is not a guard. The
      access test names CompMilkable and CompEggLayer because those are the two that can be
      instantiated here; scanning the whole assembly afterwards turned up a THIRD non-public
      member with no instance to build - Pawn_NeedsTracker.pawn, private, read by the postfix
      that grants the need at all. Hence the wider test beside it, which enumerates rather than
      lists. It also has to exclude the four protected members reached from their own subclasses,
      Need.pawn among them: those need no waiver and would otherwise be four false alarms.
#>
