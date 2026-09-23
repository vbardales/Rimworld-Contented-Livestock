# Functional scenarios, to be played in game

`Run-Functional-Tests.ps1` next door answers "do the classes this mod leans on still do what it
leans on them for". It cannot answer "does the mod do what it says", because that takes a map, a
clock and an animal. These are the scenarios that do, written so each one has a single thing to
watch and a single way of being wrong.

The mod has never been run in a game. Until scenario 0 passes, nothing below is worth playing.

**Setup for everything here.** Development mode on. A small colony, one cow, one sheep, one hen,
one husky, and a pen with a pasture. Time controls at 3x for the slow ones. Every scenario reads
the animal's inspect pane, where contentment sits under food and rest, and the mouseover tip on
that bar, which lists the five contributions separately and the current rate as a percentage.

A note on the clock: contentment walks toward its target at one full swing per day by default, so
nothing below happens in seconds. Where a scenario says *a day*, that is a game day.

**Required visual evidence.** A manual scenario is not passed by notes or `Player.log` alone.
Save at least one full-resolution screenshot for every stable state being asserted. Record a video
when the assertion depends on time, motion, a transition, persistence across reload/restart, or a
before/after comparison that one image cannot prove. Keep the unedited media under
`Tests/Manual/evidence/<date>/scenario-XX/` (on disk, ignored by git), name files so the asserted
state is identifiable, and record what was seen in that day's summary under `docs/runs/`. Review at
full size, then minify what you keep as `docs/runs/README.md` describes. The final handoff must provide the captures or videos to
the user; a written claim without its media remains `unverified`.

---

## 0. It loads, and the patches take

**Do.** Start the game with Harmony before this mod and without a customization mod.
Load any save. Let one game hour pass with a milkable
animal alive.

**Expect.** No red text at startup, and none at that first hour.

**Watch for in `Player.log`.** Three lines in particular, each meaning a different failure:

- `FieldAccessException` naming `fullness` or `eggProgress` — the access waiver is missing from
  the build. This exact fault shipped once and was caught by the test suite rather than by play;
  see `Source/AccessChecks.cs`.
- `HarmonyException` or `Could not find method` at startup — a patch target has been renamed by a
  game update. The out-of-game suite catches this one first.
- `Nelim_Contentment` reported as an unresolved def — the DefOf or the def file did not load.

**If it fails here, stop.** Everything below assumes the patches are live.

---

## 1. The need goes on the right animals, and only those

**Do.** Look at the inspect pane of each: the cow, the hen, the husky, a colonist, and a wild
animal on the map.

**Expect.** Contentment on the cow and the hen. Not on the colonist. Not on the wild animal. Not
on the husky, because `producersOnly` is on by default and a husky produces nothing.

**Why it matters.** `minIntelligence` is a floor with no ceiling, so nothing in the def can say
"animals and not colonists". If a colonist has the bar, the postfix on `ShouldHaveNeed` is not
running and the def is being taken at face value.

## 2. Taming and selling take effect at once

**Do.** Tame a wild muffalo. Look at its pane without saving. Then sell an animal to a trader and
look again before it leaves the map.

**Expect.** The need appears on the muffalo immediately, not after a reload. It disappears from
the sold one.

**Why it matters.** The needs tracker only revisits its list when asked. Without the postfix on
`SetFaction`, both changes would wait for the next load.

## 3. The producers-only switch

**Do.** In the mod settings, turn `producersOnly` off, close the window and resume play.
Look at the husky, including one previously in a caravan after returning to the map.

**Expect.** The husky now carries contentment. Turn the setting back on and close the
window: it goes. A cow/hen retains its existing level through both changes.

---

## 4. Feed moves the target, and the kind of feed matters

**Do.** Three animals of the same species, kept identically. Let one graze a living plant, feed
one hay, feed one kibble. Wait a day. Read the Feed line in each tip.

**Expect.** Grazing gives the largest positive figure. Hay gives nothing either way. Kibble gives
a negative one.

**Then.** Stop feeding the grazer anything for two days without letting it starve.

**Expect.** Its Feed line fades to nothing over those two days. The memory of a meal is not
permanent.

**Why it matters.** Grazing is detected by the animal ingesting the `Plant` itself, not by food
type flags: hay and standing grass share the same flag. If hay reads as grazing, that detection
has broken.

## 5. Temperature is measured against the animal's own range

**Precondition.** Turn producers-only off and close settings so the husky has a
contentment need too. Restore the setting after this scenario.

**Do.** Put a husky and a hen in the same unheated room in winter. Read both Temperature lines.
Then heat the room to the middle of the hen's comfortable band.

**Expect.** Before heating, the hen is penalised and the husky is not, or much less. After, the
hen's line turns slightly positive.

**Why it matters.** The band is `ComfortableTemperatureRange()`, so it is per animal. A single
absolute threshold would punish both equally, which would be wrong and would show here.

## 6. Health pulls down

**Do.** In dev mode, damage an animal enough to give it pain and bleeding. Read the Health line.
Heal it and read again.

**Expect.** A negative figure that recovers. It never drops below -35 %, whatever the damage.

## 7. Company

**Do.** Take one herd animal, a muffalo for instance, and put it alone, far from any other of its
kind. Wait a day. Then bring two more of the same species next to it.

**Expect.** A negative Company line while alone, gone once its own kind is within about twelve
cells. A bond with a colonist adds a positive figure independently.

## 8. The pen is judged on its food balance

**Do.** Put four cows in a pen the pasture cannot sustain. Read the pen marker's own figure, then
the Pasture line in a cow's tip. Remove two cows and wait a day.

**Expect.** The Pasture line follows the pen marker's balance, negative when the herd eats faster
than the grass grows and positive when it does not.

---

## 9. The rate really changes — the scenario the mod exists for

**Do.** Two cows, same species, same age. Keep one well: grazing, heated barn, company, healthy.
Keep the other badly but not below the floor. Note the fullness percentage of each in the inspect
pane, wait a full day, note it again.

**Expect.** The well-kept cow gained more than the vanilla amount, the neglected one less. At full
contentment the rate reads 140 %, at the plateau 100 %, just above the floor 40 %.

**Why it matters.** This is the whole mod. If both gain the same, the patch is running but the
factor is coming out as 1 — most likely the need is absent, or contentment sat at the plateau for
both.

## 10. Below the floor, filling stops and nothing is lost

**Do.** Drive one animal's contentment below 25 %, by cold and hunger or with the debug action
that sets a need level. Note its fullness. Wait a day. Note it again. Then restore its keeping and
wait a day more.

**Expect.** Fullness does not move while it is below the floor, and above all **does not fall**.
Its tip says the animal has stopped producing. When contentment climbs back, filling resumes from
where it stopped, not from zero.

**Why it matters.** A bad week costs the week, not the progress. The postfix only ever scales a
rising delta, so it is incapable of removing anything; if fullness drops, that is no longer true.

## 11. Harvesting and laying still reset cleanly

**Do.** Milk a full cow. Shear a full sheep. Let a hen lay.

**Expect.** Each resets to zero and starts again. The yield itself is unchanged — this mod scales
the clock, never the amount.

## 12. The unfertilised hen still stalls

**Do.** A hen with no rooster, contentment high.

**Expect.** Its egg progress behaves exactly as in vanilla: the stall is vanilla's, and the mod
adds nothing to it. A hen that suddenly lays fertilised-only eggs, or one whose progress creeps
when it should be held, means the delta guard has been lost.

---

## 13. It survives a save, and a reload

**Do.** Note an animal's contentment level and its Feed line. Save. Quit to the menu. Reload.

**Expect.** Both come back as they were, the fading memory of the last meal included. Then change
every mod setting, quit the game entirely, relaunch: every setting is as you left it.

## 14. It can be added to a running save, and taken out of one

**Do.** Load a save made without the mod. Play an hour.

**Expect.** Animals gain the need at 50 % and walk from there. Nothing in the save is disturbed.

**Then.** Save, disable the mod, load again.

**Expect.** The game warns about the missing def, as it does for any removed mod, and the animals
go back to the vanilla rate. No error repeating every tick, and no lost livestock.

**Why it matters.** An animal with no contentment need is worth exactly the vanilla rate, by
construction rather than by a special case. That is what makes both halves of this scenario safe,
and the out-of-game suite checks the same property on the same code path.

---

## 15. Primary settings, defaults, boundaries and reset

**Preconditions.** A separate test profile with no existing Contented Livestock settings,
Harmony enabled, no RIMMSQOL/customization tool, and a new colony using the shared setup.
Repeat on an existing save. Keep the player's normal settings/saves intact.

**Do.** Open Options -> Mod options -> Contented Livestock, scroll to every control.
Check the five slider defaults (25, 60, 40, 140, 100%) and all six enabled toggles.
Move each slider to both ends: floor 0–50, plateau 30–90, minimum 0–100,
maximum 100–200, speed 25–400%. Set floor 50 then try plateau 30.
Set distinctive nondefault values, close/reopen, then quit/relaunch and reload.
Open the reset confirmation, cancel once, then confirm on the second attempt.

**Expect.** Every control is accessible. Plateau stays at least five percentage
points above floor. Cancel preserves edits; confirm restores all eleven defaults.
Both kinds of reopening preserve saved values. Settings are global across test saves.
No editable numeric text field is present, so empty/invalid text entry is inapplicable.
No red errors or repeated exceptions in Player.log during any action.

## 16. Each setting has its effect when play resumes

**Preconditions.** Animals with nonzero feed, space, temperature, health and company
contributions; note their contentment and production progress before each experiment.

**Do.** Disable each factor independently, close settings, resume and wait one need
interval; inspect the tooltip and direction of contentment. Restore it and repeat.
Repeat scenarios 9–10 with floor/plateau/minimum/maximum at distinctive legal values.
Compare equal initial/target conditions with speed 25, 100 and 400%.

**Expect.** A disabled factor contributes zero, disappears from the tooltip and returns
after restoration; pasture/company do not keep their old contribution after closing.
Rates follow the selected floor/plateau and minimum/maximum. Speed changes convergence,
not the current level instantly, with no overshoot. Current accumulated products are
retained. Repeat producers-only using scenario 3; it must update without reloading.

## 17. Optional MainButtons shortcut and shared settings

**Preconditions.** First run without a customization tool; then enable the installed
RimWorld 1.6 RIMMSQOL build and record its DLL version/hash. Use a clean RIMMSQOL
visibility configuration. Repeat the full scenario in English and French.

**Do.** Check the main bar before any customization. In RIMMSQOL, locate Main Buttons
-> Contented Livestock (`Nelim_ContentedLivestockSettings`) and enable Visible.
Open it, change a slider and toggle, close, and inspect the same settings via Options.
Edit through Options and reopen via the shortcut. Hide the shortcut in RIMMSQOL;
restart and reload. Reveal it again and use it from the world view without a map.

**Expect.** Initially there is neither a visible nor greyed-out button. RIMMSQOL can
find, reveal and hide the definition. Both routes open the same page and share values,
reset, saving and the application behavior from scenarios 15–16. RIMMSQOL's visibility
choice survives restart without this mod overwriting it. Removing RIMMSQOL leaves
primary settings usable. Logs remain clean. Test other customization tools only if
claiming their compatibility, and identify each tool/version separately.

## What to send back

### Language pass — run in both English and French

Open the mod settings and check the category, section headings, sliders and their tooltips,
all checkboxes, scope/application guidance, and the reset confirmation (including its
game-provided buttons). Run scenario 17 for the shortcut label, tooltip and same settings UI.
Inspect an animal's contentment label, description, production-rate tooltip and halted state.
Exercise all five nonzero factor lines, including positive and negative percentages.
Check for raw keys, unintended English fallback in French, broken parameters, accents,
punctuation and clipping. The proper name "Contented Livestock" stays identical in both languages.
Record the game version, language, screens checked and any failures in STATUS.md;
until both passes have been performed, runtime translation validation is unverified.

Retain the `Player.log` of the session, the required screenshots/videos, and for scenario 9 the two
fullness figures a day apart. Those two numbers are the only quantitative result in the list;
everything else is read off the tip and must be visible in the associated media.
