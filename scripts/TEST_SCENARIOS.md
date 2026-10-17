# Functional scenarios, to be played in game

`Run-Functional-Tests.ps1` next door answers "do classes this mod leans on still do what it leans on them for". Cannot answer "does mod do what it says" — needs map, clock, animal. Scenarios below do, each with single thing to watch, single way of being wrong.

Mod never run in game. Until scenario 0 passes, nothing below worth playing.

**Setup for everything here.** Development mode on. Small colony, one cow, one sheep, one hen, one husky, pen with pasture. Time controls 3x for slow ones. Every scenario reads animal's inspect pane, contentment under food and rest, and mouseover tip on that bar, listing five contributions separately and current rate as percentage.

Clock note: contentment walks toward target at one full swing per day by default, so nothing below happens in seconds. Where scenario says *a day*, mean game day.

**Required visual evidence.** Manual scenario not passed by notes or `Player.log` alone. Save at least one full-resolution screenshot per stable state asserted. Record video when assertion depends on time, motion, transition, persistence across reload/restart, or before/after comparison one image cannot prove. Keep unedited media under `Tests/Manual/evidence/<date>/scenario-XX/` (on disk, ignored by git), name files so asserted state identifiable, record what was seen in that day's summary under `docs/runs/`. Review at full size, then minify what you keep as `docs/runs/README.md` describes. Final handoff must give captures or videos to user; written claim without media stays `unverified`.

---

## 0. It loads, and the patches take

**Do.** Start game with Harmony before this mod, no customization mod. Load any save. Let one game hour pass with milkable animal alive.

**Expect.** No red text at startup, none at first hour.

**Watch for in `Player.log`.** Three lines, each different failure:

- `FieldAccessException` naming `fullness` or `eggProgress` — access waiver missing from build. This exact fault shipped once, caught by test suite not play; see `Source/AccessChecks.cs`.
- `HarmonyException` or `Could not find method` at startup — patch target renamed by game update. Out-of-game suite catches this first.
- `Nelim_Contentment` reported as unresolved def — DefOf or def file did not load.

**If fails here, stop.** Everything below assumes patches live.

---

## 1. The need goes on the right animals, and only those

**Do.** Look at inspect pane of each: cow, hen, husky, colonist, wild animal on map.

**Expect.** Contentment on cow and hen. Not on colonist. Not on wild animal. Not on husky, because `producersOnly` on by default and husky produces nothing.

**Why it matters.** `minIntelligence` is floor with no ceiling, so nothing in def can say "animals and not colonists". If colonist has bar, postfix on `ShouldHaveNeed` not running, def taken at face value.

## 2. Taming and selling take effect at once

**Do.** Tame wild muffalo. Look at its pane without saving. Then sell animal to trader, look again before it leaves map.

**Expect.** Need appears on muffalo immediately, not after reload. Disappears from sold one.

**Why it matters.** Needs tracker only revisits list when asked. Without postfix on `SetFaction`, both changes wait for next load.

## 3. The producers-only switch

**Do.** In mod settings, turn `producersOnly` off, close window, resume play. Look at husky, including one previously in caravan after returning to map.

**Expect.** Husky now carries contentment. Turn setting back on, close window: it goes. Cow/hen keeps existing level through both changes.

---

## 4. Feed moves the target, and the kind of feed matters

**Do.** Three animals same species, kept identically. Let one graze living plant, feed one hay, feed one kibble. Wait a day. Read Feed line in each tip.

**Expect.** Grazing gives largest positive figure. Hay gives nothing either way. Kibble gives negative one.

**Then.** Stop feeding grazer anything for two days without letting it starve.

**Expect.** Its Feed line fades to nothing over those two days. Memory of meal not permanent.

**Why it matters.** Grazing detected by animal ingesting `Plant` itself, not by food type flags: hay and standing grass share same flag. If hay reads as grazing, detection broken.

## 5. Temperature is measured against the animal's own range

**Precondition.** Turn producers-only off, close settings so husky has contentment need too. Restore setting after scenario.

**Do.** Put husky and hen in same unheated room in winter. Read both Temperature lines. Then heat room to middle of hen's comfortable band.

**Expect.** Before heating, hen penalised, husky not, or much less. After, hen's line turns slightly positive.

**Why it matters.** Band is `ComfortableTemperatureRange()`, per animal. Single absolute threshold would punish both equally — wrong, would show here.

## 6. Health pulls down

**Do.** In dev mode, damage animal enough for pain and bleeding. Read Health line. Heal it, read again.

**Expect.** Negative figure that recovers. Never drops below -35 %, whatever damage.

## 7. Company

**Do.** Take one herd animal, muffalo for instance, put alone, far from any of its kind. Wait a day. Then bring two more of same species next to it.

**Expect.** Negative Company line while alone, gone once own kind within about twelve cells. Bond with colonist adds positive figure independently.

## 8. The pen is judged on its food balance

**Do.** Put four cows in pen pasture cannot sustain. Read pen marker's own figure, then Pasture line in cow's tip. Remove two cows, wait a day.

**Expect.** Pasture line follows pen marker's balance, negative when herd eats faster than grass grows, positive when not.

---

## 9. The rate really changes — the scenario the mod exists for

**Do.** Two cows, same species, same age. Keep one well: grazing, heated barn, company, healthy. Keep other badly but not below floor. Note fullness percentage of each in inspect pane, wait full day, note again.

**Expect.** Well-kept cow gained more than vanilla amount, neglected one less. At full contentment rate reads 140 %, at plateau 100 %, just above floor 40 %.

**Why it matters.** This is whole mod. If both gain same, patch running but factor coming out as 1 — most likely need absent, or contentment sat at plateau for both.

## 10. Below the floor, filling stops and nothing is lost

**Do.** Drive one animal's contentment below 25 %, by cold and hunger or debug action that sets need level. Note fullness. Wait a day. Note again. Then restore its keeping, wait a day more.

**Expect.** Fullness does not move while below floor, and above all **does not fall**. Tip says animal stopped producing. When contentment climbs back, filling resumes from where stopped, not from zero.

**Why it matters.** Bad week costs the week, not progress. Postfix only ever scales rising delta, incapable of removing anything; if fullness drops, no longer true.

## 11. Harvesting and laying still reset cleanly

**Do.** Milk full cow. Shear full sheep. Let hen lay.

**Expect.** Each resets to zero, starts again. Yield unchanged — mod scales clock, never amount.

## 12. The unfertilised hen still stalls

**Do.** Hen with no rooster, contentment high.

**Expect.** Egg progress behaves exactly as vanilla: stall is vanilla's, mod adds nothing. Hen that suddenly lays fertilised-only eggs, or whose progress creeps when should be held, means delta guard lost.

---

## 13. It survives a save, and a reload

**Do.** Note animal's contentment level and Feed line. Save. Quit to menu. Reload.

**Expect.** Both come back as were, fading memory of last meal included. Then change every mod setting, quit game entirely, relaunch: every setting as left.

## 14. It can be added to a running save, and taken out of one

**Out of scope (decision of 2026-09-24).** Save backward compatibility not handled, so scenario not played: doing so would be opportunistic. What stays is property code has by construction, below, which out-of-game suite checks; not promise verified in game.

**Do.** Load save made without mod. Play an hour.

**Expect.** Animals gain need at 50 % and walk from there. Nothing in save disturbed.

**Then.** Save, disable mod, load again.

**Expect.** Game warns about missing def, as for any removed mod, animals go back to vanilla rate. No error repeating every tick, no lost livestock.

**Why it matters.** Animal with no contentment need worth exactly vanilla rate, by construction not special case. That makes both halves safe, out-of-game suite checks same property on same code path.

---

## 15. Primary settings, defaults, boundaries and reset

**Preconditions.** Separate test profile with no existing Contented Livestock settings, Harmony enabled, no RIMMSQOL/customization tool, new colony using shared setup. Repeat on existing save. Keep player's normal settings/saves intact.

**Do.** Open Options -> Mod options -> Contented Livestock, scroll to every control. Check five slider defaults (25, 60, 40, 140, 100%) and all six enabled toggles. Move each slider to both ends: floor 0–50, plateau 30–90, minimum 0–100, maximum 100–200, speed 25–400%. Set floor 50 then try plateau 30. Set distinctive nondefault values, close/reopen, then quit/relaunch and reload. Open reset confirmation, cancel once, then confirm on second attempt.

**Expect.** Every control accessible. Plateau stays at least five percentage points above floor. Cancel preserves edits; confirm restores all eleven defaults. Both kinds of reopening preserve saved values. Settings global across test saves. No editable numeric text field present, so empty/invalid text entry inapplicable. No red errors or repeated exceptions in Player.log during any action.

## 16. Each setting has its effect when play resumes

**Preconditions.** Animals with nonzero feed, space, temperature, health, company contributions; note contentment and production progress before each experiment.

**Do.** Disable each factor independently, close settings, resume, wait one need interval; inspect tooltip and direction of contentment. Restore it, repeat. Repeat scenarios 9–10 with floor/plateau/minimum/maximum at distinctive legal values. Compare equal initial/target conditions with speed 25, 100, 400%.

**Expect.** Disabled factor contributes zero, disappears from tooltip, returns after restoration; pasture/company do not keep old contribution after closing. Rates follow selected floor/plateau and minimum/maximum. Speed changes convergence, not current level instantly, no overshoot. Current accumulated products retained. Repeat producers-only using scenario 3; must update without reloading.

## 17. Optional MainButtons shortcut and shared settings

**Preconditions.** First run without customization tool; then enable installed RimWorld 1.6 RIMMSQOL build, record its DLL version/hash. Use clean RIMMSQOL visibility configuration. Repeat full scenario in English and French.

**Do.** Check main bar before any customization. In RIMMSQOL, locate Main Buttons -> Contented Livestock (`Nelim_ContentedLivestockSettings`), enable Visible. Open it, change slider and toggle, close, inspect same settings via Options. Edit through Options, reopen via shortcut. Hide shortcut in RIMMSQOL; restart and reload. Reveal again, use from world view without map.

**Expect.** Initially neither visible nor greyed-out button. RIMMSQOL can find, reveal, hide definition. Both routes open same page, share values, reset, saving and application behavior from scenarios 15–16. RIMMSQOL's visibility choice survives restart without this mod overwriting it. Removing RIMMSQOL leaves primary settings usable. Logs stay clean. Test other customization tools only if claiming their compatibility, identify each tool/version separately.

## What to send back

### Language pass — run in both English and French

Open mod settings, check category, section headings, sliders and tooltips, all checkboxes, scope/application guidance, reset confirmation (including game-provided buttons). Run scenario 17 for shortcut label, tooltip, same settings UI. Inspect animal's contentment label, description, production-rate tooltip, halted state. Exercise all five nonzero factor lines, positive and negative percentages. Check for raw keys, unintended English fallback in French, broken parameters, accents, punctuation, clipping. Proper name "Contented Livestock" stays identical in both languages. Record game version, language, screens checked, failures in STATUS.md; until both passes performed, runtime translation validation unverified.

Retain session's `Player.log`, required screenshots/videos, and for scenario 9 two fullness figures a day apart. Those two numbers only quantitative result in list; everything else read off tip, must be visible in associated media.