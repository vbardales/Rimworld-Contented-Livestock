# Loaded by Run-Functional-Tests.ps1 after the actual game, runtime Harmony and shipped mod.
# These tests call production logic and Scribe. They do not simulate a running Unity UI.
Group 'Settings, runtime dependency and shortcut contracts'

function New-Settings { [Activator]::CreateInstance($settingsType) }
function Assert-Near([double]$actual, [double]$expected, [string]$context) {
    if ([double]::IsNaN($actual) -or [Math]::Abs($actual - $expected) -gt 0.00001) {
        throw "$context : expected $expected, got $actual"
    }
}
function Assert-SettingsEqual($actual, $expected) {
    foreach ($field in $settingsType.GetFields([System.Reflection.BindingFlags]'Public,Instance')) {
        if ($field.FieldType -eq [float]) {
            Assert-Near $field.GetValue($actual) $field.GetValue($expected) $field.Name
        } elseif ($field.FieldType -eq [bool]) {
            if ($field.GetValue($actual) -ne $field.GetValue($expected)) { throw $field.Name }
        }
    }
}

Test-Case 'All eleven first-use defaults and normalization are stable' {
    $s = New-Settings
    foreach ($entry in @{floorLevel=0.25; plateauLevel=0.60; minRateFactor=0.40; maxRateFactor=1.40; adjustSpeed=1.0}.GetEnumerator()) {
        Assert-Near $s.($entry.Key) $entry.Value $entry.Key
    }
    foreach ($name in @('producersOnly','feedMatters','penMatters','temperatureMatters','healthMatters','companyMatters')) {
        if (-not $s.$name) { throw "Default $name must be true" }
    }
    $s.Normalize()
    Assert-SettingsEqual $s (New-Settings)
}

Test-Case 'Numeric bounds, nonfinite values and crossed thresholds normalize safely' {
    $ranges = @{
        floorLevel=@(0.0,0.5,0.25); plateauLevel=@(0.3,0.9,0.6)
        minRateFactor=@(0.0,1.0,0.4); maxRateFactor=@(1.0,2.0,1.4); adjustSpeed=@(0.25,4.0,1.0)
    }
    foreach ($name in $ranges.Keys) {
        $range = $ranges[$name]
        foreach ($sample in @(@(-99,$range[0]),@(99,$range[1]),@([float]::NaN,$range[2]),@([float]::PositiveInfinity,$range[2]),@([float]::NegativeInfinity,$range[2]))) {
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
    $s.floorLevel=0.5; $s.plateauLevel=0.3; $s.Normalize()
    Assert-Near $s.plateauLevel 0.55 'crossed thresholds'
}

Test-Case 'Actual production curve follows thresholds and remains monotonic at allowed extremes' {
    $s = New-Settings
    foreach ($point in @(@(0,0),@(0.249,0),@(0.25,0.4),@(0.425,0.7),@(0.6,1),@(0.8,1.2),@(1,1.4))) {
        Assert-Near ($s.RateAt([float]$point[0])) $point[1] 'default curve'
    }
    foreach ($floor in @(0,0.25,0.5)) { foreach ($plateau in @(0.3,0.6,0.9)) {
        foreach ($min in @(0,0.4,1)) { foreach ($max in @(1,1.4,2)) {
            $s.floorLevel=$floor; $s.plateauLevel=$plateau; $s.minRateFactor=$min; $s.maxRateFactor=$max; $s.Normalize()
            $previous = -1.0
            for ($i=0; $i -le 100; $i++) {
                $rate = $s.RateAt([float]($i/100.0))
                if ([float]::IsNaN($rate) -or $rate -lt 0 -or $rate -gt 2.00001 -or $rate -lt $previous-0.00001) {
                    throw "Unsafe curve floor=$floor plateau=$plateau min=$min max=$max level=$i"
                }
                $previous=$rate
            }
            Assert-Near ($s.RateAt($s.plateauLevel)) 1 'plateau'
            Assert-Near ($s.RateAt(1)) $max 'maximum rate'
            if ($floor -gt 0) { Assert-Near ($s.RateAt([float]($floor-0.001))) 0 'halted below floor' }
        }}
    }}
}

Test-Case 'All five input toggles affect the actual target in all 32 combinations and restore' {
    $s=New-Settings
    $names=@('feedMatters','penMatters','temperatureMatters','healthMatters','companyMatters')
    # Distinct signed observations catch swapped factors and stale cached contributions.
    $values=@(0.2,-0.1,0.05,-0.15,0.1)
    for ($mask=0; $mask -lt 32; $mask++) {
        $expected=0.5
        for ($i=0; $i -lt 5; $i++) {
            $enabled=($mask -band (1 -shl $i)) -ne 0
            $s.($names[$i])=$enabled
            if ($enabled) { $expected += $values[$i] }
        }
        Assert-Near ($s.TargetFromContributions(0.2,-0.1,0.05,-0.15,0.1)) $expected "input mask $mask"
    }
    $s.Reset()
    Assert-Near ($s.TargetFromContributions(0.2,-0.1,0.05,-0.15,0.1)) 0.6 'restored inputs'
    Assert-Near ($s.TargetFromContributions(1,1,1,1,1)) 1 'target upper bound'
    Assert-Near ($s.TargetFromContributions(-1,-1,-1,-1,-1)) 0 'target lower bound'
}

Test-Case 'Adjustment speed changes the real interval step without overshooting' {
    $s=New-Settings
    foreach ($speed in @(0.25,1,4)) {
        $s.adjustSpeed=$speed
        Assert-Near ($s.NextLevel(0.5,1)) (0.5+$speed/400) 'rising interval'
        Assert-Near ($s.NextLevel(0.5,0)) (0.5-$speed/400) 'falling interval'
        Assert-Near ($s.NextLevel(0.5,0.5001)) 0.5001 'no upward overshoot'
        Assert-Near ($s.NextLevel(0.5,0.4999)) 0.4999 'no downward overshoot'
        Assert-Near ($s.NextLevel(0.5,0.5)) 0.5 'settled animal'
    }
}

$scribe = Get-GameType 'Verse.Scribe'
$saver = $scribe.GetField('saver', $ALL).GetValue($null)
$loader = $scribe.GetField('loader', $ALL).GetValue($null)
$settingsScratch = Join-Path $ModPath '.build/settings-tests'
$null = New-Item -ItemType Directory -Path $settingsScratch -Force

function Read-TestSettings([string]$path) {
    $s = New-Settings
    try {
        $loader.InitLoading($path)
        $s.ExposeData()
        # These settings contain only scalar values: no cross-references or post-load work.
        # FinalizeLoading invokes Unity's profiler outside this testable Scribe boundary.
        return $s
    } finally { $loader.ForceStop() }
}

Test-Case 'Real Scribe saves and reloads all scalar settings and the omitted defaults' {
    $culture=[Threading.Thread]::CurrentThread.CurrentCulture
    [Threading.Thread]::CurrentThread.CurrentCulture=[Globalization.CultureInfo]::InvariantCulture
    try {
        foreach ($custom in @($false,$true)) {
            $s=New-Settings
            if ($custom) {
                $s.floorLevel=0.11; $s.plateauLevel=0.72; $s.minRateFactor=0.55; $s.maxRateFactor=1.65; $s.adjustSpeed=2.35
                foreach ($f in $settingsType.GetFields() | Where-Object FieldType -eq ([bool])) { $f.SetValue($s,$false) }
            }
            $path=Join-Path $settingsScratch "roundtrip-$custom.xml"
            try { $saver.InitSaving($path,'settings'); $s.ExposeData(); $saver.FinalizeSaving() }
            finally { $saver.ForceStop() }
            Assert-SettingsEqual (Read-TestSettings $path) $s
        }
    } finally { [Threading.Thread]::CurrentThread.CurrentCulture=$culture }
}

Test-Case 'Older settings retain stored values and supply defaults for missing fields' {
    $path=Join-Path $settingsScratch 'older.xml'
    [IO.File]::WriteAllText($path,'<settings><floorLevel>0.12</floorLevel><feedMatters>False</feedMatters><obsolete>ignored</obsolete></settings>')
    $expected=New-Settings; $expected.floorLevel=0.12; $expected.feedMatters=$false
    Assert-SettingsEqual (Read-TestSettings $path) $expected
}

Test-Case 'Stored out-of-range and nonfinite numbers are normalized while loading' {
    $path=Join-Path $settingsScratch 'invalid-numbers.xml'
    [IO.File]::WriteAllText($path,'<settings><floorLevel>99</floorLevel><plateauLevel>-1</plateauLevel><minRateFactor>NaN</minRateFactor><maxRateFactor>Infinity</maxRateFactor><adjustSpeed>-20</adjustSpeed></settings>')
    $s=Read-TestSettings $path
    Assert-Near $s.floorLevel 0.5 'loaded floor'
    Assert-Near $s.plateauLevel 0.55 'loaded plateau'
    Assert-Near $s.minRateFactor 0.4 'loaded NaN'
    Assert-Near $s.maxRateFactor 1.4 'loaded infinity'
    Assert-Near $s.adjustSpeed 0.25 'loaded speed'
}

# Decode instruction boundaries; operand bytes must not be mistaken for call opcodes.
$opcodes=@{}
foreach ($f in [Reflection.Emit.OpCodes].GetFields([Reflection.BindingFlags]'Public,Static')) {
    $op=$f.GetValue($null); $opcodes[[int]$op.Value -band 65535]=$op
}
function Get-Calls([Reflection.MethodBase]$method) {
    $body=$method.GetMethodBody(); if ($null -eq $body) { return }
    $il=$body.GetILAsByteArray(); $i=0
    while ($i -lt $il.Length) {
        $code=[int]$il[$i++]; if ($code -eq 254) { $code=65024+[int]$il[$i++] }
        $op=$opcodes[$code]; if ($null -eq $op) { throw "Unknown IL opcode $code" }
        $size=0
        switch ($op.OperandType.ToString()) {
            InlineNone { $size=0 }
            ShortInlineBrTarget { $size=1 }; ShortInlineI { $size=1 }; ShortInlineVar { $size=1 }
            InlineVar { $size=2 }
            InlineI8 { $size=8 }; InlineR { $size=8 }
            InlineSwitch { $size=4+4*[BitConverter]::ToInt32($il,$i) }
            default { $size=4 }
        }
        if ($op.OperandType.ToString() -eq 'InlineMethod') {
            $m=$method.Module.ResolveMethod([BitConverter]::ToInt32($il,$i))
            '{0}.{1}' -f $m.DeclaringType.FullName,$m.Name
        }
        $i += $size
    }
}

Test-Case 'Shortcut XML is hidden and its worker preserves the native visibility contract' {
    [xml]$xml=Get-Content (Join-Path $ModPath 'Mod/Defs/MainButtonDefs/MainButtons_ContentedLivestock.xml') -Raw
    $node=$xml.Defs.MainButtonDef
    $defType=Get-GameType 'RimWorld.MainButtonDef'
    $def=[Activator]::CreateInstance($defType)
    foreach ($n in $node.ChildNodes | Where-Object NodeType -eq Element) {
        $f=$defType.GetField($n.Name,$ALL); if ($null -eq $f) { throw "Unknown MainButtonDef field $($n.Name)" }
        if ($f.FieldType -eq [type]) { $value=$modAsm.GetType($n.InnerText,$true) }
        else { $value=[Convert]::ChangeType($n.InnerText,$f.FieldType,[Globalization.CultureInfo]::InvariantCulture) }
        $f.SetValue($def,$value)
    }
    $worker=$def.Worker
    if ($def.buttonVisible -or $worker.def.buttonVisible) { throw 'Shortcut is visible by default' }
    $def.buttonVisible=$true
    if (-not $worker.def.buttonVisible) { throw 'Customization does not reach the worker definition' }
    $def.buttonVisible=$false
    if ($worker.def.buttonVisible) { throw 'Shortcut definition cannot be hidden again' }
    $visible=$worker.GetType().GetProperty('Visible').GetMethod
    if ($visible.DeclaringType.FullName -ne 'RimWorld.MainButtonWorker' -or
        -not (Test-FieldTouched $visible $defType.GetField('buttonVisible') 0x7b)) {
        throw 'Worker no longer inherits the native visibility-field implementation'
    }
    # Calling Visible itself initializes ModsConfig, which requires a running Unity host.
    # Here the real worker/Def are instantiated and its inherited compiled contract is checked.
    if (-not $def.validWithoutMap -or $null -ne $def.tabWindowClass) { throw 'Shortcut should open settings without requiring a map/tab' }
}

Test-Case 'Shortcut opens the native settings dialog for the same Mod instance and uses native persistence' {
    $workerType=$modAsm.GetType('ContentedLivestock.MainButtonWorker_ContentedLivestock',$true)
    $calls=@(Get-Calls $workerType.GetMethod('Activate'))
    foreach ($expected in @('ContentedLivestock.ContentedLivestockMod.get_Instance','RimWorld.Dialog_ModSettings..ctor','Verse.WindowStack.Add')) {
        if ($calls -notcontains $expected) { throw "Shortcut does not call $expected" }
    }
    $dialog=Get-GameType 'RimWorld.Dialog_ModSettings'
    if (@(Get-Calls $dialog.GetMethod('PreClose')) -notcontains 'Verse.Mod.WriteSettings') { throw 'Native close no longer writes settings' }
    if (@(Get-Calls $dialog.GetMethod('DoWindowContents')) -notcontains 'Verse.Mod.DoSettingsWindowContents') { throw 'Native dialog no longer uses the primary settings UI' }
    if ($workerType.GetProperty('Visible',$DECL)) { throw 'Worker must not override native visibility' }
}

Test-Case 'Production uses the tested settings logic and closing refreshes eligibility and caches' {
    $modType=$modAsm.GetType('ContentedLivestock.ContentedLivestockMod',$true)
    $needType=$modAsm.GetType('ContentedLivestock.Need_Contentment',$true)
    $expectedCalls=@(
        @($contentment.GetMethod('RateFactor'),'ContentedLivestock.ContentedLivestockSettings.RateAt'),
        @($needType.GetMethod('NeedInterval'),'ContentedLivestock.ContentedLivestockSettings.NextLevel'),
        @($needType.GetMethod('TargetLevel'),'ContentedLivestock.ContentedLivestockSettings.TargetFromContributions'),
        @($modType.GetMethod('WriteSettings'),'ContentedLivestock.ContentedLivestockSettings.Normalize'),
        @($modType.GetMethod('WriteSettings'),'RimWorld.Pawn_NeedsTracker.AddOrRemoveNeedsAsAppropriate'),
        @($modType.GetMethod('WriteSettings'),'ContentedLivestock.Need_Contentment.InvalidateEnvironmentCache'),
        @($modType.GetMethod('WriteSettings'),'Verse.Mod.WriteSettings')
    )
    foreach ($pair in $expectedCalls) {
        if (@(Get-Calls $pair[0]) -notcontains $pair[1]) { throw "Missing runtime call $($pair[1])" }
    }
}

Test-Case 'Harmony runtime is provided by the declared optional-tool-independent dependency' {
    [xml]$about=Get-Content (Join-Path $ModPath 'Mod/About/About.xml') -Raw
    $deps=@($about.ModMetaData.modDependencies.li)
    if ($deps.Count -ne 1 -or $deps[0].packageId -ne 'brrainz.harmony') { throw 'Expected Harmony as the sole required mod' }
    if (@($about.ModMetaData.loadAfter.li) -notcontains 'brrainz.harmony') { throw 'Missing Harmony load order' }
    $reference=$modAsm.GetReferencedAssemblies() | Where-Object Name -eq '0Harmony'
    $runtime=[Reflection.AssemblyName]::GetAssemblyName((Join-Path $HarmonyPath '0Harmony.dll'))
    $harmony=[Reflection.Assembly]::LoadFrom((Join-Path $HarmonyPath '0Harmony.dll'))
    $harmonyType=$harmony.GetType('HarmonyLib.Harmony',$true)
    $instance=[Activator]::CreateInstance($harmonyType,[object[]]@('nelim.contentedlivestock.tests'))
    if ($null -eq $instance -or $null -eq $harmonyType.GetMethod('PatchAll',[type[]]@())) { throw 'Required Harmony constructor/PatchAll API unavailable' }
    foreach ($t in $modTypes) { $null=$t.GetCustomAttributes($false) }
    if ($runtime.Version -lt [version]'2.4.1.0') { throw 'Runtime is older than the verified Harmony API baseline' }
    if (Test-Path (Join-Path $ModPath 'Mod/Assemblies/0Harmony.dll')) { throw 'Unexpected second Harmony copy' }
    # Unlike the generic game-type inventory, do not accept partially loaded mod classes.
    $null=$modAsm.GetTypes()
}

Test-Case 'Producer detection recognizes milk, wool and eggs and eligibility reads producers-only' {
    # RaceProperties.Animal initializes ModsConfig/DefOf and requires the Unity host.
    # Exercise real comp detection here; inspect the eligibility linkage and run scenario 3 in game.
    $pawn=[Runtime.Serialization.FormatterServices]::GetUninitializedObject((Get-GameType 'Verse.Pawn'))
    $produces=$contentment.GetMethod('Produces')
    if ($produces.Invoke($null,@($pawn))) { throw 'Empty comp list is a producer' }
    $compType=Get-GameType 'Verse.ThingComp'
    $listType=[System.Collections.Generic.List``1].MakeGenericType($compType)
    foreach ($name in @('RimWorld.CompMilkable','RimWorld.CompShearable','RimWorld.CompEggLayer')) {
        $pawn=[Runtime.Serialization.FormatterServices]::GetUninitializedObject((Get-GameType 'Verse.Pawn'))
        $comps=[Activator]::CreateInstance($listType)
        $comps.Add([Activator]::CreateInstance((Get-GameType $name)))
        (Get-GameType 'Verse.ThingWithComps').GetField('comps',$ALL).SetValue($pawn,$comps)
        if (-not $produces.Invoke($null,@($pawn))) { throw "Producer comp not recognized: $name" }
    }
    $applies=$contentment.GetMethod('AppliesTo')
    if (-not (Test-FieldTouched $applies $settingsType.GetField('producersOnly') 0x7b) -or
        @(Get-Calls $applies) -notcontains 'ContentedLivestock.Contentment.Produces') {
        throw 'Eligibility no longer uses producers-only and comp detection'
    }
}
Test-Case 'EN and FR cover every owned key and Def field with nonempty matching parameters' {
    $keys=@()
    foreach ($t in $modTypes) { foreach ($m in $t.GetMethods($DECL)) {
        $keys += @(Get-StringLiterals $m | Where-Object { $_ -match '^ContentedLivestock\.(Settings|Tip)\.' })
    }}
    $keys=@($keys | Sort-Object -Unique)
    $resources=@{}
    foreach ($lang in @('English','French')) {
        $entries=@{}
        foreach ($file in Get-ChildItem (Join-Path $ModPath "Mod/Languages/$lang/Keyed") -Filter '*.xml') {
            [xml]$xml=Get-Content $file.FullName -Raw
            foreach ($n in $xml.LanguageData.ChildNodes | Where-Object NodeType -eq Element) {
                if ($entries.ContainsKey($n.Name) -or [string]::IsNullOrWhiteSpace($n.InnerText)) { throw "Duplicate/empty $lang $($n.Name)" }
                $entries[$n.Name]=$n.InnerText
                $null=[string]::Format([Globalization.CultureInfo]::InvariantCulture,$n.InnerText,[object[]]@('42'))
            }
        }
        if (Compare-Object $keys @($entries.Keys)) { throw "$lang key inventory differs from compiled code" }
        $resources[$lang]=$entries
    }
    foreach ($key in $keys) {
        $en=([regex]::Matches($resources.English[$key],'\{\d+\}') | ForEach-Object Value) -join ','
        $fr=([regex]::Matches($resources.French[$key],'\{\d+\}') | ForEach-Object Value) -join ','
        if ($en -ne $fr) { throw "Parameters differ: $key" }
    }
    foreach ($file in Get-ChildItem (Join-Path $ModPath 'Mod/Defs') -Recurse -Filter '*.xml') {
        [xml]$xml=Get-Content $file.FullName -Raw
        foreach ($def in $xml.Defs.ChildNodes | Where-Object NodeType -eq Element) {
            $translated=@{}
            foreach ($frFile in Get-ChildItem (Join-Path $ModPath "Mod/Languages/French/DefInjected/$($def.Name)") -Filter '*.xml') {
                [xml]$frXml=Get-Content $frFile.FullName -Raw
                foreach ($n in $frXml.LanguageData.ChildNodes | Where-Object NodeType -eq Element) { $translated[$n.Name]=$n.InnerText }
            }
            foreach ($field in @('label','description')) {
                if ([string]::IsNullOrWhiteSpace($def.$field) -or [string]::IsNullOrWhiteSpace($translated["$($def.defName).$field"])) { throw "Missing EN/FR $($def.defName).$field" }
            }
        }
    }
}
