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
| 9 | The rate really changes | 1 capture at maximum, the 2 pictures of the publication pair | pair opened | tips at three levels |
| 3 | Producers-only switch | 2 captures | not opened | toggle film, cow level kept |
| 17 | RIMMSQOL shortcut | English: 6 of 6 asserted, 1 capture | opened | DLL hash, bare main bar, world view |
| 7 | Company | none (a "Company -10%" line is visible in scenario 10's tip) | that line only | a new feature |
| 12 | Unfertilised hen | none | - | a new feature |
| 11 | Harvest and laying reset | none | - | a new feature |
| 15 | Settings, boundaries, reset | 1 settings capture | opened | slider extremes, reset dialog |
| 16 | Each setting's effect | none | - | a new feature |
| 4 | Feed and its fading memory | none | - | a new feature, a game-day wait |
| 5 | Temperature per animal | none | - | a new step to set the temperature |
| 8 | Pen balance | none | - | a new feature, a pen to build |
| 14 | Add to and remove from a save | - | - | **out of scope**: no backward compatibility is handled or tested |

Order proposed: the cheap ones first (10, 9, 3, 17), then 7, 12, 11, then 15, 16, then 4, 5, 8.
Small requests, one scenario or a pair each.

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
