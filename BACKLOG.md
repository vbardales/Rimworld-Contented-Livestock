# Backlog

Ideas for versions after 1.0.0. Nothing here built, tested or promised on Workshop page. 1.0.0 keeps
published promise: contentment changes speed of milk, wool and eggs, nothing else.

Each item say what it is, why it fits, what unknown, what it cost. Order not priority.

## 1. Contentment and reproduction (proposed 2026-09-25)

Idea from owner: well-kept animal breed more readily than badly kept one, like pandas in zoo, so
need would matter for animals that produce no milk, wool or eggs.

- **Why it fits.** Young are one more product of how animal kept. Pen too small lowers
  contentment, slows breeding, so herd caps itself at what pen feeds: pen rule finally
  has stake. Also gives `producersOnly = false` purpose, since husky's need would drive something.
- **Unknown.** Where game decides reproduction. Candidates: chance of successful mating, gestation
  speed, egg fertilisation. May be no single funnel like for gatherables. First step,
  before any code: read game's breeding code, list patch points.
- **Design question.** Slow down only, same rule as today (nothing lost, only speed), or
  block below floor like zoo panda. First gentler for players who breed for meat or leather.
- **Scope question.** All breeding animals, or producers plus breeders. Needs own setting, off by
  default, next to `producersOnly`.
- **Cost.** New patches, settings, translations, in-game scenarios, and rewrite of description
  paragraph saying mod does not touch reproduction.

## 2. Contentment and meat and leather quantity (proposed 2026-09-25)

Idea from owner: amount of meat and leather from butchered animal follows how content it
was.

- **Why it fits.** Same logic as milk and wool: way animal kept decides what it gives.
  Extends need to animals kept for slaughter, which today get nothing from it.
- **Unknown.** Patch stats (`MeatAmount`, `LeatherAmount`, as stat part, would also
  show in stat tooltip) or butchery products. Which level counts: level at death, or
  average over animal's life (need only holds current level, so average needs storing).
- **Design questions.** Bounds: milk rate goes 0.40 to 1.40, same range on meat could feel
  punishing or exploitable (fatten, then slaughter). Whether it applies to animals killed by raiders or
  hunters, or only butchery of live tame animal. Whether to leave floor so neglected animal still
  yields something.
- **Cost.** As item 1, and breaks same sentence of promise ("does not touch ... a
  single thing"): description and About text would change.

## 3. A contentment widget for RimHUD (proposed 2026-09-25)

Idea from owner: RimHUD shows pawn's needs and stats in own panel, and animal's contentment
should appear there as in game's Needs pane.

- **Why it fits.** Bar already exists in vanilla Needs pane; RimHUD players read animals there and may
  never open that pane. Presentation only: changes no rate, no promise of mod, so can ship
  in 1.0.x or 1.1.0 without touching description's "does not do" section.
- **Unknown, to read before any code.** Whether RimHUD lets another mod add widget or line, and how (API,
  def, or Harmony patch on its own drawing code); which RimHUD version on Workshop for 1.6 and
  its Workshop id; whether it already lists every need of pawn, animals included, in which case bar might
  appear with no work and item shrinks to check. First step: read RimHUD's source and own
  documentation, search Workshop for mod already adding widget to it (`scripts/SEARCHING.md`).
- **Design questions.** One bar, or bar plus rate ("112% of the usual rate")? Only for animals that carry
  the need. Follow RimHUD's own layout and theme options, not draw our own.
- **Cost.** Soft integration: optional `loadAfter`, never hard dependency, code must do nothing
  when RimHUD absent. Needs own Pickle pass with RimHUD staged (`wsl-deps.avec-rimhud.map`, one more
  request in `TESTING.md`), thanks entry for RimHUD's author in description and in
  `WORKSHOP_COMMENTS.md` (exercised integration must be thanked), and translated text in English and
  French if widget carries any.
## Notes for both

- Items 1 and 2 meant to arrive together as one version (1.1.0) with one rewritten promise, not as
  two separate breakings of it.
- Before starting either: decide how description's "what the mod deliberately does not do" section
  changes, and whether existing settings need migration (should not: new keys default to off).