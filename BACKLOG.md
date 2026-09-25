# Backlog

Ideas for versions after 1.0.0. Nothing here is built, tested or promised on the Workshop page. 1.0.0 keeps
its published promise: contentment changes the speed of milk, wool and eggs, and nothing else.

Each item says what it is, why it fits, what is unknown, and what it would cost. Order is not priority.

## 1. Contentment and reproduction (proposed 2026-09-25)

Idea from the owner: a well-kept animal breeds more readily than a badly kept one, as pandas in a zoo, so
the need would matter for animals that do not produce milk, wool or eggs.

- **Why it fits.** Young are one more product of how the animal is kept. A pen that is too small lowers
  contentment, which slows breeding, so the herd caps itself at what the pen feeds: the pen rule finally
  has a stake. It also gives `producersOnly = false` a purpose, since a husky's need would drive something.
- **Unknown.** Where the game decides reproduction. Candidates: the chance of a successful mating, the
  gestation speed, egg fertilisation. There may not be one funnel as there is for gatherables. First step,
  before any code: read the game's breeding code and list the patch points.
- **Design question.** Slow down only, under the same rule as today (nothing is lost, only speed), or
  block below the floor as a zoo panda would. The first is gentler for players who breed for meat or leather.
- **Scope question.** All breeding animals, or producers plus breeders. Needs its own setting, off by
  default, next to `producersOnly`.
- **Cost.** New patches, settings, translations, in-game scenarios, and a rewrite of the description
  paragraph that says the mod does not touch reproduction.

## 2. Contentment and meat and leather quantity (proposed 2026-09-25)

Idea from the owner: the amount of meat and leather taken from a butchered animal follows how content it
was.

- **Why it fits.** Same logic as milk and wool: the way the animal is kept decides what it gives.
  It extends the need to animals kept for slaughter, which today get nothing from it.
- **Unknown.** Whether to patch the stats (`MeatAmount`, `LeatherAmount`, as a stat part, which would also
  show in the stat tooltip) or the butchery products. Which level counts: the level at death, or an
  average over the animal's life (a need only holds the current level, so an average would need storing).
- **Design questions.** Bounds: the milk rate goes 0.40 to 1.40, the same range on meat could feel
  punishing or exploitable (fatten, then slaughter). Whether it applies to animals killed by raiders or
  hunters, or only to butchery of a live tame animal. Whether to leave a floor so a neglected animal still
  yields something.
- **Cost.** As for item 1, and it breaks the same sentence of the promise ("does not touch ... a
  single thing"): the description and the About text would change.

## 3. A contentment widget for RimHUD (proposed 2026-09-25)

Idea from the owner: RimHUD shows a pawn's needs and stats in its own panel, and the contentment of an animal
should appear there as it does in the game's Needs pane.

- **Why it fits.** The bar already exists in the vanilla Needs pane; RimHUD players read animals there and may
  never open that pane. It is presentation only: it changes no rate and no promise of the mod, so it can ship
  in a 1.0.x or 1.1.0 without touching the description's "does not do" section.
- **Unknown, to read before any code.** Whether RimHUD lets another mod add a widget or a line, and how (an
  API, a def, or a Harmony patch on its own drawing code); which version of RimHUD is on the Workshop for 1.6 and
  its Workshop id; whether it already lists every need of a pawn, animals included, in which case the bar might
  appear with no work at all and the item shrinks to a check. First step: read RimHUD's source and its own
  documentation, and search the Workshop for a mod that already adds a widget to it (`scripts/SEARCHING.md`).
- **Design questions.** One bar, or the bar plus the rate ("112% of the usual rate")? Only for animals that carry
  the need. Follow RimHUD's own layout and theme options rather than drawing our own.
- **Cost.** A soft integration: an optional `loadAfter`, never a hard dependency, and code that must do nothing
  when RimHUD is absent. It needs its own Pickle pass with RimHUD staged (a `wsl-deps.avec-rimhud.map`, one more
  request in `TESTING.md`), a thanks entry for RimHUD's author in the description and in
  `WORKSHOP_COMMENTS.md` (an integration that is exercised must be thanked), and translated text in English and
  French if the widget carries any.
## Notes for both

- Items 1 and 2 are meant to arrive together as one version (1.1.0) with one rewritten promise, not as
  two separate breakings of it.
- Before starting either: decide how the description's "what the mod deliberately does not do" section
  changes, and whether existing settings need a migration (they should not: new keys default to off).
