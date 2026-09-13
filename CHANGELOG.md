# Changelog

## 1.0.0 — unreleased

First version. Not yet tested in a running game.

### Settings and dependency corrections — 2026-09-13

- Add an optional MainButtons shortcut, hidden through the native visibility field,
  opening the same standard mod settings dialog. Add its English/French text.
- Declare Harmony as a required runtime dependency and load it first. Resolve the
  installed Harmony runtime in the tests instead of silently using the NuGet cache.
- Normalize loaded settings to the UI limits, including crossed thresholds and
  nonfinite numbers. Explain global scope, persistence and application timing.
- Refresh animal needs when settings close, so producers-only changes apply to
  existing animals. Refresh pasture/company caches and suppress disabled factors
  in both the target calculation and tooltip.
- Exercise actual production curves, input combinations, adjustment speed, scalar
  Scribe persistence, older settings and shortcut/dependency contracts. In-game
  language, window, visibility and save regressions remain pending.

### Translation audit — 2026-09-13

- Make the settings category translatable while preserving the mod's proper name in English
  and French. Move each factor tooltip's punctuation and value placeholder into its translation.
- Verify all 35 owned keys in English and French and the need's label and description.
  Rebuild the shipped DLL; all 21 functional tests pass. In-game language checks remain pending.

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
- `About/Preview.png`, a lit shelter at night: fed pasture on the left, a cow and her calf on
  straw inside the heater's pool of light, and the pail, the eggs and the fleece on the right.
  Engraved with the mod name and its summary line by `_tools/preview.html`, rendered at final
  size so the glyphs are never resampled; the full-resolution render stays in `Art/`.
- `About/ModIcon.png`, the repository mascot among the animals she keeps, in a pen. Cropped to the
  drawing's own bounding box before being reduced, so it holds as much of the 32 pixels the mod
  list gives it as possible.

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

### Fixed

- Both production patches threw `FieldAccessException` at the first tick of every animal, leaving
  the whole scaling half of the mod dead while everything else looked healthy. `fullness` is
  protected and `eggProgress` private in the real assembly; the reference assembly ships them
  public, so the source compiled clean, and the waiver that makes the access legal at runtime was
  never emitted because this project switches off the generated AssemblyInfo it rides on. Fixed by
  declaring it outright in `Source/AccessChecks.cs`.

### Testing

- `_tools/Run-Functional-Tests.ps1`, seventeen tests in ten seconds with no game launched, asking
  whether the vanilla members this mod patches still behave as it assumes. It is what found the
  bug above, and a widening of it later turned up a third non-public member on the same footing,
  `Pawn_NeedsTracker.pawn`, read by the postfix that grants the need at all. Twelve of the
  seventeen have been seen to fail under a deliberate fault; the file says which five have not,
  and why they cannot be.
- `_tools/FUNCTIONAL-SCENARIOS.md`, fifteen scenarios to play in a game, with what to watch and
  what a failure looks like in `Player.log`.

### Known gaps

- Not run in game. The patches resolve against 1.6.4871 rev590 by reflection, and the defs pass
  `Check-XmlFields`, `Check-DefRefs` and `Check-DefInjected`, but no save has been loaded with it.
