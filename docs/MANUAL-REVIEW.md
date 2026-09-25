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
| 9 | The rate really changes | 5 captures, ran 2026-09-25, passed | all 5 opened, values read | your verdict |
| 3 | Producers-only switch | 5 captures, ran 2026-09-25, passed | all 5 opened | your verdict; the caravan variant has no step |
| 17 | RIMMSQOL shortcut | English: 6 of 6 asserted, 1 capture | opened | DLL hash, bare main bar, world view |
| 7 | Company | 3 captures, ran 2026-09-25, passed | all 3 opened | your verdict |
| 12 | Unfertilised hen | feature 21: ran and passed (`…-088f`), 2 captures read | 1 of 1 passed | nothing left for your eye |
| 11 | Harvest and laying reset | feature 20: cow and sheep ran and passed (`…-49a5`), the hen failed again on 2026-09-25 (old steps DLL), rerun `…-09ac` pending | 2 of 3 passed | waiting for your verdict on the cow and the sheep |
| 15 | Settings, boundaries, reset | feature 22: 4 scenarios, 8 captures, ran and passed (`…-67a2`) | 4 of 4 passed | waiting for your verdict; the Options route is not driven |
| 16 | Each setting's effect | feature 23: 7 scenarios, 12 captures, ran and passed (`…-0c3c`) | 7 of 7 passed | waiting for your verdict |
| 4 | Feed and its fading memory | feature 24: 2 scenarios, 9 captures, ran and passed (`…-398b`) | 2 of 2 passed | waiting for your verdict on the two bar pictures; the two days are simulated |
| 5 | Temperature per animal | feature 25 written (3 tip captures); first run `…-919e` failed on a test step (fixed), the rerun `…-69e3` ran the old steps DLL and failed the same way; rerun `…-0318` pending | not passed yet | media to review; a cold snap, not a room |
| 8 | Pen balance | feature 26 written (4 captures); first run `…-0294` failed on a test step (fixed), the rerun `…-d762` ran the old steps DLL and failed the same way; rerun `…-8821` pending | not passed yet | media to review; the riskiest premise |
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

Features 24 to 26 (scenarios 4, 5 and 8), the three heavy ones, were added last, also not run. What a person
should know before reading their captures:

- **4 feeds through the game's own `Thing.Ingested`** with a real rooted grass plant, a stack of hay and one of
  kibble, so the patch is exercised. **The waiting is simulated**: a game day of the level moving is 400 need
  intervals in a loop, and the two days of fading are done by moving the recorded time of the meal back in
  hours, since waiting would take over half an hour. It tests the formulas, not the clock, and the fading is
  a separate scenario from the levels for that reason.
- **5 is a cold snap outdoors, not an unheated room**, set six degrees below the hen's own cold limit and then
  ended to stand for heating. It says the hen is penalised more than the husky, and does not assume the husky
  is spared. Building a room with a roof and a heater in code was judged not worth it for the same physics.
- **8 builds the pen in code** (a closed fence, soil, a marker, four cows then two) and requires the pasture
  line to equal the mod's rule applied to the marker's own figures, and to be negative with four cows.
  **The mod did not follow the manual scenario's wording, and was fixed on 2026-09-25.** The first rule ran
  from -20% (nothing grown) to +20% (grown at least what is eaten), so a herd eating more than the pen grew,
  down to half of it, still read positive. The owner confirmed the wording was what was meant, so the rule is
  now zero at balance, negative below it and positive above, from -20% with nothing grown to +20% at twice
  what is eaten. Whether the game recognises the pen at all is the riskiest premise.

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

**Status: ran 2026-09-25, request `…-7485`, passed 1 of 1. Waiting for your verdict.**

**Media.** `2026-09-24/scenario-09/screenshots/`, five JPEGs, all opened at full size by Claude:

1. `scenario-09---full-contentment--140-percent-of-the-usual-rate`
2. `scenario-09---at-the-plateau--100-percent-of-the-usual-rate`
3. `scenario-09---just-above-the-floor--about-40-percent-of-the-usual-rate`
4. `scenario-09---the-well-kept-cow-after-one-game-hour`
5. `scenario-09---the-neglected-cow-after-the-same-hour`

**Claude checked.** In 1 to 3, one cow each at 100%, 60% and 26% contentment, the tip reads "at 140% of the usual
rate", "at 100%" and "at 42%". In 4 and 5, after the same game hour, the well-kept cow shows **5.9%** milk
fullness and the neglected one **1.9%**, from about 0.04% and 0.02%. One game hour of a cow's milk is 4.17% with
no mod (it fills in a day), so the well-kept cow gained about 140% of that and the neglected one about 45%.
That is a little above the 42% the tip promised because its contentment rises while the hour passes. The
run also asserts these in code, plus that a third cow at the plateau gains within 15% of the vanilla amount;
**no capture was taken of that third cow after the hour**, so that one is the code's word only.

**You check.**

1. In 1 to 3 the sentence "Filling with milk, wool or eggs at N% of the usual rate" is the one a player would
   want to read, and the three numbers are the ones the scenario expects (140, 100, about 40).
2. On the Contentment bar in the bottom left, the fill matches the tip's percentage (full, 60%, 26%), and
   the two small marks on the bar sit where the floor (25%) and the plateau (60%) should.
3. In 4 and 5, the well-kept cow's milk figure is clearly higher than the neglected cow's, and its bar is
   still full while the other's is short.
4. Nothing red, no error window, and no cow doing something odd in the background.

**Not covered.** The scenario says a full day. This is one hour, staged at chosen levels: the levels are set,
not earned. The rates and the milk are the real ones.
## 3. Producers-only switch

**Status: ran 2026-09-25, request `…-ee20` (first launch), passed 1 of 1. Waiting for your verdict.**

**Media.** `2026-09-24/scenarios-03-07/seq1/screenshots/`, five JPEGs, all opened at full size by Claude, in this
order: husky before the switch; husky once producers-only is off; cow at 72% while it is off; husky when it is on
again; cow after both switches.

**Claude checked.** The husky's pane shows only Food and Sleep at first, then a **Contentment bar, about half
full**, once producers-only is off, then only Food and Sleep again once it is back on. The cow's Contentment bar
is the same length in both cow captures, about **72%**. The run asserts the same, and that the husky has no need
before and after and has one in between.

**You check.**

1. On the husky, the bar is absent, present, absent, in the three husky captures.
2. On the cow, the bar is the same length before and after the two switches: the switch never touches an
   animal that already has the need.
3. Nothing red, and no error window.
4. **Ignore the small label beside the animal in captures 3 and 4.** It is the game's hover label, and it names
   the animal of the *previous* capture (the husky next to the cow, the cow next to the husky): the pointer sat
   still while the selection moved. It comes from the test setup, not from the mod.

**Not covered.** The caravan variant (a husky coming back from a caravan) has no step. The switch is set in code
and applied the way closing the settings window applies it; the check box itself was not clicked.
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

## 7. Company

**Status: ran 2026-09-25, request `…-ee20` (second launch), passed 1 of 1. Waiting for your verdict.**

**Media.** `2026-09-24/scenarios-03-07/seq2/screenshots/`, three JPEGs, all opened at full size by Claude: a lone
muffalo; the same one with two of its kind beside it; the same one bonded to a colonist, still with kin beside it.

**Claude checked.** The tip of the lone muffalo lists "Temperature: +5%" and **"Company: -10%"**. With two muffalos
beside it the Company line is **gone**. Bonded to the colonist Jet, with kin still beside it, it reads
**"Company: +10%"**. The run asserts the same three values (a penalty of 10, zero, a bonus of 10).

**You check.**

1. The three tips differ only in the Company line: penalty, nothing, bonus.
2. In captures 2 and 3 the other muffalos are visibly next to the selected one, within about twelve cells.
3. The wording "Company: -10%" and "Company: +10%" is understandable to a player.
4. Nothing red, and no error window. The small hover label beside the animal names the selected muffalo, which
   is correct here.

**Not covered, and worth knowing.** In all three tips the level stays at **50%** and the rate at **83%**: only the
offset changed. The level takes time to move, which is exactly what the manual scenario's "wait a day" is for;
this run reads the offset at once and does not wait. The bond was set in code, not earned by taming or training.
## 11. Harvest and laying reset cleanly

**Status: ran 2026-09-25, request `…-49a5`: cow and sheep passed (2 of 3); the hen failed on a defect of the
test step, not of the mod, and its rerun is pending (request `…-217d`). Waiting for your verdict on the cow and
the sheep only.**

**Media.** `2026-09-24/scenarios-11-12/seq1/`, two JPEGs, both opened at full size by Claude: the cow just after
being milked and the sheep just after being shorn, each with its tip and pane.

**Claude checked.** The cow's pane reads "Milk fullness: 0.01%" and the sheep's "Wool growth: 0%", both with the
contentment bar full (set to 100% before the gathering). The run gathered through the game's own method, once at
100% and once at 30% contentment, and asserted that the yield equals what the game says a full animal gives and
that the two yields are equal: the mod scales the clock, never the amount.

**You check.**

1. After the harvest the fullness is back at about zero, not at some fraction of what it was.
2. Nothing red, no error window, no stuck job text: the pane says "Wandering".

**Not covered, and worth knowing.** The amounts are read by the run and are not on the pictures. Gathering was
called for a colonist directly, not through the job a colonist would take, so the walk to the animal is not
tested. The hen half of the scenario failed because the step called `ProduceEgg`, which only makes the egg (the
laying job is what puts it on the map): the step now places it. The hen's captures will be added when it runs.

## 15. Primary settings, defaults, boundaries and reset

**Status: ran 2026-09-25, request `…-67a2`, passed 4 of 4. Waiting for your verdict.**

**Media.** `2026-09-24/scenario-15/`, eight JPEGs, all opened at full size by Claude, all of the mod's own settings
window over the test colony: the shipped defaults; every slider at its low end; every slider at its high end;
floor at 50 with the plateau asked at 30; eleven distinctive values; the same eleven after closing and reopening;
the reset confirmation; the defaults back after confirming.

**Claude checked.** Defaults read 25, 60, 40, 140 and 100 percent, six green ticks. Low end reads 0, 30, 0, 100
and 25. High end reads 50, 90, 100, 200 and 400, each slider at the right of its track. With the floor at 50 and
the plateau asked at 30, the plateau reads **55**, five points above the floor. The distinctive set (31, 71, 22,
163, 250 and six red crosses) reads the same after closing and reopening. The reset window asks "Reset every
Contented Livestock setting to its default?" with Go back and Confirm; Go back kept the values, Confirm brought
back the eleven defaults (last capture equals the first). The run also asserted that out-of-range values are
held (floor 0.9 gives 50, speed 10 gives 400, speed 0.01 gives 25), which no picture shows.

**You check.**

1. The wording of each line and of the two intro paragraphs reads well to a player, and nothing is cut off.
2. The slider ends make sense: is "Production stops below" capped at 50% and "Speed of change" at 400% what you
   want to offer?
3. **The reset confirmation window is large (about 640 by 460 px) with a single line of text and a lot of empty
   black.** Is that how you want it, or should it be smaller? Compare with another vanilla confirmation.
4. Red crosses and green ticks are easy to tell apart, and the first capture and the last look identical.

**Not covered, and worth knowing.** Sliders and ticks were set in code and the dialog drew them: nobody dragged a
slider. The Options, Mod options route is not driven (features 02 and the RIMMSQOL ones cover the shortcut). This
run is in English; the French labels of this window are checked by feature 02.

## 16. Each setting has its effect

**Status: ran 2026-09-25, request `…-0c3c`, passed 7 of 7. Waiting for your verdict. Image "feed input on"
validated by Virginie on 2026-09-25; the text of the other captures was read by Claude, so only the wording and
the "Too miserable" sentence are left for her eye.**

**Media.** `2026-09-24/scenario-16/`, twelve JPEGs, all opened at full size by Claude: for each of the five inputs
(feed, pasture and room, temperature, health, company) the animal's contentment tip with the input on and with it
off, then two for the rate curve: a floor of 30 with a cow at 29 percent, and a maximum of 160 with a cow at full.
The tip is a message box the test opens at the top left; it holds the game's own text for the need.

**Claude checked.** On: "Last fed on: +15%" (cow that ate corn), "Pasture and room: +5%" (husky), "Health: -12%"
(cow with a bleeding cut, shown red), "Company: -10%" (muffalo alone); "Temperature: +5%" is on every tip. Off: the
matching line is gone and the others stay. With a floor of 30 the cow at 29 percent reads "Too miserable to
produce. Nothing is accumulating, and nothing already gathered is lost." With a maximum of 160 the cow at 100
percent reads "Filling with milk, wool or eggs at 160% of the usual rate". The run also asserted the contribution
itself is zero when off and back when on again, the rate at 22, 60, 100 and 160 percent between the two ends
with these settings, and that the speed of change scales the distance travelled in 20 intervals (1.25, 5 and 20
points at 25, 100 and 400 percent) and never goes past its target.

**You check.**

1. In each pair the only difference is the one line; the level stays at 50 percent and the rate at 83 percent,
   because switching an input off changes the offset at once and the level moves only over time.
2. The wording of the lines: "Last fed on", "Pasture and room", "Company" and the sign of each.
3. The "Too miserable to produce" sentence: **reworded on 2026-09-25 at your request**. The capture shows the
   first wording ("Nothing is accumulating, and nothing already gathered is lost"); the shipped text is now
   "Too miserable to produce. Production freezes until conditions improve." (French: "La production est gelée
   tant que les conditions ne s'améliorent pas."). The capture predates the change.
4. Nothing red apart from the wounded cow itself, and no error window.

**Not covered, and worth knowing.** The tip is shown in a **message box** the test opens, not the game's hover
tooltip, so its size (large, mostly empty) is the box's and says nothing about the real tooltip. Four captures
(feed off, temperature off, health off, and the maximum at 160) show a small hover label with the animal's name: the
pointer rests still while the selection moves, a harness artefact. Nothing accumulated in the pane: milk fullness
reads 0.01 to 0.03 percent. The speed of change is measured in need intervals, not by waiting, so it does not
depend on the clock. Pasture and room was tested on a husky, with producers-only off; a cow in a real pen is
scenario 8.

## 4. Feed and its fading memory

**Status: ran 2026-09-25, request `…-398b`, passed 2 of 2. Waiting for your verdict on the two bar pictures;
the text of the others was read by Claude.**

**Media.** `2026-09-24/scenario-04/`, nine JPEGs, all opened at full size by Claude. Three cows just after eating
(grass, hay, kibble); the grazer's and the kibble cow's bars after a simulated game day; and one cow's tip just
after eating, twelve hours later, thirty-six hours later and forty-eight hours later.

**Claude checked (text read on the pictures).** Grass reads "Last fed on: +25%", hay shows **no** Feed line,
kibble reads "Last fed on: -15%". The fading meal reads +25%, +19% at 12 hours, +6% at 36 hours, and the line is
gone at 48 hours (the formula gives 25 x (1 - age / 2 days): 19 and 6). The run asserted the same signs and the
order of the three targets, and that after 400 need intervals (a game day) the grazer's level is above the hay
cow's, which is above the kibble cow's. In the two bar pictures the grazer's contentment bar is about three
quarters full and the kibble cow's about a third.

**You check.** Only the two bar pictures, by eye: after a day, does the grazer's bar against the kibble cow's read
as "one is well fed, one is not" at a glance, without the tip?

**Not covered, and worth knowing.** Eating went through the game's own `Thing.Ingested` (so the patch and the grass
test are exercised), but time is arranged: a game day is 400 need intervals in a loop, and the two days of fading
are made by moving the recorded time of the meal back, so the formula is tested, not the clock. The cows did not
graze by themselves. In the bar pictures the game is not paused and the tip is not open.

## 12. Unfertilised hen

**Status: ran 2026-09-25, request `…-088f`, passed 1 of 1. Read by Claude; nothing is left for your eye.**

**Media.** `2026-09-25/scenario-12/`, two JPEGs, opened at full size: the hen that has the need and the reference
hen whose need was taken away, both after one game hour from 10 percent.

**Claude checked.** The hen with the need reads "Egg progress: 16%", the reference "Egg progress: 14%"; the first
pane shows Food, Sleep and a Contentment bar, the second only Food and Sleep. The run asserted that the gain is 140
percent of the reference's give or take 15 points, and that the map holds no fertilised egg (no rooster): a hen
with no rooster fills and stops at its ceiling like vanilla, only faster. The reference capture shows a small hover
label with the animal's name: the pointer rests still, a harness artefact.

**Not covered.** The ceiling itself (the progress a hen with no rooster stops at) is not reached in one hour; the
scenario asserts the rate, and the vanilla stall is untouched by construction (only a rising delta is scaled).

## 5. Temperature, 8. Pen

No media yet. Each needs a new feature, so each is one small request. Notes on what is hard:

- **7.** Cheap: a herd animal alone, then two of its kind beside it, the Company line in the tip. The bond
  with a colonist needs a relation set in code.
- **12.** The assertion is numeric (egg progress against vanilla's rate); the media would be the hen's pane.
- **5.** Needs a way to set the temperature of a room in winter, which no step does yet.
- **8.** Needs a pen with a pasture built in code and the pen marker's own figure; the riskiest.

**14 is not on this sheet.** Adding the mod to a save, and removing it, is backward compatibility, which is
not handled or tested here (decision of 2026-09-24). One thing follows and needs an answer: `About.xml`
and `README.md` still say "Safe to add to an existing save. Safe to remove", and the Steam page created
for 0.1.0 carries the same sentence. That is a promise no game run backs. It is true by construction (an
animal with no contentment need is worth exactly the vanilla rate) and the out-of-game suite checks that
property, but it is not "safe" in the sense a player reads.
