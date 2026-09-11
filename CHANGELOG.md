# Changelog

## 1.0.0 — unreleased

First version. Not yet tested in a running game.

### Added

- **Contentment** (`Nelim_Contentment`), a `NeedDef` carried by colony animals that produce milk,
  wool or eggs. Built from five signed offsets around a neutral 0.5 — feed, pasture or room,
  temperature, health, company — and moving toward that target at one full swing per day.
- Contentment scales the rate at which `CompHasGatherableBodyResource` and `CompEggLayer` fill:
  nothing below 25 %, 40 % → 100 % of the vanilla rate up to 60 %, 100 % → 140 % above it.
  Accumulated progress is never taken away.
- Mod settings for every threshold and rate, the speed of change, and an on/off switch for each of
  the five inputs. `producersOnly` decides whether pets and pack animals carry the need at all.
- English and French, keyed strings and the def's own label and description.

### How it hooks in

- Postfix on `Pawn_NeedsTracker.ShouldHaveNeed`, because `NeedDef.minIntelligence` is a floor and
  there is no ceiling: nothing in a def can say "animals and not colonists".
- Postfix on `Pawn.SetFaction`, so taming and selling take effect immediately rather than at the
  next load.
- Prefix/postfix pair on `CompHasGatherableBodyResource.CompTick` and on `CompEggLayer.CompTick`,
  scaling the rising delta of `fullness` and `eggProgress`. `CompTick` rather than
  `ResourceAmount` because the latter is overridden by every subclass and the former by none, so
  one patch covers wool as well as milk, and modded products as well as vanilla ones.
- Postfix on `Thing.Ingested`, the one non-virtual funnel every meal passes through, grazing
  included.

### Known gaps

- No Preview.png or ModIcon.png yet.
- Not run in game. The patches resolve against 1.6.4871 rev590 by reflection, and the defs pass
  `Check-XmlFields`, `Check-DefRefs` and `Check-DefInjected`, but no save has been loaded with it.
