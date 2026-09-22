param(
    [string]$PickleAssemblies = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\3791648678\Assemblies'
)

$ErrorActionPreference = 'Stop'
$suite = $PSScriptRoot

foreach ($dll in 'CucumberExpressions.dll', 'RimWorks.Pickle.Core.dll') {
    $path = Join-Path $PickleAssemblies $dll
    if (-not (Test-Path $path)) { throw "$dll not found under $PickleAssemblies" }
    [Reflection.Assembly]::LoadFrom($path) | Out-Null
}

$core = [AppDomain]::CurrentDomain.GetAssemblies() |
    Where-Object { $_.GetName().Name -eq 'RimWorks.Pickle.Core' }
$registryType = $core.GetType('RimWorks.Pickle.Core.Steps.PickleParameterTypeRegistry')
if (-not $registryType) { throw 'PickleParameterTypeRegistry was not found' }
$registry = [Activator]::CreateInstance($registryType)

$declared = @()
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $suite 'Source') -Filter *.cs) {
    $text = [IO.File]::ReadAllText($file.FullName)
    foreach ($match in [regex]::Matches($text, '\[(?:Given|When|Then)\("((?:[^"\\]|\\.)*)"\)\]')) {
        $declared += [pscustomobject]@{
            File = $file.Name
            Pattern = $match.Groups[1].Value -replace '\\\\', '\' -replace '\\"', '"'
        }
    }
}
if ($declared.Count -eq 0) { throw 'no step patterns found' }

$bad = 0
foreach ($group in ($declared | Group-Object Pattern | Where-Object { $_.Count -gt 1 })) {
    Write-Host "DUPLICATE $($group.Name)" -ForegroundColor Red
    $bad++
}

$compiled = @()
foreach ($item in $declared) {
    try {
        $compiled += [pscustomobject]@{
            Pattern = $item.Pattern
            Expression = New-Object CucumberExpressions.CucumberExpression($item.Pattern, $registry)
            Used = $false
        }
    }
    catch {
        Write-Host "INVALID $($item.File): $($item.Pattern)" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        $bad++
    }
}

$leftover = @()
$lineCount = 0
foreach ($feature in Get-ChildItem -LiteralPath (Join-Path $suite 'Mod\Pickle\Features') -Filter *.feature) {
    foreach ($raw in [IO.File]::ReadAllLines($feature.FullName)) {
        $line = $raw.Trim()
        if ($line -notmatch '^(Given|When|Then|And|But)\s+(.+)$') { continue }
        $step = $Matches[2].Trim()
        $lineCount++
        $hit = $false
        foreach ($candidate in $compiled) {
            if ($candidate.Expression.Regex.IsMatch($step)) {
                $candidate.Used = $true
                $hit = $true
                break
            }
        }
        if (-not $hit) { $leftover += "$($feature.Name): $step" }
    }
}

$unused = @($compiled | Where-Object { -not $_.Used })
if ($unused.Count -gt 0) {
    foreach ($item in $unused) { Write-Host "UNUSED $($item.Pattern)" -ForegroundColor Yellow }
    $bad += $unused.Count
}

Write-Host "$($declared.Count) local patterns compile; $lineCount feature step lines scanned."
foreach ($item in ($leftover | Sort-Object -Unique)) {
    Write-Host "PICKLE OR SHARED $item" -ForegroundColor DarkGray
}

if ($bad -gt 0) { exit 1 }
Write-Host 'LOCAL EXPRESSIONS VALID AND USED' -ForegroundColor Green
