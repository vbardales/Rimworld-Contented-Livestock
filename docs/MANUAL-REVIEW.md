# Manual review sheet

The 12 scenarios of `_tools/FUNCTIONAL-SCENARIOS.md` that no one has played by hand (the 13th, number 14,
is out of scope: backward compatibility of saves is not handled). Method, agreed
2026-09-24: **Claude produces the media (a capture or a film) with Pickle, and says what a person must
look at that Claude cannot judge; the person watches and gives a verdict per point.** Nothing here is
certified until that verdict is written in `STATUS.md`. A scenario stays `unverified` until then.

## What Claude cannot judge, and what it can

Claude reads numbers and words in a full-size capture, and asserts values in code. It cannot judge how
a film *looks* over time (smoothness, a flicker, a window that pops up for one frame, the cow doing
something odd), how a sentence *reads* to a player, or whether a layout looks wrong rather than merely
being inside its bounds. A film is viewed by Claude only as a contact sheet, where the small text of the
inspect pane is unreadable: **a figure in a film is never Claude's evidence; the full-size capture next
to it is.**

Every sheet below has the same four lines: *media*, *Claude checked*, *you check*, *still to produce*.
Media live on disk, ignored by git, under `Tests/Pickle/evidence/`; the paths are relative to it.

---

## Status of the 12

| # | Scenario | Media now | Claude checked | Still to produce |
| --- | --- | --- | --- | --- |
| 10 | Below the floor, nothing is lost | film + 3 captures | all 3 captures opened, values read | nothing |
| 9 | The rate really changes | feature 19 written (3 tips, 2 after one hour); request `…-7485` pending | not run | media to review once it has run |
| 3 | Producers-only switch | feature 17 written (6 captures); request `…-ee20` pending | not run | media to review; the caravan variant has no step |
| 17 | RIMMSQOL shortcut | English: 6 of 6 asserted, 1 capture | opened | DLL hash, bare main bar, world view |
| 7 | Company | feature 18 written (3 tips); request `…-ee20` pending | not run | media to review |
| 12 | Unfertilised hen | feature 21 written (2 captures); request `…-49a5` pending | not run | media to review |
| 11 | Harvest and laying reset | feature 20 written (3 captures); request `…-49a5` pending | not run | media to review |
| 15 | Settings, boundaries, reset | feature 22 written (4 scenarios, about 8 captures); request pending | not run | media to review; the Options route is not driven |
| 16 | Each setting's effect | feature 23 written (7 scenarios, 12 tip captures); request pending | not run | media to review |
| 4 | Feed and its fading memory | none | - | a new feature, a game-day wait |
| 5 | Temperature per animal | none | - | a new step to set the temperature |
| 8 | Pen balance | none | - | a new feature, a pen to build |
| 14 | Add to and remove from a save | - | - | **out of scope**: no backward compatibility is handled or tested |

Order proposed: the cheap ones first (10, 9, 3, 17), then 7, 12, 11, then 15, 16, then 4, 5, 8.
Small requests, one scenario or a pair each.

**2026-09-24.** Features 17 to 21 were written for scenarios 3, 7, 9, 11 and 12 and submitted in three
requests; none has run. What each asserts, and what stays out:

- **12 does not guess what vanilla does** to a hen with no rooster. It runs the same hen twice, one with the
  need taken away so the mod's factor is exactly 1, and requires the other to gain 140% of what it gains,
  or nothing if vanilla holds it. A chicken lays every day, so an hour is about 4% of egg progress.
- **11 calls the game's own gather and lay methods**, not the colonist's job: it proves the reset and the size
  of the yield (equal at 100% and at 30% contentment, retried when the game wastes a yield), not the walk.
- **7 forces the company cache to refresh** instead of waiting a day; the day in the manual scenario is for
  the level to move, not for the offset.
- **9 checks gains against the vanilla amount with room**, never for an exact ratio, because contentment
  drifts during the hour.
- No film for any of them: each asserts stable states, so captures are the evidence.

Features 22 and 23 (scenarios 15 and 16) were added the same day, also not run:

- **15 sets the sliders and check boxes in code**, to the value the widget would give, and lets the real dialog
  draw them: Pickle has no step that names a slider. What is really clicked is the reset button and its two
  confirmation buttons, by their English label, since this runs in English. Those labels ("Reset to defaults",
  "Confirm", "Go back") and the step `I click button {string}` are unverified until it runs. Closing the
  window is the real close. Not covered: the route through the Options screen, and scrolling on a screen
  shorter than 1080 lines. Quit and relaunch is features 09 and 10.
- **16 measures the speed over the need's own intervals**, not over a wait, so the distance is exact: at speed
  25, 100 and 400% over 20 intervals, 1.25, 5 and 20 points. Each input is switched off through the setting
  and its writing, read as a contribution and as a tip line, and switched back on. The pasture case uses a
  husky, because a cow is judged on a pen and reads zero without one; that choice is a guess about the game
  and the first run will confirm or correct it.

---

## 10. Below the floor, filling stops and nothing is lost

**Media.** `2026-09-24/runtime-film/screenshots/film/pickletools--scenario-10-halt-and-resume/film.webm`
(52 s, 960 x 540) and three captures beside it, in `screenshots/`:
`scenario-10---milk-progress-before-halted-hour.jpg`,
`scenario-10---milk-progress-unchanged-after-halted-hour.jpg`,
`scenario-10---milk-progress-resumes-from-prior-amount.jpg`.

**Claude checked.** Read in the three captures at full size: milk fullness **3.3%** before the halted hour
(Contentment 10%), **3.3%** after it (Contentment 14%, tip reads "Too miserable to produce. Nothing is
accumulating, and nothing already gathered is lost."), **9.1%** after restoration (bar high). The scenario
asserts unchanged-below-floor and resumes-above-it, and passed 1 of 1.

**You check.**

1. In the film, the cow moves and the camera stays on it for the whole 52 s, with no error window or red
   text popping up at any moment.
2. The Contentment bar in the bottom-left pane starts **short**, stays short for the halted hour, then
   **fills to the right** at the end. It never goes backwards during the hour below the floor.
3. In the second capture, the pane says "Milk fullness" and the tip says the animal has stopped producing:
   the wording is clear to someone who has not read the code.
4. In the third capture the milk figure is higher than the first two, not zero: filling resumed from where
   it stopped.

**Still to produce.** Nothing.

## 9. The rate really changes

**Media.** `2026-09-23/runtime-evidence-fix/screenshots/scenario-09---full-contentment-reaches-maximum-rate.jpg`
(not yet opened by Claude); `2026-09-24/publication-shots/screenshots/publication-2...jpg` and `-3...jpg`, a
well-kept and a badly kept cow after the same two game hours (opened).

**Claude checked.** In the pair: milk fullness 11% against 4.7%, each pane with its own bar. In code: the
production factors are 140% and 49%. The gain ratio is 2.3, not 2.9, because contentment drifts during the
wait.

**You check.** The pair reads as "well kept gained clearly more". The maximum-rate capture's tip says
**140%** of the usual rate.

**Still to produce.** One cow, three tips in a row at contentment **100%, 60% (the plateau) and just above
the floor**: the scenario expects 140%, 100% and about 40%. One feature, three captures.

## 3. Producers-only switch

**Media.** `runtime-evidence-fix/screenshots/scenario-03---husky-has-contentment-when-producers-only-is-off.jpg`
and `...-loses-contentment-when-producers-only-is-on.jpg` (not yet opened by Claude).

**You check.** In the first, the husky's pane has a Contentment bar; in the second it has none. The
wording of the settings toggle matches what it does.

**Still to produce.** A short film of the toggle itself (open settings, untick, close, the bar appears on the
husky, tick, close, it goes), and the level of a cow captured before and after to show it is kept. The
caravan variant ("a husky returning from a caravan") has no Pickle step and stays a manual play or a
documented gap.

## 17. RIMMSQOL shortcut

**Media.** English: `2026-09-24/avec-rimmsqol/seq1/screenshots/...opened-through-rimmsqol.jpg` (opened: the
ordinary settings dialog, eleven controls).

**Claude checked.** 6 of 6 scenarios passed: the shortcut is hidden by default, RIMMSQOL can reveal, open,
hide and forget it, and the choice survives a process restart.

**You check.** Nothing that the assertions do not already cover, except that no button is visible **or
greyed out** on the main bar before RIMMSQOL reveals it. That is asserted, but a picture of the bar is the
better evidence and has not been taken.

**Still to produce.** The RIMMSQOL DLL version and hash, a capture of the bare main bar, and "use it from
the world view without a map". **No French pass:** the shortcut's label is the same in both languages
("Contented Livestock"); the one string that differs is its description, the tooltip ("Open Contented
Livestock settings." / "Ouvrir les réglages de Contented Livestock."), which belongs to the translation
check and can be asserted from the def without RIMMSQOL. RIMMSQOL's own screens are in its language, not
this mod's.

## 7. Company, 12. Unfertilised hen, 11. Harvest, 15. Settings, 16. Effects, 4. Feed, 5. Temperature, 8. Pen

No media yet. Each needs a new feature, so each is one small request. Notes on what is hard:

- **7.** Cheap: a herd animal alone, then two of its kind beside it, the Company line in the tip. The bond
  with a colonist needs a relation set in code.
- **12.** The assertion is numeric (egg progress against vanilla's rate); the media would be the hen's pane.
- **11.** Harvest by calling the game's own "gathered" methods, not by a colonist's job. That proves the
  reset and the unchanged yield, not the job itself.
- **15, 16.** Settings values are set in code; a capture per slider end and per disabled factor. Cheap but
  numerous.
- **4.** Needs a game day (60 000 ticks) and real grazing by the animal; a film sampled every 1 000 ticks.
- **5.** Needs a way to set the temperature of a room in winter, which no step does yet.
- **8.** Needs a pen with a pasture built in code and the pen marker's own figure; the riskiest.

**14 is not on this sheet.** Adding the mod to a save, and removing it, is backward compatibility, which is
not handled or tested here (decision of 2026-09-24). One thing follows and needs an answer: `About.xml`
and `README.md` still say "Safe to add to an existing save. Safe to remove", and the Steam page created
for 0.1.0 carries the same sentence. That is a promise no game run backs. It is true by construction (an
animal with no contentment need is worth exactly the vanilla rate) and the out-of-game suite checks that
property, but it is not "safe" in the sense a player reads.
