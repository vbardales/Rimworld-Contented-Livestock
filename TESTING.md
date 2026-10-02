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

## Manual scenarios

Written 2026-10-02 for the `tested` gate ("no manual test left to validate"). Everything the sheet
`docs/MANUAL-REVIEW.md` lists is either asserted by a Pickle scenario (the captures are only read afterwards) or
listed here with its reason. Only the rows below need a person at a keyboard, and none blocks `tested`.

| # | Precondition | Action | Expected | Status |
| --- | --- | --- | --- | --- |
| M1 | Mod enabled, a colony loaded | Options, Mod options, pick Contented Livestock | The same dialog as the shortcut opens, values equal | Not automated: Pickle opens the same `Dialog_ModSettings` directly. Owner check, one minute |
| M2 | Screen under 1080 lines | Open the dialog | Every control reachable by scrolling | Not applicable to the validation: the dialog is checked at 1920 x 1080 |
| M3 | A muffalo offered by a trader | Buy it through the trade dialog | It arrives with a Contentment bar, no error in the log | Owner check: the faction change is asserted (scenario 2), the dialog itself is not driven |
| M4 | Scenario 10 film | Watch `film.webm` | No flicker, the cow behaves normally while halted | Owner check: smoothness is not machine-readable |
| M5 | Scenarios 4 captures | Look at the two bar pictures | Well fed against not fed reads at a glance | Owner check: a design judgement |
| M6 | Scenario 15 | Reset confirmation and slider caps | Asserted (cancel keeps values, confirm restores the eleven defaults, both ends and clamps) | Automated and green; the captures need only a look |

M1, M3, M4 and M5 are optional spot checks; M2 is not applicable. None is a validation the gate waits on.

## Proofs to keep after a pass

Evidence stays on disk in `Tests/Pickle/evidence/` (ignored by git, shared disk), one text line per run in
`docs/runs/`. After each pass, using `-EvidenceDir`, keep only:

- `summary.json`, `summary.md`, `junit.xml`, `Player.log` of the latest run of each pass, after reading `exitReason`
  and the played count against the discovered count;
- one capture per asserted state, as JPEG `-q:v 3`, opened before it is converted;
- a film only for the halt-and-resume scenario (pass 6), the one assertion that depends on time;
- an older report only when no later run repeats its check.

Delete `report.html` and `messages.ndjson` at once, the whole archive in `pickle-reports-archive/` of the run once its
evidence is copied, and everything a newer run of the same pass replaces. The list of what stays today is in
`docs/runs/README.md`.

## What a green run does not say

A green run says the path ran, not that the capture shows the right thing: the `@review` captures are opened
and read (by Claude for the text they carry, by Virginie for what needs a person). Read `exitReason` before the
numbers, and the count of scenarios played against the count discovered.

## Stated limits

Backward compatibility of saves (adding the mod to a save, removing it) is not handled or tested, by decision of
2026-09-24; manual scenario 14 is out of scope. The Options -> Mod options route is not driven by a scenario,
only the same settings window opened directly. Sliders and toggles are set in code and the window draws them.
The tip in the review captures is a message box opened by the test, not the game's hover tooltip.
