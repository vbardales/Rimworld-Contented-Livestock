# Contented Livestock Pickle suite

This development-only companion holds the in-game acceptance scenarios for Contented Livestock.
Nothing under `Tests/` is part of the Workshop payload. The suite is written for the shared WSL
runner; it has not been executed yet, and no runtime result is claimed by its presence.

## Scope

The existing 35-test PowerShell suite owns pure calculations, normalization, scalar Scribe
round-trips, XML, dependency metadata and static localization coverage. Pickle is limited to what
needs a running game: startup without logged errors, values actually loaded into the live mod,
the real `Dialog_ModSettings`, active-language resources, MainButtons behavior and RIMMSQOL.
The longer animal-production matrix remains documented in `_tools/FUNCTIONAL-SCENARIOS.md` for
`done -> tested`; it is not duplicated here merely to increase the scenario count.

## Pass matrix

| Pass | Features | Purpose |
| --- | --- | --- |
| Minimal English | `01`, `02` with `wsl-deps.runtime-evidence.map` | standalone load, defaults, settings UI, shortcut, English capture |
| Minimal French | `01`, `02` with the same map and `-Language French` | active French resources and French settings capture |
| RIMMSQOL | `03` with `wsl-deps.avec-rimmsqol.map` | list, reveal, activate, hide and forget the optional shortcut |

There are no declared incompatibilities and no other optional gameplay integrations. Harmony is
a hard dependency and is staged by the shared launcher. RIMMSQOL remains test-only and optional.

From the collection root, after confirming the shared machine is free, the future runtime commands are:

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Language French
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.avec-rimmsqol.map -Filter 03-rimmsqol.feature -Language English
```

Do not switch language inside a scenario. Do not run the Windows game. Execution and review of
the `@review` captures belong to `done -> tested`, not to this suite-writing gate.

## Offline validation

```powershell
dotnet build Tests/Pickle/Source/ContentedLivestock.PickleSteps.csproj -c Release
powershell.exe -ExecutionPolicy Bypass -File Tests/Pickle/Check-Steps.ps1
```

The build output is `Tests/Pickle/Mod/Pickle/Assemblies/ContentedLivestock.PickleSteps.dll`.
`Check-Steps.ps1` compiles each local Cucumber expression with Pickle's own expression engine,
rejects duplicate or unused local patterns, and lists lines delegated to Pickle or shared tools.
