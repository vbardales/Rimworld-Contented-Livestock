# Changelog

## Unreleased

- **Fixed: the pen rule.** A roped animal in a pen is judged on the pen marker's own figure, and the mod was
  meant to read negative when the herd eats faster than the pasture grows and positive when it does not.
  It ran a straight line from -20% with nothing grown to +20% at balance, so a herd that ate more than the
  pen grew, down to half of it, still read positive. It is now zero at balance, negative below it and
  positive above it, from -20% with nothing grown to +20% at twice what is eaten. Found while writing the
  in-game scenario for it. Only pen-managed animals with a pen are affected; a room and a lone animal are not.
- **Reworded: the tip of an animal below the floor**, in English and French. It read "Nothing is accumulating,
  and nothing already gathered is lost", which did not say that production stops until conditions improve. It now
  says "Production freezes until conditions improve" (owner's wording, 2026-09-25). "Nothing already accumulated
  is ever lost" stays in the general text of the tip.
- `About/About.xml`: removed the sentence saying the mod is safe to add to an existing save and safe to
  remove. Backward compatibility of saves is not handled or tested, so nothing backs it. The design
  property behind it is unchanged: an animal with no contentment need is worth exactly the vanilla rate.

## [0.1.0] — prepublished 2026-09-23

First version. Uploaded to the Steam Workshop as item `3806136625`, private, which is how Steam
creates every item: RimWorld never calls `SetItemVisibility`, so going public is a manual step.

- `About/PublishedFileId.txt` created and committed. It is what ties this repository to that item:
  lose it and the next upload creates a second one rather than updating this.

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

- `_tools/Run-Functional-Tests.ps1`, thirty-five tests in seconds with no game launched, asking
  whether the vanilla members this mod patches still behave as it assumes. It is what found the
  bug above, and a widening of it later turned up a third non-public member on the same footing,
  `Pawn_NeedsTracker.pawn`, read by the postfix that grants the need at all. Twelve of them have
  been seen to fail under a deliberate fault; the file says which five have not, and why they
  cannot be.
- `_tools/Settings-Tests.ps1`, covering defaults, bounds, persistence and the shortcut contract.
- `Tests/Pickle/`, twenty-four Gherkin scenarios across fifteen features, for what only a running
  game can show.
- `_tools/FUNCTIONAL-SCENARIOS.md`, eighteen scenarios to play by hand, with what to watch and
  what a failure looks like in `Player.log`.

### Known gaps

- Not fully validated in game. Pickle has run every conditional scenario on the current revision
  (`runtime-evidence` 17 of 24, `avec-rimmsqol` 6 of 6, `runtime-film` 1 of 1, none failed). Four of
  the eighteen manual scenarios are complete with reviewed media, twelve remain to be checked by a
  person against media (`docs/MANUAL-REVIEW.md`), and scenario 14, adding to and removing from a save,
  is out of scope. `STATUS.md` lists what stands scenario by scenario.
- The Workshop item is private. Making it public, and posting the thank-you messages, comes after
  the in-game validation, not before.
