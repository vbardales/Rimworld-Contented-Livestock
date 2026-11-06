<#
.SYNOPSIS
  Own values and facts of this mod: what its four Harmony patches and its one Need bet on in the game, and its settings logic.

.DESCRIPTION
  One consumer, so nothing here is shareable (scripts/LOCAL_SCRIPTS.md). Tests/Test-Mod.ps1 (generated) runs it after the shared
  checks. It reads the game's own assembly and the shipped DLL by reflection and IL: RimWorld is never started. Without the game
  (the GitHub runner) it SKIPS loudly and exits 0: that is not a pass.

  Every one of the patches below is a bet on a vanilla member that fails SILENTLY when lost, so the facts are read off the game,
  not restated from a comment:
    hooks     CompTick is declared once and overridden by nobody; ResourceAmount is overridden (why the tick); CompTick is what
              writes fullness and eggProgress; Thing.Ingested is the non-virtual funnel; NeedDef has a floor and no ceiling on
              intelligence; Food and Rest are the only Core needs open to animals.
    settings  defaults, bounds, curve, input toggles, interval step, Reset, Scribe of the float options (the bool options go to
              the shared Test-ScribeSettings), neutral value of an animal with no need.
    wiring    the hidden shortcut and its worker, production uses the tested settings logic, producer detection.
    content   the need def, About identity and the Harmony dependency.
  Cut on 2026-11-05 to shared checks (docs/LOCAL-SCRIPTS-REVIEW-2026-11-04.md): IL helpers and harness (lib/GameReflection,
  lib/TestRunner), injected-parameter agreement and field access (Check-HarmonyContract), DefOf, keys, parse, NeedDef fields,
  DefInjected (Check-DefRefs, Check-Translations, Check-DefInjected, Check-ModBasics), bool Scribe round trip (lib/ScribeSettings).

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File Tests\Rule-OwnValues.ps1
#>
param(
    [string]$ModRoot,
    [string]$SharedDir,
    [string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$HarmonyPath = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2009463077\1.6\Assemblies'
)

$ErrorActionPreference = 'Stop'
if (-not $ModRoot) { $ModRoot = Split-Path -Parent $PSScriptRoot }
if (-not $SharedDir) { $SharedDir = Join-Path $ModRoot '..\scripts' }
$ModRoot = (Resolve-Path -LiteralPath $ModRoot).Path
$ModPath = Join-Path $ModRoot 'Mod'

$modDll = Join-Path $ModPath 'Assemblies\ContentedLivestock.dll'
if (-not (Test-Path (Join-Path $Managed 'Assembly-CSharp.dll')) -or -not (Test-Path (Join-Path $HarmonyPath '0Harmony.dll'))) {
    Write-Host 'WARNING Rule-OwnValues needs the game and the Workshop Harmony 1.6: SKIPPED, not passed' -ForegroundColor Yellow
    exit 0
}
if (-not (Test-Path $modDll)) { Write-Host "FAIL $modDll not found: build Source/ first" -ForegroundColor Red; exit 1 }

. (Join-Path $SharedDir 'lib\TestRunner.ps1')
. (Join-Path $SharedDir 'lib\GameReflection.ps1')
. (Join-Path $SharedDir 'lib\ScribeSettings.ps1')
Initialize-GameReflection -Managed $Managed -ExtraDirs @($HarmonyPath)

$gameTypes = Get-AssemblyTypes (Join-Path $Managed 'Assembly-CSharp.dll')
$byName = New-TypeIndex $gameTypes
$modAsm = [System.Reflection.Assembly]::LoadFrom($modDll)
$modTypes = Get-AssemblyTypes $modDll

$ALL = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'
$DECL = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'
function Get-GameType([string]$full) { if ($byName.ContainsKey($full)) { return $byName[$full] }; return $null }

# A field access instruction carries a 4-byte token that IS the field's MetadataToken inside one module.
function Test-FieldTouched([System.Reflection.MethodBase]$Method, [System.Reflection.FieldInfo]$Field, [byte]$OpCode) {
    $body = $Method.GetMethodBody()
    if ($null -eq $body) { return $false }
    $il = $body.GetILAsByteArray()
    if ($null -eq $il) { return $false }
    for ($i = 0; $i -lt $il.Length - 4; $i++) {
        if ($il[$i] -eq $OpCode -and [BitConverter]::ToInt32($il, $i + 1) -eq $Field.MetadataToken) { return $true }
    }
    return $false
}

$settingsType = $modAsm.GetType('ContentedLivestock.ContentedLivestockSettings', $true)
$contentment = $modAsm.GetType('ContentedLivestock.Contentment', $true)
function New-Settings { [Activator]::CreateInstance($settingsType) }
function Assert-Near([double]$actual, [double]$expected, [string]$context) {
    if ([double]::IsNaN($actual) -or [Math]::Abs($actual - $expected) -gt 0.00001) { throw "$context : expected $expected, got $actual" }
}
function Assert-SettingsEqual($actual, $expected) {
    foreach ($field in $settingsType.GetFields([System.Reflection.BindingFlags]'Public,Instance')) {
        if ($field.FieldType -eq [float]) { Assert-Near $field.GetValue($actual) $field.GetValue($expected) $field.Name }
        elseif ($field.FieldType -eq [bool] -and $field.GetValue($actual) -ne $field.GetValue($expected)) { throw $field.Name }
    }
}

Write-Host ''
Write-Host 'Contented Livestock: own values' -ForegroundColor White

# ---------------------------------------------------------------- the hooks

It 'CompTick is declared once on the gatherable comp and overridden by no vanilla subclass' {
    $base = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    if ($null -eq $base) { return 'CompHasGatherableBodyResource is gone from the game' }
    if ($null -eq $base.GetMethod('CompTick', $DECL)) { return 'CompHasGatherableBodyResource no longer declares CompTick' }
    $offenders = @($gameTypes | Where-Object { $_ -ne $base -and $base.IsAssignableFrom($_) -and $_.GetMethod('CompTick', $DECL) } | ForEach-Object { $_.FullName })
    if ($offenders.Count) { "these subclasses override CompTick and so escape the patch: $($offenders -join ', ')" }
}

It 'ResourceAmount is overridden by subclasses, which is why the tick was chosen instead' {
    $base = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    $overriders = @($gameTypes | Where-Object { $_ -ne $base -and $base.IsAssignableFrom($_) -and $_.GetProperty('ResourceAmount', $DECL) })
    if ($overriders.Count -eq 0) { 'no subclass overrides ResourceAmount any more: the comment in Patch_Production.cs describes a game that no longer exists' }
}

It 'CompTick is what writes fullness, and CompEggLayer.CompTick what writes eggProgress' {
    $gather = Get-GameType 'RimWorld.CompHasGatherableBodyResource'
    $field = $gather.GetField('fullness', $ALL)
    if ($null -eq $field) { 'CompHasGatherableBodyResource has no fullness field' }
    elseif (-not (Test-FieldTouched $gather.GetMethod('CompTick', $DECL) $field 0x7D)) { 'CompHasGatherableBodyResource.CompTick no longer stores into fullness: the patch pair would wrap a method that changes nothing' }
    $egg = Get-GameType 'RimWorld.CompEggLayer'
    $prog = $egg.GetField('eggProgress', $ALL)
    $tick = $egg.GetMethod('CompTick', $DECL)
    if ($null -eq $prog) { 'CompEggLayer has no eggProgress field' }
    elseif ($null -eq $tick) { 'CompEggLayer no longer declares CompTick' }
    elseif (-not (Test-FieldTouched $tick $prog 0x7D)) { 'CompEggLayer.CompTick no longer stores into eggProgress: same silent no-op' }
}

It 'Thing.Ingested is the non-virtual funnel, and IngestedCalculateAmounts is virtual' {
    $thing = Get-GameType 'Verse.Thing'
    $ing = $thing.GetMethod('Ingested', $ALL)
    if ($null -eq $ing) { return 'Verse.Thing no longer declares Ingested' }
    if ($ing.IsVirtual) { 'Thing.Ingested has become virtual: a postfix on the base would miss every food that overrides it' }
    $calc = $thing.GetMethod('IngestedCalculateAmounts', $ALL)
    if ($null -eq $calc) { 'IngestedCalculateAmounts is gone, so the comparison the remarks rest on is stale' }
    elseif (-not $calc.IsVirtual) { 'IngestedCalculateAmounts is no longer virtual: the reason for preferring Ingested is gone' }
}

It 'NeedDef still has a floor on intelligence and no ceiling' {
    $nd = Get-GameType 'RimWorld.NeedDef'
    if ($null -eq $nd.GetField('minIntelligence', $ALL)) { return 'NeedDef.minIntelligence no longer exists' }
    $ceiling = @($nd.GetFields($ALL) | Where-Object { $_.Name -match 'max.*Intelligence' })
    if ($ceiling.Count) { "NeedDef now has $($ceiling[0].Name): the ShouldHaveNeed postfix may be removable" }
}

It 'Food and Rest are still the only Core needs that leave minIntelligence at its default' {
    $dir = Join-Path $GameData 'Core\Defs\NeedDefs'
    if (-not (Test-Path $dir)) { return "Core NeedDefs not found under $dir" }
    $open = @()
    foreach ($file in Get-ChildItem $dir -Filter '*.xml') {
        [xml]$doc = Read-Text $file.FullName
        foreach ($def in $doc.SelectNodes('//NeedDef')) {
            $name = $def.SelectSingleNode('defName')
            if ($null -ne $name -and $null -eq $def.SelectSingleNode('minIntelligence')) { $open += $name.InnerText }
        }
    }
    if (Compare-Object @('Food', 'Rest') @($open)) { "Core needs open to animals are now: $($open -join ', '): that set is the whole reason animals carry two needs and no more" }
}

# ---------------------------------------------------------------- settings logic

It 'An animal with no need is worth exactly the vanilla rate, and nothing throws' {
    # RateFactor opens with "if (settings == null) return 1f": the settings are planted first or the branch under test is never reached.
    $modClass = $modTypes | Where-Object { $_.Name -eq 'ContentedLivestockMod' } | Select-Object -First 1
    $backing = if ($modClass) { $modClass.GetField('<Settings>k__BackingField', [System.Reflection.BindingFlags]'NonPublic,Static') }
    if ($null -eq $backing) { return 'ContentedLivestockMod.Settings has no static backing field to plant: this test would pass without proving anything' }
    $backing.SetValue($null, (New-Settings))
    try {
        $rate = $contentment.GetMethod('RateFactor', $ALL).Invoke($null, @($null))
        if ($rate -ne 1.0) { "RateFactor(no animal) returned $rate, expected exactly 1" }
        $backing.SetValue($null, $null)
        $rateOff = $contentment.GetMethod('RateFactor', $ALL).Invoke($null, @($null))
        if ($rateOff -ne 1.0) { "RateFactor with no settings loaded returned $rateOff, expected exactly 1" }
    } finally { $backing.SetValue($null, $null) }
    $level = $contentment.GetMethod('LevelOf', $ALL).Invoke($null, @($null))
    if ($level -ne 1.0) { "LevelOf(no animal) returned $level, expected exactly 1" }
    if ($contentment.GetMethod('AppliesTo', $ALL).Invoke($null, @($null))) { 'AppliesTo(no animal) returned true' }
    if ($contentment.GetMethod('Produces', $ALL).Invoke($null, @($null))) { 'Produces(no animal) returned true' }
}

It 'All eleven first-use defaults and normalization are stable' {
    $s = New-Settings
    foreach ($entry in @{ floorLevel = 0.25; plateauLevel = 0.60; minRateFactor = 0.40; maxRateFactor = 1.40; adjustSpeed = 1.0 }.GetEnumerator()) { Assert-Near $s.($entry.Key) $entry.Value $entry.Key }
    foreach ($name in @('producersOnly', 'feedMatters', 'penMatters', 'temperatureMatters', 'healthMatters', 'companyMatters')) { if (-not $s.$name) { throw "Default $name must be true" } }
    $s.Normalize()
    Assert-SettingsEqual $s (New-Settings)
}

It 'Reset restores every field of the settings' {
    $fields = @($settingsType.GetFields([System.Reflection.BindingFlags]'Public,Instance') | Where-Object { $_.FieldType -eq [float] -or $_.FieldType -eq [bool] })
    if ($fields.Count -eq 0) { return 'the settings class has no float or bool fields to check' }
    $fresh = New-Settings; $dirty = New-Settings
    foreach ($f in $fields) {
        if ($f.FieldType -eq [bool]) { $f.SetValue($dirty, -not [bool]$f.GetValue($fresh)) } else { $f.SetValue($dirty, [float]([float]$f.GetValue($fresh) + 0.123)) }
    }
    $settingsType.GetMethod('Reset', $ALL).Invoke($dirty, @())
    $stale = @($fields | Where-Object { if ($_.FieldType -eq [float]) { [Math]::Abs([float]$_.GetValue($fresh) - [float]$_.GetValue($dirty)) -gt 0.0001 } else { $_.GetValue($fresh) -ne $_.GetValue($dirty) } } | ForEach-Object { $_.Name })
    if ($stale.Count) { "Reset() leaves these fields untouched: $($stale -join ', ')" }
}

It 'Numeric bounds, nonfinite values and crossed thresholds normalize safely' {
    $ranges = @{ floorLevel = @(0.0, 0.5, 0.25); plateauLevel = @(0.3, 0.9, 0.6); minRateFactor = @(0.0, 1.0, 0.4); maxRateFactor = @(1.0, 2.0, 1.4); adjustSpeed = @(0.25, 4.0, 1.0) }
    foreach ($name in $ranges.Keys) {
        $range = $ranges[$name]
        foreach ($sample in @(@(-99, $range[0]), @(99, $range[1]), @([float]::NaN, $range[2]), @([float]::PositiveInfinity, $range[2]), @([float]::NegativeInfinity, $range[2]))) {
            $s = New-Settings
            $s.$name = [float]$sample[0]
            $s.Normalize()
            Assert-Near $s.$name $sample[1] $name
            $first = $s.$name
            $s.Normalize()
            Assert-Near $s.$name $first 'normalization idempotence'
        }
    }
    $s = New-Settings
    $s.floorLevel = 0.5; $s.plateauLevel = 0.3; $s.Normalize()
    Assert-Near $s.plateauLevel 0.55 'crossed thresholds'
}

It 'The production curve follows the documented thresholds and stays monotonic at allowed extremes' {
    $s = New-Settings
    foreach ($point in @(@(0, 0), @(0.249, 0), @(0.25, 0.4), @(0.425, 0.7), @(0.6, 1), @(0.8, 1.2), @(1, 1.4))) { Assert-Near ($s.RateAt([float]$point[0])) $point[1] 'default curve' }
    foreach ($floor in @(0, 0.25, 0.5)) { foreach ($plateau in @(0.3, 0.6, 0.9)) { foreach ($min in @(0, 0.4, 1)) { foreach ($max in @(1, 1.4, 2)) {
        $s.floorLevel = $floor; $s.plateauLevel = $plateau; $s.minRateFactor = $min; $s.maxRateFactor = $max; $s.Normalize()
        $previous = -1.0
        for ($i = 0; $i -le 100; $i++) {
            $rate = $s.RateAt([float]($i / 100.0))
            if ([float]::IsNaN($rate) -or $rate -lt 0 -or $rate -gt 2.00001 -or $rate -lt $previous - 0.00001) { throw "Unsafe curve floor=$floor plateau=$plateau min=$min max=$max level=$i" }
            $previous = $rate
        }
        Assert-Near ($s.RateAt($s.plateauLevel)) 1 'plateau'
        Assert-Near ($s.RateAt(1)) $max 'maximum rate'
        if ($floor -gt 0) { Assert-Near ($s.RateAt([float]($floor - 0.001))) 0 'halted below floor' }
    } } } }
}

It 'All five input toggles affect the target in all 32 combinations and restore' {
    $s = New-Settings
    $names = @('feedMatters', 'penMatters', 'temperatureMatters', 'healthMatters', 'companyMatters')
    $values = @(0.2, -0.1, 0.05, -0.15, 0.1)
    for ($mask = 0; $mask -lt 32; $mask++) {
        $expected = 0.5
        for ($i = 0; $i -lt 5; $i++) {
            $enabled = ($mask -band (1 -shl $i)) -ne 0
            $s.($names[$i]) = $enabled
            if ($enabled) { $expected += $values[$i] }
        }
        Assert-Near ($s.TargetFromContributions(0.2, -0.1, 0.05, -0.15, 0.1)) $expected "input mask $mask"
    }
    $s.Reset()
    Assert-Near ($s.TargetFromContributions(0.2, -0.1, 0.05, -0.15, 0.1)) 0.6 'restored inputs'
    Assert-Near ($s.TargetFromContributions(1, 1, 1, 1, 1)) 1 'target upper bound'
    Assert-Near ($s.TargetFromContributions(-1, -1, -1, -1, -1)) 0 'target lower bound'
}

It 'Adjustment speed changes the real interval step without overshooting' {
    $s = New-Settings
    foreach ($speed in @(0.25, 1, 4)) {
        $s.adjustSpeed = $speed
        Assert-Near ($s.NextLevel(0.5, 1)) (0.5 + $speed / 400) 'rising interval'
        Assert-Near ($s.NextLevel(0.5, 0)) (0.5 - $speed / 400) 'falling interval'
        Assert-Near ($s.NextLevel(0.5, 0.5001)) 0.5001 'no upward overshoot'
        Assert-Near ($s.NextLevel(0.5, 0.4999)) 0.4999 'no downward overshoot'
        Assert-Near ($s.NextLevel(0.5, 0.5)) 0.5 'settled animal'
    }
}

# ---------------------------------------------------------------- Scribe of the settings (game's own Scribe)

$scratch = Join-Path $ModRoot 'build/settings-tests'
$null = New-Item -ItemType Directory -Path $scratch -Force
$scribe = Get-GameType 'Verse.Scribe'
$saver = $scribe.GetField('saver', $ALL).GetValue($null)
$loader = $scribe.GetField('loader', $ALL).GetValue($null)
function Read-TestSettings([string]$path) {
    $s = New-Settings
    try { $loader.InitLoading($path); $s.ExposeData(); return $s } finally { $loader.ForceStop() }
}

It 'The six bool options: defaults, a file without them, every save and reload (shared Test-ScribeSettings)' {
    $defaults = [ordered]@{ producersOnly = $true; feedMatters = $true; penMatters = $true; temperatureMatters = $true; healthMatters = $true; companyMatters = $true }
    Test-ScribeSettings -SettingsType $settingsType -Defaults $defaults -Scratch (Join-Path $scratch 'bools')
}

It 'Real Scribe saves and reloads the five float options' {
    $culture = [Threading.Thread]::CurrentThread.CurrentCulture
    [Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::InvariantCulture
    try {
        $s = New-Settings
        $s.floorLevel = 0.11; $s.plateauLevel = 0.72; $s.minRateFactor = 0.55; $s.maxRateFactor = 1.65; $s.adjustSpeed = 2.35
        $path = Join-Path $scratch 'roundtrip-floats.xml'
        try { $saver.InitSaving($path, 'settings'); $s.ExposeData(); $saver.FinalizeSaving() } finally { $saver.ForceStop() }
        Assert-SettingsEqual (Read-TestSettings $path) $s
    } finally { [Threading.Thread]::CurrentThread.CurrentCulture = $culture }
}

It 'Stored out-of-range and nonfinite numbers are normalized while loading' {
    $path = Join-Path $scratch 'invalid-numbers.xml'
    [IO.File]::WriteAllText($path, '<settings><floorLevel>99</floorLevel><plateauLevel>-1</plateauLevel><minRateFactor>NaN</minRateFactor><maxRateFactor>Infinity</maxRateFactor><adjustSpeed>-20</adjustSpeed></settings>')
    $s = Read-TestSettings $path
    Assert-Near $s.floorLevel 0.5 'loaded floor'
    Assert-Near $s.plateauLevel 0.55 'loaded plateau'
    Assert-Near $s.minRateFactor 0.4 'loaded NaN'
    Assert-Near $s.maxRateFactor 1.4 'loaded infinity'
    Assert-Near $s.adjustSpeed 0.25 'loaded speed'
}

# ---------------------------------------------------------------- wiring

It 'Shortcut XML is hidden and its worker keeps the native visibility contract' {
    [xml]$xml = Read-Text (Join-Path $ModPath 'Defs/MainButtonDefs/MainButtons_ContentedLivestock.xml')
    $node = $xml.Defs.MainButtonDef
    $defType = Get-GameType 'RimWorld.MainButtonDef'
    $def = [Activator]::CreateInstance($defType)
    foreach ($n in $node.ChildNodes | Where-Object NodeType -eq Element) {
        $f = $defType.GetField($n.Name, $ALL)
        if ($null -eq $f) { throw "Unknown MainButtonDef field $($n.Name)" }
        $value = if ($f.FieldType -eq [type]) { $modAsm.GetType($n.InnerText, $true) } else { [Convert]::ChangeType($n.InnerText, $f.FieldType, [Globalization.CultureInfo]::InvariantCulture) }
        $f.SetValue($def, $value)
    }
    $worker = $def.Worker
    if ($def.buttonVisible -or $worker.def.buttonVisible) { throw 'Shortcut is visible by default' }
    $def.buttonVisible = $true
    if (-not $worker.def.buttonVisible) { throw 'Customization does not reach the worker definition' }
    $def.buttonVisible = $false
    if ($worker.def.buttonVisible) { throw 'Shortcut definition cannot be hidden again' }
    $visible = $worker.GetType().GetProperty('Visible').GetMethod
    if ($visible.DeclaringType.FullName -ne 'RimWorld.MainButtonWorker' -or -not (Test-FieldTouched $visible $defType.GetField('buttonVisible') 0x7B)) { throw 'Worker no longer inherits the native visibility-field implementation' }
    if (-not $def.validWithoutMap -or $null -ne $def.tabWindowClass) { throw 'Shortcut should open settings without requiring a map/tab' }
}

It 'Shortcut opens the native settings dialog for the same Mod instance and uses native persistence' {
    $workerType = $modAsm.GetType('ContentedLivestock.MainButtonWorker_ContentedLivestock', $true)
    $calls = @(Calls-Of $workerType.GetMethod('Activate'))
    foreach ($expected in @('ContentedLivestockMod.get_Instance', 'Dialog_ModSettings..ctor', 'WindowStack.Add')) { if ($calls -notcontains $expected) { throw "Shortcut does not call $expected (calls: $($calls -join ', '))" } }
    $dialog = Get-GameType 'RimWorld.Dialog_ModSettings'
    if (@(Calls-Of $dialog.GetMethod('PreClose')) -notcontains 'Mod.WriteSettings') { throw 'Native close no longer writes settings' }
    if (@(Calls-Of $dialog.GetMethod('DoWindowContents')) -notcontains 'Mod.DoSettingsWindowContents') { throw 'Native dialog no longer uses the primary settings UI' }
    if ($workerType.GetProperty('Visible', $DECL)) { throw 'Worker must not override native visibility' }
}

It 'Production uses the tested settings logic, and closing refreshes eligibility and caches' {
    $modType = $modAsm.GetType('ContentedLivestock.ContentedLivestockMod', $true)
    $needType = $modAsm.GetType('ContentedLivestock.Need_Contentment', $true)
    $expectedCalls = @(
        @($contentment.GetMethod('RateFactor'), 'ContentedLivestockSettings.RateAt'),
        @($needType.GetMethod('NeedInterval'), 'ContentedLivestockSettings.NextLevel'),
        @($needType.GetMethod('TargetLevel'), 'ContentedLivestockSettings.TargetFromContributions'),
        @($modType.GetMethod('WriteSettings'), 'ContentedLivestockSettings.Normalize'),
        @($modType.GetMethod('WriteSettings'), 'Pawn_NeedsTracker.AddOrRemoveNeedsAsAppropriate'),
        @($modType.GetMethod('WriteSettings'), 'Need_Contentment.InvalidateEnvironmentCache'),
        @($modType.GetMethod('WriteSettings'), 'Mod.WriteSettings')
    )
    foreach ($pair in $expectedCalls) { if (@(Calls-Of $pair[0]) -notcontains $pair[1]) { throw "Missing runtime call $($pair[1])" } }
}

It 'Producer detection recognizes milk, wool and eggs, and eligibility reads producers-only' {
    $pawnType = Get-GameType 'Verse.Pawn'
    $produces = $contentment.GetMethod('Produces')
    $pawn = [Runtime.Serialization.FormatterServices]::GetUninitializedObject($pawnType)
    if ($produces.Invoke($null, @($pawn))) { throw 'Empty comp list is a producer' }
    $listType = [System.Collections.Generic.List``1].MakeGenericType((Get-GameType 'Verse.ThingComp'))
    foreach ($name in @('RimWorld.CompMilkable', 'RimWorld.CompShearable', 'RimWorld.CompEggLayer')) {
        $pawn = [Runtime.Serialization.FormatterServices]::GetUninitializedObject($pawnType)
        $comps = [Activator]::CreateInstance($listType)
        $comps.Add([Activator]::CreateInstance((Get-GameType $name)))
        (Get-GameType 'Verse.ThingWithComps').GetField('comps', $ALL).SetValue($pawn, $comps)
        if (-not $produces.Invoke($null, @($pawn))) { throw "Producer comp not recognized: $name" }
    }
    $applies = $contentment.GetMethod('AppliesTo')
    if (-not (Test-FieldTouched $applies $settingsType.GetField('producersOnly') 0x7B) -or @(Calls-Of $applies) -notcontains 'Contentment.Produces') { throw 'Eligibility no longer uses producers-only and comp detection' }
}

# ---------------------------------------------------------------- content

It 'The need def names a Need class of this mod and leaves minIntelligence alone' {
    [xml]$doc = Read-Text (Join-Path $ModPath 'Defs\NeedDefs\Needs_Contentment.xml')
    $def = $doc.SelectSingleNode('//NeedDef')
    $needClass = $def.SelectSingleNode('needClass')
    if ($null -eq $needClass) { 'the def declares no needClass' }
    else {
        $t = $modTypes | Where-Object { $_.FullName -eq $needClass.InnerText -or $_.Name -eq $needClass.InnerText } | Select-Object -First 1
        if ($null -eq $t) { "needClass $($needClass.InnerText) is in no assembly this mod ships" }
        elseif (-not (Get-GameType 'RimWorld.Need').IsAssignableFrom($t)) { "$($t.FullName) does not derive from RimWorld.Need" }
    }
    $mi = $def.SelectSingleNode('minIntelligence')
    if ($null -ne $mi -and $mi.InnerText -ne 'Animal') { "the def sets minIntelligence to $($mi.InnerText): that is a floor, anything above Animal keeps the need off the animals" }
}

It 'About identifies this repository, and Harmony is the sole required mod, loaded before' {
    [xml]$about = Read-Text (Join-Path $ModPath 'About/About.xml')
    $meta = $about.ModMetaData
    $url = 'https://github.com/vbardales/Rimworld-Contented-Livestock'
    if ($meta.packageId -cne 'nelim.contentedlivestock') { 'Wrong packageId' }
    if ($meta.url -ne $url) { 'Wrong source URL' }
    elseif (-not $meta.description.Contains($url)) { 'Description has no GitHub link' }
    $deps = @($meta.modDependencies.li)
    if ($deps.Count -ne 1 -or $deps[0].packageId -ne 'brrainz.harmony') { 'Expected Harmony as the sole required mod' }
    if (@($meta.loadAfter.li) -notcontains 'brrainz.harmony') { 'Missing Harmony load order' }
    if (Test-Path (Join-Path $ModPath 'Assemblies/0Harmony.dll')) { 'Unexpected second Harmony copy' }
}

Remove-GameReflection
Complete-Tests
