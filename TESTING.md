# Testing

How this mod is tested, how many game passes it needs and what each one covers (`AUDIT.md`, "Tests Pickle":
a mod whose `TESTING.md` does not say how many passes it needs is tried, not tested). Detail of the
development-only companion: `Tests/Pickle/README.md`. History of runs: `docs/runs/`. What a person must judge
after a run: `docs/MANUAL-REVIEW.md`.

## Out of the game

`powershell -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`: 35 tests, no game launched (contracts
of the vanilla classes the patches hang off, settings, curves, Scribe, XML, translations). Run after every change
to `Source/` or `Mod/`.

`Tests/Pickle/Check-Steps.ps1`: compiles every local step expression and rejects duplicate or unused ones.

## In the game: the passes

No optional gameplay mod is required and **no incompatibility is declared**, so there is no pass to look at an
incompatibility. Harmony is a hard dependency staged by the launcher. The companion tools below are
development-only and never a dependency of the mod. Every pass is one request to TicketDispatcher, never a
launcher of ours (`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`); `-DepMap` is the file name alone.

| # | Pass | `-DepMap` | Language | Features | What it covers |
| --- | --- | --- | --- | --- | --- |
| 1 | Without optional mods | `wsl-deps.runtime-evidence.map` | English | every feature except the ones of passes 3 to 7 (they skip by requirement) | loading without errors, the real settings window and its reset, eligibility, faction changes, health, rates, harvesting, laying, the five inputs, feed, temperature, the pen, a real save and reload |
| 2 | Without optional mods, French | `wsl-deps.runtime-evidence.map` | French | `01`, `02` | the French resources and the French settings page |
| 3 | With RIMMSQOL | `wsl-deps.avec-rimmsqol.map` | English | `03` | list, reveal, activate, hide and forget the hidden main-bar shortcut |
| 4 | RIMMSQOL restart chain | `wsl-deps.avec-rimmsqol.map` | English | `05`, then `06`, then `07` | reveal and hide choices survive separate processes, the last one forgets |
| 5 | Settings restart chain | `wsl-deps.runtime-evidence.map` | English | `09`, then `10` | all eleven settings survive a separate process |
| 6 | With FilmTicks | `wsl-deps.runtime-film.map` | English | `15` | halt below the floor and resume, filmed by ticks |
| 7 | Presentation | `wsl-deps.studio.map` | English | `16` | the four Workshop pictures on the zen-meadow fixture; run only for pictures, never as a functional pass |

Seven requests for a complete validation. A fix or an exploration runs one scenario (`-Filter '::<name>'`);
an initial or a final pass runs everything above. A pass that skips a scenario by requirement is not a pass of
that scenario: pass 1 skips the features that need a companion staged by another map, and those are covered
by passes 3 to 7.

## What a green run does not say

A green run says the path ran, not that the capture shows the right thing: the `@review` captures are opened
and read (by Claude for the text they carry, by Virginie for what needs a person). Read `exitReason` before the
numbers, and the count of scenarios played against the count discovered.

## Stated limits

Backward compatibility of saves (adding the mod to a save, removing it) is not handled or tested, by decision of
2026-09-24; manual scenario 14 is out of scope. The Options -> Mod options route is not driven by a scenario,
only the same settings window opened directly. Sliders and toggles are set in code and the window draws them.
The tip in the review captures is a message box opened by the test, not the game's hover tooltip.
