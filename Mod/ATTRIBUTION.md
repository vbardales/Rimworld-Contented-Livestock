# Attribution

## Summary

**Nothing in this mod is redistributed from another mod.** No code, no defs, no textures, no
sounds. It is original work written against RimWorld's own API, and the MIT licence in `LICENSE`
covers the whole of the shipped content without a carve-out.

The mod has no dependencies beyond RimWorld itself.

## Where the idea comes from

The mechanic is Stardew Valley's, and it is worth saying so plainly. In that game a farm animal
carries a mood from 0 to 255: below 70 it may produce nothing at all, below 150 it can produce no
quality, and the things that raise it are fresh grass, a daily pat, the door closed at night and a
heater in winter. ConcernedApe's design; none of his work, code or assets is here, and the
transposition is not a copy — RimWorld has no product quality on animal goods, so the same idea
lands on the rate instead of the grade, and the inputs are RimWorld's own (pen food balance,
comfortable temperature range, pain, bonds) rather than Stardew's.

This was found during a survey of Stardew Valley's systems against RimWorld and its mods. The
survey is what established that nobody had done it: see the note below.

## Prior art checked, and why none of it occupies this ground

Checked against 10 350 subscribed Workshop mods, indexed by name and by full description, on
6 September 2026.

### Immersive Taming — GuppyFacesAreCute

- Workshop `3778917393`, packageId `guppyfacesarecute.immersivetaming`, 1.6.
- **Patches the same two methods**: `CompHasGatherableBodyResource.Active` and
  `CompEggLayer.ProduceEgg`, to stop a merely *tolerated* wild animal from producing. It is the
  proof that this hook works, and it is the closest thing in the corpus.
- It is not the same mechanic. It gates production on a taming stage — an on/off switch tied to a
  relationship the player builds once — not on a state that varies with how the animal is kept.
  It is also a full overhaul of taming; this changes one rate and nothing else.
- No code is shared. This mod patches `CompTick` rather than `Active`, for the reasons in the
  README.

### Animal Traits System — Luved

- Workshop `3652630316`, 1.6.
- Gives animals **permanent** traits through hediffs and stat modifiers. Individuality, not a
  state that rises and falls with care.

### Better Wool Production — several

- Rebalances a rate. Nothing reads the animal's condition.

### Nuzzle Me — ChaoticEnrico

- Workshop `3573691945`, 1.6. Lets you order a colonist to pet an animal, for a mood buff **on
  the colonist**. The animal gets nothing from it.

### Comforts — astryl

- Workshop `3743625015`, 1.6. Per-pawn tastes, for humanlikes. Different creature, different
  need.

## RimWorld API used, and not copied

Everything the mod touches belongs to RimWorld: `NeedDef`, `Need`, `Pawn_NeedsTracker`,
`CompHasGatherableBodyResource`, `CompEggLayer`, `Thing.Ingested`, `AnimalPenUtility`,
`PenFoodCalculator`, `GenTemperature.ComfortableTemperatureRange`, `PawnRelationDefOf.Bond`.
The publicised `Assembly-CSharp.dll` produced during the build stays out of the published folder;
see `Source/Directory.Build.props`.
