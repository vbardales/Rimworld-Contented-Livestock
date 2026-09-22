# Manual visual evidence — 2026-09-22

All game launches use the shared `scripts/Run-PickleWsl.ps1` WSL/Xvfb runner. The first
animal-baseline run was rejected during review because it selected each pawn without opening
the Needs tab. The preserved `animal-baseline/` evidence comes from the corrected rerun at
revision `d5a29b1`; its fresh report records 4 passed, 0 failed and `exitReason: passed`.

## Animal baseline review

- Scenario 1 component: the cow is selected and its Needs tab visibly contains Contentment at
  about 50%. Screenshot: `manual--scenario-01---producing-cow-has-contentment--step0.png`.
- Scenario 2 component: the two screenshots visibly show Contentment present after joining the
  player faction and absent after leaving it. The 9.049-second WebM shows the transition.
- Scenario 3 component: the two screenshots visibly show Contentment present with producers-only
  disabled and absent after it is restored. The 7.829-second WebM shows the transition.
- Scenario 9 component: the selected cow visibly has a full Contentment bar; the in-game assertion
  records the corresponding 140% production factor.
- Scenario 10 component: the selected cow visibly has Contentment below the floor; the in-game
  assertion records a 0% production factor.

The two `*-contact-sheet.png` files were derived locally from the unchanged WebMs solely to review
their timelines. Both films include Pickle's fixture-loading frames before reaching the relevant
map states. The original full-resolution PNGs and original WebMs are retained for delivery.

These are evidence components, not completion of manual scenarios 2, 3, 9 or 10: the wider trader,
caravan, elapsed-day, fullness and recovery requirements remain unverified. Scenario 1 is completed
by the dedicated five-subject pass below.

## Scenario 0 first game hour

The `scenario-00-first-hour/` report records 1 passed, 0 failed and `exitReason: passed` at
revision `7565df3`. A live milkable cow was recorded at 0.1% milk fullness, the game advanced
2,500 live ticks at superfast speed, and the in-game assertion observed 3.3% afterward. The
preserved Player log contains no `FieldAccessException`, `HarmonyException`, missing-method or
unresolved `Nelim_Contentment` signature.

Both full-resolution before/after screenshots and the original 31.385-second WebM were reviewed.
The before still has a black upper render-target region, but its lower game area visibly preserves
the selected cow's Needs pane and initial 0.1% fullness. The after still visibly shows 3.3%; the
six-frame `contact-sheet.png` review derivative shows uninterrupted fixture load, map entry and
live-hour progression. Together the assertions and reviewed media complete documented scenario 0.

## Scenario 1 eligibility

The `scenario-01-eligibility/` report records 1 passed, 0 failed and `exitReason: passed` at
revision `5533d99`. Live assertions found Contentment on a colony cow and hen, and found it absent
from a colony husky under the default producers-only setting, an adult colonist and a wild squirrel.
The preserved Player log contains none of the target patch/def failure signatures.

All five full-resolution screenshots were reviewed. The cow and hen Needs panes visibly contain
Contentment; the husky pane omits it, the colonist shows the ordinary human need set without it,
and the wild squirrel has no Needs tab or Contentment display. These stable captures and matching
in-game assertions complete documented scenario 1.

## Scenario 2 faction transitions

The `scenario-02-faction-transitions/` report records 1 passed, 0 failed and `exitReason: passed`
at revision `e679f26`. Live assertions found no Contentment on a wild muffalo, found the need
immediately after assigning it to the player faction, and found it removed immediately after
transferring the pawn to a visible neutral humanlike faction acting as its trader owner.

All three full-resolution screenshots and the original 9.552-second WebM were reviewed. The wild
and trader-owned panes omit Contentment; the colony-owned pane visibly contains it. The first still
has a black upper render-target region, but the selected pawn and its complete lower-left pane are
unobscured. `contact-sheet.png` is the review derivative. This validates both live `SetFaction`
transitions, while an actual trade-dialog sale remains unverified and scenario 2 therefore remains
partial.

## Scenario 6 health

The `scenario-06-health/` report records 1 passed, 0 failed and `exitReason: passed` at revision
`733531e`. The live test inflicted a cut that asserted both pain and bleeding, then asserted the
Health contribution was negative without exceeding the -35% floor. After removing every injury,
the same live contribution was asserted at zero. The preserved log contains none of the target
patch/def failure signatures.

Both full-resolution screenshots and the original 16.251-second WebM were reviewed. The injured
tip visibly shows `Health: -5%`; the healed tip omits the zero-valued Health line, while the cow's
pane visibly returns to `Healthy`. The injured still has a black upper render-target region, but
the complete live tip and selected animal pane remain unobscured. The denser `contact-sheet.png`
review derivative shows fixture loading, map arrival and the injured animal transition. These
assertions and media complete documented scenario 6.

## Scenario 10 first attempt and correction pending

`scenario-10-halt-resume/attempt-01/` preserves a complete failed 1/1 report and Player log
from revision `378c20d`. Milk fullness moved from 0.033214 to 0.033239, a one-tick increment.
The test recorded fullness before setting Contentment to 10% and taking the first capture, so
the baseline included setup time before the rate was asserted at zero. The corrected feature
records fullness after that setup and awaits another game run. This failure does not validate
scenario 10 or establish a production defect.

The first full-resolution screenshot, automatic failure screenshot and original 57.728-second
WebM were reviewed. The first capture visibly shows 10% Contentment, stopped production and
3.3% fullness; the failure frame shows 3.3% a game hour later. The film's six-frame
`contact-sheet.png` is a review derivative. A shared report image with a different scenario-10
name was excluded because it was not produced by this attempt.

## Scenario 13 save/reload component

The `scenario-13-save-reload/` report records 1 passed, 0 failed and `exitReason: passed` at
revision `70f2cf3`. Before saving, the live cow was asserted at 73% Contentment with a -15% Kibble
feed offset. After Pickle's real save/reload step, the pawn was reacquired by name and both values
were asserted unchanged. The 19.612-second original WebM includes the fixture load, map, save/load
transition and return to the map; `contact-sheet.png` is its review derivative.

The two full-resolution screenshots visibly retain the selected cow and its 73% Contentment bar
before and after reload. Their upper area is black because the film recorder and still capture share
the render target around this save/reload transition; the asserted subject in the lower-left Needs
pane remains unobscured. This covers the animal-level and last-feed-memory half of scenario 13;
the following two-process chain covers its settings half.

## Scenario 13 settings restart completion

The two-process `scenario-13-settings-restart/` chain passed 1/1 in each process at revision
`e99ce56`. The first process wrote distinctive values for all five sliders and all six toggles;
the second process asserted all eleven values after startup, then the sandbox restored the prior
test-profile settings file. Both full-resolution captures were reviewed: they visibly match at
11%, 72%, 55%, 165% and 235%, with all six toggles disabled, without clipping or raw keys.

Together with the real save/reload evidence above, this completes documented scenario 13: animal
Contentment and last-feed memory survive save/reload, and every global setting survives a complete
process restart. The original reports, Player logs and both screenshots are preserved in the two
numbered subdirectories.
