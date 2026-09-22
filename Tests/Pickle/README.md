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
| Animal gameplay | `04` with `wsl-deps.runtime-evidence.map` | live producer eligibility, producers-only refresh, faction changes, initial level and production factors |
| RIMMSQOL restart chain | `05` then `06` then `07` with `wsl-deps.avec-rimmsqol.map` | reveal and hide choices survive separate processes; final launch forgets and cleans up |
| Save/reload evidence | `08` with `wsl-deps.runtime-evidence.map` | contentment level and last-feed memory survive a real save/reload, with reviewed before/after media |
| Settings restart chain | `09` then `10` with `wsl-deps.runtime-evidence.map` | all eleven distinctive settings survive a separate process and the test-profile file is restored afterward |
| First game hour | `11` with `wsl-deps.runtime-evidence.map` | a milkable animal advances for 2,500 live ticks without patch/def errors, with before/after film evidence |
| Scenario 1 eligibility | `12` with `wsl-deps.runtime-evidence.map` | cow and hen receive Contentment; husky, colonist and wild animal do not, with a capture of every stable state |
| Scenario 2 transitions | `13` with `wsl-deps.runtime-evidence.map` | a wild muffalo gains Contentment on joining the colony and loses it on transfer to a neutral trader owner, with film evidence |
| Scenario 6 health | `14` with `wsl-deps.runtime-evidence.map` | pain and bleeding create a capped negative Health contribution that returns to zero after healing, with live-tip film evidence |
| Scenario 10 halt and resume | `15` with `wsl-deps.runtime-film.map` | milk progress remains unchanged below the floor for an hour, then resumes from the preserved amount, with a mid-scenario tick film covering both hours |

There are no declared incompatibilities and no other optional gameplay integrations. Harmony is
a hard dependency and is staged by the shared launcher. RIMMSQOL remains test-only and optional.

From the collection root, after confirming the shared machine is free, the future runtime commands are:

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Language French
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.avec-rimmsqol.map -Filter 03-rimmsqol.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 04-animal-eligibility.feature -Language English
& scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.avec-rimmsqol.map -Filter 05-rimmsqol-restart-reveal.feature -Then @('06-rimmsqol-restart-hide.feature', '07-rimmsqol-restart-forget.feature') -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 08-save-reload.feature -Language English
& scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 09-settings-restart-write.feature -Then 10-settings-restart-read.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 11-loading-hour.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 12-scenario-01-eligibility.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 13-scenario-02-faction-transitions.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-evidence.map -Filter 14-scenario-06-health.feature -Language English
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.runtime-film.map -Filter 15-scenario-10-halt-resume.feature -Language English
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
