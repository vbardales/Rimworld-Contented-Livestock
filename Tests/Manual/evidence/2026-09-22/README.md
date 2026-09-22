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

These are evidence components, not completion of manual scenarios 1, 2, 3, 9 or 10: the wider
multi-animal, trader, caravan, elapsed-day, fullness and recovery requirements remain unverified.
