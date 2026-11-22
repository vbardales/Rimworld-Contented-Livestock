## 2026-09-22.md
# 2026-09-22

Every launch went through `scripts/Run-PickleWsl.ps1` (shared lock, WSL RimWorld, Xvfb). The
Windows RimWorld was neither launched nor closed. Media: `Tests/Pickle/evidence/2026-09-22/` and
`Tests/Manual/evidence/2026-09-22/`.

## Pickle passes, against revision `7716d99`

| Set | Filter | Result |
| --- | --- | --- |
| `runtime-evidence` | whole companion, English | passed: 6 passed, 3 RIMMSQOL scenarios skipped |
| `runtime-evidence` | whole companion, French | passed: 6 passed, 3 skipped |
| `avec-rimmsqol` | `03-rimmsqol` | passed: 3 of 3 |
| `runtime-evidence` | `04-animal-eligibility` | passed: 4 of 4 |
| `avec-rimmsqol` | restart chain 05, 06, 07 | three fresh reports, each 1 of 1 passed |

Reviewed by eye: the English and French settings pages show all eleven controls with no raw key,
clipping or fallback. The RIMMSQOL capture shows the revealed shortcut opening this mod's own page.

## Manual scenarios, one targeted run each

| Scenario | Revision | Result | What was seen |
| --- | --- | --- | --- |
| 0 first game hour | `7565df3` | 1 of 1 | milk fullness 0.1% to 3.3% over 2,500 ticks, film 31.385 s; log free of the four failure signatures |
| 1 eligibility | `5533d99` | 1 of 1 | need on cow and hen, absent on husky, colonist, wild squirrel; five captures |
| 2 faction transitions | `e679f26` | 1 of 1 | need appears on taming, vanishes on transfer to a neutral trader owner; film 9.552 s. **Partial**: a real trade-dialog sale was not tested |
| 6 health | `733531e` | 1 of 1 | cut gives Health -5%, capped at -35%, healing clears it; film 16.251 s |
| 10 halt and resume | `378c20d`, then `fbafea8` | first attempt failed, second passed | see below |
| 13 save and reload | `70f2cf3` | 1 of 1 | cow at 73% with -15% Kibble memory, identical after reload |
| 13 settings restart | `e99ce56` | 1 of 1 in each of two processes | all eleven values survive a process restart, then the profile is restored |

**Scenario 10, first attempt.** Failed: fullness moved 0.033214 to 0.033239, one tick's worth. The
test had recorded its baseline before setting contentment to 10%, so setup time was in the
baseline. A test defect, not a production one. Corrected and rerun: 3.3% held at 10% and 14%
contentment over a game hour, then 9.1% after restoration. The 60-second film cap ended before the
final state of a 101-second scenario, so scenario 10 stays incomplete until a tick-film covers it.

## Not established

Manual scenarios 2 to 5, 7 to 12 and 14 to 17. The first screenshots of scenarios 0, 2 and 13 have a
black upper region, a render-target artefact; the assertions and the lower-left Needs pane are
unobscured.

## Media, 2026-09-23 note

The Pickle and manual media of this day were deleted on 2026-09-23 under the evidence rule in the
root `AGENTS.md`, because the whole-companion pass on `d9be961` replaced them. Kept: the RIMMSQOL
reports and the restart chain (the later pass did not repeat them), the French settings capture, and
scenario 10 attempt 02 (that scenario is skipped in the later set). Everything above is the record.

## 2026-09-23.md
# 2026-09-23

## Whole-companion pass, `runtime-evidence`, English - failed

`exitReason: failed`. 24 discovered, 15 passed, 2 failed, 7 skipped (six RIMMSQOL, one FilmTicks,
absent from this set as expected). Media: `Tests/Pickle/evidence/2026-09-23/runtime-evidence/`.
Two captures were never copied: their names, built from feature, scenario and step, exceeded
MAX_PATH. The report and the NDJSON log are not kept; they were 80 MB and 9 MB.

Failures:

- Scenario 01 eligibility: a husky carried the need.
- Scenario 06 health: the health offset was exactly zero.

**Cause.** Neither is a fault of the mod. The restart pair writes eleven deliberately non-default
settings. The reader's restore put back only the settings file, not the values in memory, so
`producersOnly` and `healthMatters` stayed false for every later scenario in the same process. Both
scenarios had passed alone under a filter. One open capture, of scenario 04, shows the cow and its
contentment bar correctly.

## Fixes, pushed

`43372fb` added a restore step to feature 10 and the two affected features. `d9be961` moved the
fix into `SettingsSandbox`, where the leak lived, tagged features 09 and 10 with the
ScreenshotMode requirement, and shortened two titles.

## Verification run, `runtime-evidence`, English - passed

Ticket 30044, revision `d9be961`. `exitReason: passed`, 24 discovered, 17 passed, 0 failed, 7 skipped (six
RIMMSQOL, one FilmTicks; the same seven as the morning run, none of them from this set). Scenarios 01
and 06, the two that failed in the morning, both pass. No `FieldAccessException`, `HarmonyException`,
missing-method or unresolved-need line in the Player log. The game exited 137 (killed) after writing a
complete report; the launcher kept the report.

Opened: the scenario 06 injured-cow capture. Its live tip reads Contentment 50%, Health -8% and the
pane shows `ScenarioSixCow`, `Injured`. The frame is tiled, a render-target artefact, but the subject
is legible. The other 22 captures were not opened.

**Evidence is incomplete: the disk was full.** The launcher's copy failed with "not enough space" and
C: had 0 bytes free. On disk under `Tests/Pickle/evidence/2026-09-23/runtime-evidence-fix/` are `summary.json`, `summary.md`, `junit.xml` and `Player.log`, each verified identical to the source.
The 24 captures were copied afterwards, once space came back; 22 are kept as JPEG (about 6 MB in all),
the two duplicates of scenario 02 being dropped.

Still owed for the tested gate: an `avec-rimmsqol` pass and a set that stages FilmTicks, neither
existing against the current revision.

## 2026-09-24.md
# 2026-09-24

## Presentation scenes, `studio` set, English - first run failed, second passed

Pictures for the Workshop page, `16-publication-shots.feature`, on the zen-meadow fixture. Staged, not
played: contentment is set and the feed memory planted; the rates and the milk are the real ones.

**First run** (queued directly, 09:52): 3 scenarios, 2 passed, 1 failed. Cause: the fixture already holds
a macaw named "Clover", and `PawnNamed` takes the first pawn of a name, so the two-cows scene read a bird's
comps. Renamed to "Buttercup"; the other names were checked against every pawn name in the saved fixture.
Opening the two passing pictures showed three more faults, fixed before the rerun: the centred tip sat on
top of the cow, six letters crowded the right edge, and the saved camera was too far out for a cow to be
more than ten pixels wide. The archive of that run was deleted after these notes.

**Second run** (request `20260924-164607-907-3444`, through TicketDispatcher): 3 scenarios, 3 passed,
exit 0, 1 attempt. Media: `Tests/Pickle/evidence/2026-09-24/publication-shots/`, three JPEGs and the four
text files; the 22 MB report was not kept. All four pictures were opened at full size.

- Picture 2 (well kept, 100% contentment) shows milk fullness 11% and a full bar; picture 3 (badly kept,
  30%) shows 4.7% and a short bar, after the same two game hours. The gain is 2.3 times, not the 2.9 of the
  two production factors (140% and 49%): contentment drifts during the two hours. A caption must not
  quote a ratio.
- Picture 4, the settings page over the meadow, is clean and legible.
- **Picture 1 is not usable.** The tip is now top left and the cow is visible, but the game draws a
  tooltip of whatever is under Pickle's pointer, which rests at the screen centre after a camera jump, and it
  named another pawn ("Miel, Surveyor") beside the cow. That capture was deleted. Fix: a step that
  shows the cow three cells left and four up, so the pointer rests on bare ground. Not run yet.

Alerts on the right of pictures 1 to 3 ("Need colonist beds", "Pen needed", "Medical treatment needed")
and the Learning helper are the fixture's real interface and were left: ScreenshotMode would hide the
Needs pane, which is the subject.

## Pass `avec-rimmsqol`, English - passed

Request `20260924-164702-273-8eb0`, through TicketDispatcher, on HEAD `10001d1` (`Mod/` unchanged since
`4531a66`). Four launches under one hold of the lock: feature 03 (3 of 3), then the restart chain 05, 06,
07 (1 of 1 each). 6 of 6 passed, 0 failed, 0 skipped: exactly the six RIMMSQOL scenarios the 2026-09-23
`runtime-evidence` set skipped. One capture kept, of the settings page opened through the RIMMSQOL
shortcut, opened at full size (it shows the ordinary dialog; that the route was the shortcut is the
scenario's assertion, not visible). The launcher also saved a fifth folder, byte-identical to the fourth:
a launcher fault reported to TicketDispatcher, and the duplicate deleted.

## Pass `runtime-film`, English - passed

Request `20260924-164703-249-5a81`, through TicketDispatcher, on HEAD `10001d1`: scenario 10, halt and
resume, the one scenario that needs FilmTicks. 1 of 1 passed, exit 0, 1 attempt. Milk fullness 3.3% before
the halted hour, 3.3% after it (Contentment 10% then 14%, under the floor, the tip reads "Too miserable to
produce"), 9.1% once Contentment was restored; the three captures were opened at full size. The film
(52 s, 960 x 540, 153 KB) was viewed only as a 12-frame contact sheet, which shows the cow moving with the
camera on it and the bar low, but where the milk figure is unreadable: the numbers rest on the captures.

The 2026-09-22 media for this scenario, and the RIMMSQOL reports and restart chain of that day, were
deleted as superseded by this run and by `avec-rimmsqol`. Kept from the 22nd: the French settings capture,
the only proof of the French rendering. Evidence on disk is 9.2 MB.
## 2026-09-25.md
# 2026-09-25

## Scenario 15 with keyed clicks: passed; two more requests filed

Request `20260925-185641-921-215f`, on `d8b2fd9`: 1 of 1 passed, exit 0. The reset button, "Go back" and "Confirm" are
clicked by their translation keys (KeyedClick: `ContentedLivestock.Settings.Reset`, `GoBack`, `Confirm`) and the two
captures (the confirmation window with the eleven distinctive values behind it, then the defaults back) read as before.
This replaces the English-label clicks of `…-67a2`; the other three scenarios of feature 22 are unchanged and stand.

All four requests of the 18:56 batch are back: three green, the pen red on a method name (see below). Filed at `124051e`,
the last tree before the final commit: scenario 8 again (`…-327e`, the pasture step now maps to the space input) and
picture 4 with the contentment bar (`…-e413`, studio set). Same commit: the producers-only setting reads "Only
animals that give milk, wool or eggs have contentment" (owner's option C, English and French), `About.xml` is in step
with the publication text (licence, Codex and DALL-E, thanks, links), and the 35 out-of-game tests still pass.

## Scenario 8, pen: the premise held, the next step failed on a name

Request `20260925-185639-059-8821`, on `d8b2fd9`: failed at the fifth check with "Need_Contentment has no
PastureOffset method". **The riskiest premise held**: the steps before it passed, that is the fence built in code was
recognised by the game as a pen, the four cows were inside it, and the pen "grows less than its animals eat" (the
balance the pen marker shows). The failing step is the generic "the {word} contribution ... is negative": it turns
the word into a method name (`Pasture` + `Offset`), and the mod's method for that input is `SpaceOffset`, since the
pen and the room are one input in the code. A fault of the step, not of the mod; the fix maps "pasture" to the
space input. It waits for the last queued request (`…-215f`) to be back, since the tree must not move under a
request. The failed capture and folder were deleted.

## Scenario 5, temperature: passed on the rebuilt DLL

Request `20260925-185634-777-0318`, on `d8b2fd9` (Mod/, Tests/ and Source/ unchanged since), set runtime-evidence:
1 of 1 passed, exit 0. In a cold snap set 6 degrees under the hen's cold limit (outdoors -16), the hen's tip reads
Temperature -12 percent and the husky's +5; after the snap ends the hen reads +5 again. All three captures were
opened, kept as JPEG; the report was not kept. Validated by Claude, nothing left for the owner.

## Scenario 11 hen: passed on the rebuilt DLL

Request `20260925-185631-016-09ac`, on `d8b2fd9` (the tree did not move since; only documents changed): 1 of 1
passed, exit 0. The step now places the egg that the game's `ProduceEgg` makes; the capture reads "Egg progress: 0%"
with the egg on the cell, and the run asserted the egg, the reset to zero and the slow rise over one game hour.
Scenario 11 is complete (3 of 3). The capture is kept as JPEG; the report was not kept.

## The three reruns failed on the old steps DLL: my mistake

Requests `…-217d` (scenario 11 hen), `…-69e3` (scenario 5) and `…-d762` (scenario 8) failed with **exactly the
same messages as before their fixes**. Cause: the step fixes were compiled to a temporary folder for a check, and
the tracked `Tests/Pickle/Mod/Pickle/Assemblies/ContentedLivestock.PickleSteps.dll`, the one the game loads, was
never rebuilt (its last build was 12:37, the fixes came after). `AUDIT.md` says it: the step DLLs are loaded at
game start, so check the build time against the fix before reading a failure. Rebuilt with `-c Release` to its
real output at 18:55 and committed (`d8b2fd9`); the reruns are `…-09ac` (hen), `…-0318` (scenario 5)
and `…-8821` (scenario 8). The three failed folders were deleted.

Same request batch, on the DLL of that time: **scenario 12 passed** (`…-088f`, 1 of 1: the hen with the need reads
16 percent egg progress against 14 for the reference from 10, and has a Contentment bar the reference lacks) and
**presentation picture 1 passed and is usable** (`…-29ec`: Daisy stands left of centre with her bar at 72 percent,
the tip at the top left reads "Last fed on: +15%", no stray tooltip; Miel was sent away and the pointer rests on
nothing). Both read at full size, kept as JPEG, reports deleted.

Also filed at `d8b2fd9`: scenario 15 clicks its buttons by translation key (KeyedClick, new line in
`wsl-deps.runtime-evidence.map`), request `…-215f`.

## Scenarios 5 and 8 failed on test steps, not on the mod

Request `20260924-235901-583-919e` (scenario 5): failed at once, "GameCondition_ColdSnap has no tempOffset field".
The game's own cold snap ramps to a fixed -20 and holds no offset to set; the class that holds one is
`GameCondition_TemperatureOffset`, used by the climate adjusters. The step now makes a condition of that class
from a def built in code (not in the database, not saved) with the offset worked out from the hen's cold limit.
Request `20260924-235902-124-0294` (scenario 8): failed with "PenMarker is madeFromStuff but stuff=null", the
step made the marker without a stuff; it now takes the default one. Neither run reached the mod, so nothing is
learned about the pen or the temperature yet. Both failed captures and reports were deleted. Reruns submitted at
`5280e28`: scenario 5 as `…-69e3`, scenario 8 as `…-d762`.

## Scenario 4, feed and its fading memory: passed

Request `20260924-235901-041-398b`, feature 24, on the pre-fix DLL (the pen rule is not exercised here): 2 of 2
passed, exit 0. Grass gave +25 percent, hay nothing and kibble -15; after 400 need intervals the three cows had
settled in that order; one meal faded +25, +19, +6 and gone at 0, 12, 36 and 48 hours, as 25 x (1 - age / 2 days)
gives. The two days are simulated (the meal's time moved back), the game day is 400 intervals in a loop. All nine
captures were opened and kept as JPEG; the report was not kept. The verdict on the two bar pictures belongs to
the person.

## Scenario 16, each setting's effect: passed

Request `20260924-235047-879-0c3c`, feature 23, on the pre-fix DLL (the pen rule is not exercised here): 7 of 7
passed, exit 0. Each of the five inputs, off and on again, removed and restored its tip line and its
contribution; the rate followed a floor of 30, a plateau of 70 and rate factors of 20 and 160 (0, 22, 60, 100 and
160 percent); the speed of change moved 1.25, 5 and 20 points in 20 intervals at 25, 100 and 400 percent and
stopped on its target. All twelve captures were opened and kept as JPEG; the report was not kept. The guesses
about the husky for the pasture input held. The verdict belongs to the person.

## Scenario 15, settings window: passed

Request `20260924-235045-153-67a2`, feature 22, on the pre-fix DLL (the settings window is unaffected): 4 of 4
passed, exit 0. Defaults, both slider ends, the plateau held five points above the floor, out-of-range values
held, eleven values kept across closing and reopening, and the reset (cancelled, then confirmed) all read as the
scenario says. The guesses about the English labels "Reset to defaults", "Go back" and "Confirm" with the
built-in button step held. All eight captures were opened, kept as JPEG; the report was not kept. One point for
the owner's eye: the reset confirmation window is large and mostly empty. The verdict belongs to the person.

## Scenario 11, harvest: cow and sheep passed, hen failed on a test defect

Request `20260924-233844-930-49a5`, feature 20, on the pre-fix DLL: 2 of 3 passed, exit 1. The cow and the sheep,
gathered through the game's own method at 100 and at 30 percent contentment, gave the game's own yield each time
and the same amount both times; both panes read back at about zero (0.01 percent milk, 0 percent wool). The two
captures were opened and kept as JPEG; the reports were not kept. **The hen failed: "egg progress was full but no
egg appeared (0 before, 0 after)".** Cause, read in the decompiled `CompEggLayer`: `ProduceEgg()` resets the
progress and returns the egg, and only the laying job spawns it, so the step made an egg nobody put on the map.
This is a defect of the step, not of the mod. The step now places what `ProduceEgg` returns (and tries again if
the clutch range gives zero); rerun submitted as `…-217d` (commit `107dc9b`). Feature 21 (scenario 12) did not
run in that request: submitted on its own as `…-088f`.

## Scenarios 3 and 7, producers-only and company: passed

Request `20260924-233844-225-ee20`, features 17 and 18 in two launches, on the pre-fix DLL: 1 of 1 and 1 of 1,
exit 0. Scenario 3: a husky has no contentment bar, gains it when producers-only is off and loses it when it is
on again, and a cow keeps its 72 percent bar through both. Scenario 7: a lone muffalo reads Company -10, two of
its kind beside it remove the line, a bond with a colonist gives Company +10; the level (50 percent) and the rate
(83 percent) are the same in all three tips, since only the offset moves at once. All eight captures were
opened; the reports were not kept. In two scenario 3 captures the hover label names the previous animal: the
pointer stays still while the selection moves, so it is a harness artefact, not the mod.

## Scenario 9, the rate: passed

Request `20260924-233843-303-7485`, feature 19, on the pre-fix DLL (the pen rule is not exercised here): 1 of 1
passed, exit 0. Three cows at 100, 60 and 26 percent read 140, 100 and 42 percent in their tips; after one game
hour the well-kept cow had 5.9 percent milk fullness and the neglected one 1.9, against 4.17 percent for a
vanilla hour. All five captures were opened; the 20 MB report was not kept. No capture of the plateau cow after
the hour, so its within-15-percent check rests on the code. The verdict belongs to the person, see
`docs/MANUAL-REVIEW.md`.

## Presentation picture 1, second run: passed, still not usable

Request `20260924-224905-628-445f` (first rerun of scenario 1 of `16-publication-shots.feature`, after the
cow was shown three cells left and four up): 1 of 1 passed, exit 0, 1 attempt. The capture was opened at full
size. The cow is off-centre as intended, at the left, with its selection bracket, the tip is at the top left
and the bar reads 72%. **The stray tooltip "Miel, Surveyor (female colonist)" is still drawn**, at the
pointer, near the centre, while Miel stands about two cells left of it.

**Cause, refined.** The tooltip is not from the cow being under the pointer any more. Miel is the actress of
the flower glade, which is exactly where the cows are put, so she walks under the pointer while the game
runs and the tooltip stays drawn for a few frames. **Fix:** a step sends her to the zen garden before anything
else in the scene. Not run yet: request submitted. The flawed capture and its 6.7 MB report were deleted.

## Pen rule corrected: the mod did not do what scenario 8 says

Not a run: a finding made while writing the in-game scenario for the pen (feature 26), and a fix.

**The finding.** `Need_Contentment.ComputeSpaceOffset` judged a roped animal in a pen with
`Lerp(-0.2, 0.2, clamp01(grown / eaten))`: a straight line from -20% with nothing grown to +20% at balance.
The line is negative only below half of the balance and positive above it, so a herd that ate more than the
pen grew, down to half of it, read positive. `_tools/FUNCTIONAL-SCENARIOS.md` scenario 8 says the line
follows the pen marker's balance, negative when the herd eats faster than the grass grows and positive when
it does not. The owner confirmed on 2026-09-25 that this wording is what was meant.

**The fix.** `Clamp((grown / eaten - 1) * 0.2, -0.2, 0.2)`: zero at balance, negative below, positive above,
-20% with nothing grown and +20% at twice what is eaten. The case of no animal eating (+10%) is unchanged.
Only pen-managed animals with a pen recognised by the game are affected. A room, a lone animal and every
other input are not.

**What it touches.** `Mod/Assemblies/ContentedLivestock.dll` changed, from SHA-256 `e69349c34f01e7e3` to
`7653167da2c9a605`; a second rebuild gave the same hash. The 35 out-of-game tests pass. No earlier Pickle
run exercised a pen, so their results stand for what they tested, but they were taken on the older DLL: the
`tested` gate wants a full pass on the final SHA, which is now owed. The 2026-09-13 settings manifest in
`_tools/results/` is a dated record whose hashes had already moved and was not touched.

The feature for scenario 8 (26) holds the sign as well as the value, and its pending request runs on the
new DLL. Feature 26 has not run.

## 2026-09-27.md
c204 scenario-08-f: failed, diagnostic only (pen grows 0.001/day, 25 cells, 0 roofed, fertility 25.0 — bare soil with no grass planted); fix applied to BuildPen (sows mature grass), evidence deleted after reading.

## 2026-09-28.md
5103 scenario-08-m: passed 1 of 1 at 03e681d (pen growth staged at 1.0 a day; four cows -14 percent, two cows -8 percent); earlier c204, 8bf0, fafc red: Desert tile grants 0.001 a day; 46fe, 9e71, 1f7b, 4a48 exit 8: my filter string 'scenario 8' matched nothing. Evidence of the reds deleted.
514a scenario-15-ticks2: passed 4 of 4 (default tick mark visible on every slider); db87 skipped 4/4, keyedclick dep missing, no -DepMap; e553 scenario-17-bare-bar2: pending; be60 scenario-17-bare-bar: 3/3 passed but bare-bar capture useless (screenshot mode hid interface).

## 2026-09-30.md
2026-09-29 scenario-17-worldview, set avec-rimmsqol: 3 of 4 passed, `exitReason: failed`; the world-view scenario failed with "Specified cast is not valid" at the step "leaves the map for the world view" (`Game.currentMapIndex` is an sbyte, not an int; fixed in a0aace5). Its step-5 capture showed the plain colony map, not the world view, so it proved nothing. Evidence deleted 2026-10-02, superseded by the run below.
2026-09-30 avec-rimmsqol (report preserved 2026-10-01 19:03, after a0aace5): 4 of 4 passed, `exitReason: passed`, none skipped. Two captures opened and minified to JPEG (`Tests/Pickle/evidence/2026-09-30/screenshots`): the main bar bare before RIMMSQOL reveals anything (no Contented Livestock shortcut, none greyed), and the settings dialog opened through the revealed shortcut (English, all five sliders, five inputs, the producers-only toggle, reset and close, no raw key and no clipping). The world-view scenario passed but attaches no capture, so the world view itself was not seen. DLL tested not recorded in the report; the last build is the one starting `7653167da2c9a605`.
2026-10-02 evidence cut (audit): `report.html` and `messages.ndjson` deleted from all runs (about 60 MB), the scenario 15 runs of 09-24 and 09-25 (superseded by 09-28 ticks2), the 09-28 bare-bar run (superseded by 09-30), the 09-29 failed run, and the scenario 3, 9 and 10 captures of the 09-23 run (rerun since). Disk 92 MB to 20 MB. Kept list: `docs/runs/README.md`.

## 2026-10-10.md
# 2026-10-10

- Out-of-game tests: 35 of 35 passed on 5fbc567 (before and after the move of `_tools/` to `scripts/`). DLL rebuilt from `Source/`: identical to the shipped one, SHA256 starts 47556223324698BC.
- Pickle request 20261010-224451-852-b830, HEAD 54490b5, no `-DepMap`, English, no filter, `exitReason: failed`: 51 scenarios, 30 passed, 1 failed, 20 skipped. Skips: features that need the ScreenshotMode or KeyedClick companions or RIMMSQOL (not staged without a map). Failure: scenario 02 (trade), step "animal has no contentment need", `no spawned pawn named 'TradeScenarioMuffalo'` (the trader carries the muffalo unspawned). Cause read from `junit.xml`, not assumed. Evidence on disk: `Tests/Pickle/evidence/2026-10-10/initial-minimal-en/` (`summary.md`, `junit.xml`, `Player.log`, screenshots; `report.html` and `messages.ndjson` deleted). No capture opened.
- Fix: `Tests/Pickle/Source/Driver.cs`, `PawnNamed` also searches pawns carried in a spawned pawn's inventory; steps DLL rebuilt. Replay owed, alone (`::the colony buys a muffalo`).
- 2026-10-11, CI copy regenerated with `generate-publish-workflow.sh --replace` (it drifted from the template in `build-check.sh` and its test; `publish.config.json` pointed `galleryDir` at `Art/WorkshopScreenshots`, now `Art/Gallery`; `build.yml` added with `--build-project Source/ContentedLivestock.csproj`). `Check-CiTemplate.ps1`: identical to the template; the 75 workflow script tests pass. No dry-run, no publish.
- Pass 2 (request 20261011-004047-756-d5b6, features 01 and 02, French, runtime-evidence map, `exitReason: passed`): 6 scenarios, 6 passed, 0 failed, 0 skipped. Capture `settings-fr.jpg` opened: French settings page, five sliders and six toggles, no raw key, no accented fallback text, no clipping or overlap. It still shows an em dash in the intro sentence (player-facing French, left for Virginie). Evidence on disk: `Tests/Pickle/evidence/2026-10-11/pass2-fr/`.
- Pass 3 (request 20261011-185107-460-9215, feature 03 with RIMMSQOL, `wsl-deps.avec-rimmsqol.map`, English, `exitReason: passed`): 4 scenarios, 4 passed, 0 failed, 0 skipped. The first submission (004049-658-ef50) was abandoned: the worker died before the run. Evidence on disk: `Tests/Pickle/evidence/2026-10-11/pass3-rimmsqol/`; its capture was not opened.
- Scenario 02 (trade), three replays: (1) `no spawned pawn`: PawnNamed now also searches carried pawns. (2) pass 1 and replay 1: `Pawn.trader` was null on a hand-made pawn and `CanTradeNow` false (NullReferenceException in the dialog): tracker and `traderKind` created in the Given step. (3) replay 2: the muffalo still belonged to the trader faction: `ForceToDestination(1)` schedules a sale, a purchase is `ForceToSource(1)`. Replay 3 (request 20261012-041512-215-d0bb, HEAD 77ba6ef) passed 1 of 1, `exitReason: passed`; captures opened: trade dialog lists the muffalo, bought muffalo has the Contentment need and belongs to the player.

- Evidence folders `evidence/2026-10-10/` and `evidence/2026-10-11/` named above were deleted on 2026-10-18 (old DLL, no longer proving anything); the results stay recorded in this file.

## 2026-11-13.md
# 2026-11-13

Pickle runs on the current DLL (SHA256 starts C105BF9A830D66C7, Source unchanged since 5775be9), RimWorld 1.6.4871 rev600. Results copied from `summary.json` read the same day; evidence folders deleted after reading (nothing kept, Tests/Pickle/Evidence holds only the older scenario15-french).

- Pass 4, RIMMSQOL restart chain (ticket 20261109-233155-242-8e5a, `-Filter '05-rimmsqol-restart-reveal' -Then '06-rimmsqol-restart-hide','07-rimmsqol-restart-forget' -NoBatch`, avec-rimmsqol map, runner auto): three launches, 05, 06 and 07 each 1 of 1 passed, `exitReason: passed`. Earlier attempts of 2026-11-06 to 2026-11-09 (3935, ca0d, 4b80, ee00, ac97, f2f1, 536c) ended in infrastructure errors (RAM, server filter) or in the harness refusal when `-Then` reached the shell as one string; none was a mod fault.
- Initial pass 1 (ticket 20261113-185445-041-94ca, tree 64ad171, runtime-evidence map, English, no filter, azure): 51 scenarios, 40 passed, 0 failed, 11 skipped, `exitReason: passed`. The 11 skips need other maps: 4 RIMMSQOL (pass 3), 3 restart chain (pass 4 above), scenario 15 halt-resume (runtime-film map, passed 2026-10-17), 3 publication shots of feature 16 (studio map, shootGallery).
- French settings (ticket 20261113-194018-786-6d3b, `-Filter '22-scenario-15-settings,02-settings-and-language' -Language French`, azure): 7 scenarios, 6 passed, 1 failed: `every keyed text is loaded for this language`, `only 0 English keys start with 'ContentedLivestock.', expected at least 36`. Cause: the step counted English fallback keys that a French pass had not loaded; not a mod fault.
- Fix: `Tests/Pickle/Source/LanguageSteps.cs` loads the English fallback when it is empty; steps DLL rebuilt.
- French keyed text, replay alone (ticket 20261113-201907-523-5c2c, `-Filter '02-settings-and-language' -Language French`, azure): 3 scenarios, 3 passed, 0 failed, `exitReason: passed`.
- Captures of these runs were not opened (evidence deleted unread): 8.d stays open.
- French settings page capture (ticket 20261113-230147-328-041b, `-Filter '02-settings-and-language::primary settings page' -Language French`, runtime-evidence map): exit 0, 1 of 1 passed, `exitReason: passed`. Capture opened and read: French primary settings page, all strings translated, no overflow, sliders, five checks, reset and close buttons readable. Evidence folder `capture-fr-settings` deleted after reading (line written 2026-11-17 from the STATUS.md record and commit e86fc20; the summary.json is gone).

- Gallery look-fix probe (ticket 342f, tree 9cb2c69, `-Filter` scene 1 alone, studio map, English): 1 of 1 passed, `exitReason: passed`. Capture opened and read: Outdoors 20C, no heat alert, no sweat drop or red cheek visible on Nelim at map zoom (4x zoom not checked). Heavy files deleted, capture minified (jpg 1280 q70) in Tests/Pickle/Evidence/look-fix2-1 with RELEASE.md, deleted once the scene 1 gallery jpg is rated. Refiled scenes 2 to 6: 8e91, 8b22.
