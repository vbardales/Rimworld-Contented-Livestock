# Testing

How this mod is tested, how many game passes it needs and what each one covers (`AUDIT.md`, "Tests Pickle":
a mod whose `TESTING.md` does not say how many passes it needs is tried, not tested). Detail of the
development-only companion: `Tests/Pickle/README.md`. History of runs: `docs/runs/`. What a person must judge
after a run: `docs/MANUAL-REVIEW.md`.

## Out of the game

Two commands, run after every change to `Source/` or `Mod/`, no game launched:

- `powershell -NoProfile -ExecutionPolicy Bypass -File Tests/Run-Functional-Tests.ps1`: 33 tests (contracts of the
  vanilla classes the patches hang off, injected parameters, settings, curves, Scribe, XML, translations).
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-HarmonyContract.ps1 -ModRoot . -MinPatches 4`
  (shared script of the protocols root): 6 checks on the shipped DLL, among them two checks that used to be tests
  of the 35 (every `[HarmonyPatch]` names a method the game has; every non-public game member the mod touches is
  covered by `IgnoresAccessChecksTo`). Total unchanged in substance: 35 tests before 2026-11-02, 33 here plus those
  shared checks.

`powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-Steps.ps1 -Mod ContentedLivestock` (shared script of the protocols root): compiles every local step expression, rejects duplicates, warns on unused ones.

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
| M1 | Mod enabled, a colony loaded | Options, Mod options, pick Contented Livestock | The same dialog as the shortcut opens | Not applicable (owner, 2026-10-02): that is retesting RimWorld's own Options screen, not the mod |
| M2 | Screen under 1080 lines | Open the dialog | Every control reachable by scrolling | Not applicable to the validation: the dialog is checked at 1920 x 1080 |
| M3 | A trader who sells a muffalo | Buy it through the trade dialog | It arrives with a Contentment bar, no error in the log | To automate (owner, 2026-10-02): a Pickle scenario brings a trader with a muffalo, captures or films the purchase. Not written yet: the mod tree is frozen until the passes of 2026-10-02 are done |
| M4 | Scenario 10 film | Watch `film.webm` | The cow behaves normally while halted | Owner is told when the new film (pass 6) arrives. Smoothness and performance are not the mod's claim: other mods measure performance |
| M5 | Scenario 4 captures | Look at the two bar pictures | Well fed against not fed reads at a glance | Owner check, by image: a design judgement |
| M6 | Scenario 15 | Reset confirmation and slider caps | Asserted (cancel keeps values, confirm restores the eleven defaults, both ends and clamps) | Automated and green; the captures need only a look |

M3 is the one gate item left to write; M4 and M5 are looks by the owner; M1 and M2 are not applicable.

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

## Functional scenarios (AUDIT.md 7.a, single source)


`Tests/Run-Functional-Tests.ps1` answers "do classes this mod leans on still do what it leans on them for". Cannot answer "does mod do what it says" — needs map, clock, animal. Scenarios below do, each with single thing to watch, single way of being wrong.

Mod never run in game. Until scenario 0 passes, nothing below worth playing.

**Setup for everything here.** Development mode on. Small colony, one cow, one sheep, one hen, one husky, pen with pasture. Time controls 3x for slow ones. Every scenario reads animal's inspect pane, contentment under food and rest, and mouseover tip on that bar, listing five contributions separately and current rate as percentage.

Clock note: contentment walks toward target at one full swing per day by default, so nothing below happens in seconds. Where scenario says *a day*, mean game day.

**Required visual evidence.** Manual scenario not passed by notes or `Player.log` alone. Save at least one full-resolution screenshot per stable state asserted. Record video when assertion depends on time, motion, transition, persistence across reload/restart, or before/after comparison one image cannot prove. Keep unedited media under `Tests/Manual/evidence/<date>/scenario-XX/` (on disk, ignored by git), name files so asserted state identifiable, record what was seen in that day's summary under `docs/runs/`. Review at full size, then minify what you keep as `docs/runs/README.md` describes. Final handoff must give captures or videos to user; written claim without media stays `unverified`.

---

### 0. It loads, and the patches take

**Do.** Start game with Harmony before this mod, no customization mod. Load any save. Let one game hour pass with milkable animal alive.

**Expect.** No red text at startup, none at first hour.

**Watch for in `Player.log`.** Three lines, each different failure:

- `FieldAccessException` naming `fullness` or `eggProgress` — access waiver missing from build. This exact fault shipped once, caught by test suite not play; see `Source/AccessChecks.cs`.
- `HarmonyException` or `Could not find method` at startup — patch target renamed by game update. Out-of-game suite catches this first.
- `Nelim_Contentment` reported as unresolved def — DefOf or def file did not load.

**If fails here, stop.** Everything below assumes patches live.

---

### 1. The need goes on the right animals, and only those

**Do.** Look at inspect pane of each: cow, hen, husky, colonist, wild animal on map.

**Expect.** Contentment on cow and hen. Not on colonist. Not on wild animal. Not on husky, because `producersOnly` on by default and husky produces nothing.

**Why it matters.** `minIntelligence` is floor with no ceiling, so nothing in def can say "animals and not colonists". If colonist has bar, postfix on `ShouldHaveNeed` not running, def taken at face value.

### 2. Taming and selling take effect at once

**Do.** Tame wild muffalo. Look at its pane without saving. Then sell animal to trader, look again before it leaves map.

**Expect.** Need appears on muffalo immediately, not after reload. Disappears from sold one.

**Why it matters.** Needs tracker only revisits list when asked. Without postfix on `SetFaction`, both changes wait for next load.

### 3. The producers-only switch

**Do.** In mod settings, turn `producersOnly` off, close window, resume play. Look at husky, including one previously in caravan after returning to map.

**Expect.** Husky now carries contentment. Turn setting back on, close window: it goes. Cow/hen keeps existing level through both changes.

---

### 4. Feed moves the target, and the kind of feed matters

**Do.** Three animals same species, kept identically. Let one graze living plant, feed one hay, feed one kibble. Wait a day. Read Feed line in each tip.

**Expect.** Grazing gives largest positive figure. Hay gives nothing either way. Kibble gives negative one.

**Then.** Stop feeding grazer anything for two days without letting it starve.

**Expect.** Its Feed line fades to nothing over those two days. Memory of meal not permanent.

**Why it matters.** Grazing detected by animal ingesting `Plant` itself, not by food type flags: hay and standing grass share same flag. If hay reads as grazing, detection broken.

### 5. Temperature is measured against the animal's own range

**Precondition.** Turn producers-only off, close settings so husky has contentment need too. Restore setting after scenario.

**Do.** Put husky and hen in same unheated room in winter. Read both Temperature lines. Then heat room to middle of hen's comfortable band.

**Expect.** Before heating, hen penalised, husky not, or much less. After, hen's line turns slightly positive.

**Why it matters.** Band is `ComfortableTemperatureRange()`, per animal. Single absolute threshold would punish both equally — wrong, would show here.

### 6. Health pulls down

**Do.** In dev mode, damage animal enough for pain and bleeding. Read Health line. Heal it, read again.

**Expect.** Negative figure that recovers. Never drops below -35 %, whatever damage.

### 7. Company

**Do.** Take one herd animal, muffalo for instance, put alone, far from any of its kind. Wait a day. Then bring two more of same species next to it.

**Expect.** Negative Company line while alone, gone once own kind within about twelve cells. Bond with colonist adds positive figure independently.

### 8. The pen is judged on its food balance

**Do.** Put four cows in pen pasture cannot sustain. Read pen marker's own figure, then Pasture line in cow's tip. Remove two cows, wait a day.

**Expect.** Pasture line follows pen marker's balance, negative when herd eats faster than grass grows, positive when not.

---

### 9. The rate really changes — the scenario the mod exists for

**Do.** Two cows, same species, same age. Keep one well: grazing, heated barn, company, healthy. Keep other badly but not below floor. Note fullness percentage of each in inspect pane, wait full day, note again.

**Expect.** Well-kept cow gained more than vanilla amount, neglected one less. At full contentment rate reads 140 %, at plateau 100 %, just above floor 40 %.

**Why it matters.** This is whole mod. If both gain same, patch running but factor coming out as 1 — most likely need absent, or contentment sat at plateau for both.

### 10. Below the floor, filling stops and nothing is lost

**Do.** Drive one animal's contentment below 25 %, by cold and hunger or debug action that sets need level. Note fullness. Wait a day. Note again. Then restore its keeping, wait a day more.

**Expect.** Fullness does not move while below floor, and above all **does not fall**. Tip says animal stopped producing. When contentment climbs back, filling resumes from where stopped, not from zero.

**Why it matters.** Bad week costs the week, not progress. Postfix only ever scales rising delta, incapable of removing anything; if fullness drops, no longer true.

### 11. Harvesting and laying still reset cleanly

**Do.** Milk full cow. Shear full sheep. Let hen lay.

**Expect.** Each resets to zero, starts again. Yield unchanged — mod scales clock, never amount.

### 12. The unfertilised hen still stalls

**Do.** Hen with no rooster, contentment high.

**Expect.** Egg progress behaves exactly as vanilla: stall is vanilla's, mod adds nothing. Hen that suddenly lays fertilised-only eggs, or whose progress creeps when should be held, means delta guard lost.

---

### 13. It survives a save, and a reload

**Do.** Note animal's contentment level and Feed line. Save. Quit to menu. Reload.

**Expect.** Both come back as were, fading memory of last meal included. Then change every mod setting, quit game entirely, relaunch: every setting as left.

### 14. It can be added to a running save, and taken out of one

**Out of scope (decision of 2026-09-24).** Save backward compatibility not handled, so scenario not played: doing so would be opportunistic. What stays is property code has by construction, below, which out-of-game suite checks; not promise verified in game.

**Do.** Load save made without mod. Play an hour.

**Expect.** Animals gain need at 50 % and walk from there. Nothing in save disturbed.

**Then.** Save, disable mod, load again.

**Expect.** Game warns about missing def, as for any removed mod, animals go back to vanilla rate. No error repeating every tick, no lost livestock.

**Why it matters.** Animal with no contentment need worth exactly vanilla rate, by construction not special case. That makes both halves safe, out-of-game suite checks same property on same code path.

---

### 15. Primary settings, defaults, boundaries and reset

**Preconditions.** Separate test profile with no existing Contented Livestock settings, Harmony enabled, no RIMMSQOL/customization tool, new colony using shared setup. Repeat on existing save. Keep player's normal settings/saves intact.

**Do.** Open Options -> Mod options -> Contented Livestock, scroll to every control. Check five slider defaults (25, 60, 40, 140, 100%) and all six enabled toggles. Move each slider to both ends: floor 0–50, plateau 30–90, minimum 0–100, maximum 100–200, speed 25–400%. Set floor 50 then try plateau 30. Set distinctive nondefault values, close/reopen, then quit/relaunch and reload. Open reset confirmation, cancel once, then confirm on second attempt.

**Expect.** Every control accessible. Plateau stays at least five percentage points above floor. Cancel preserves edits; confirm restores all eleven defaults. Both kinds of reopening preserve saved values. Settings global across test saves. No editable numeric text field present, so empty/invalid text entry inapplicable. No red errors or repeated exceptions in Player.log during any action.

### 16. Each setting has its effect when play resumes

**Preconditions.** Animals with nonzero feed, space, temperature, health, company contributions; note contentment and production progress before each experiment.

**Do.** Disable each factor independently, close settings, resume, wait one need interval; inspect tooltip and direction of contentment. Restore it, repeat. Repeat scenarios 9–10 with floor/plateau/minimum/maximum at distinctive legal values. Compare equal initial/target conditions with speed 25, 100, 400%.

**Expect.** Disabled factor contributes zero, disappears from tooltip, returns after restoration; pasture/company do not keep old contribution after closing. Rates follow selected floor/plateau and minimum/maximum. Speed changes convergence, not current level instantly, no overshoot. Current accumulated products retained. Repeat producers-only using scenario 3; must update without reloading.

### 17. Optional MainButtons shortcut and shared settings

**Preconditions.** First run without customization tool; then enable installed RimWorld 1.6 RIMMSQOL build, record its DLL version/hash. Use clean RIMMSQOL visibility configuration. Repeat full scenario in English and French.

**Do.** Check main bar before any customization. In RIMMSQOL, locate Main Buttons -> Contented Livestock (`Nelim_ContentedLivestockSettings`), enable Visible. Open it, change slider and toggle, close, inspect same settings via Options. Edit through Options, reopen via shortcut. Hide shortcut in RIMMSQOL; restart and reload. Reveal again, use from world view without map.

**Expect.** Initially neither visible nor greyed-out button. RIMMSQOL can find, reveal, hide definition. Both routes open same page, share values, reset, saving and application behavior from scenarios 15–16. RIMMSQOL's visibility choice survives restart without this mod overwriting it. Removing RIMMSQOL leaves primary settings usable. Logs stay clean. Test other customization tools only if claiming their compatibility, identify each tool/version separately.

### What to send back

### Language pass — run in both English and French

Open mod settings, check category, section headings, sliders and tooltips, all checkboxes, scope/application guidance, reset confirmation (including game-provided buttons). Run scenario 17 for shortcut label, tooltip, same settings UI. Inspect animal's contentment label, description, production-rate tooltip, halted state. Exercise all five nonzero factor lines, positive and negative percentages. Check for raw keys, unintended English fallback in French, broken parameters, accents, punctuation, clipping. Proper name "Contented Livestock" stays identical in both languages. Record game version, language, screens checked, failures in STATUS.md; until both passes performed, runtime translation validation unverified.

Retain session's `Player.log`, required screenshots/videos, and for scenario 9 two fullness figures a day apart. Those two numbers only quantitative result in list; everything else read off tip, must be visible in associated media.