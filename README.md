# Contented Livestock

A RimWorld 1.6 mod. **How you keep an animal decides what it gives you.**

A vanilla cow gives the same fourteen milk on the same one-day clock whether it grazes good
pasture or stands in a concrete corridor. This adds one need to colony animals and hangs milk,
wool and eggs off it.

- Public, original work. Nothing is redistributed — see [ATTRIBUTION.md](ATTRIBUTION.md).
- packageId `nelim.contentedlivestock`.

## What it does

Every colony animal that produces something carries a **contentment** need, next to food and
rest. It is not a mood: animals get no thoughts, no mental states, no new jobs. It is a slow
state built from five inputs, each of them something the game already tracks:

| Input | Range | What it reads |
| --- | --- | --- |
| Feed | −25 % … +25 % | The last thing eaten, fading over two days |
| Pasture and room | −20 % … +20 % | The pen's food balance, or floor space per animal |
| Temperature | −30 % … +5 % | Distance outside the animal's own comfortable range |
| Health | −35 % … 0 | Pain, bleeding, hunger |
| Company | −10 % … +10 % | A bond with a colonist; a herd animal left alone |

They are signed offsets around a neutral 0.5, summed and clamped. Contentment then walks toward
that target at one full swing per day, so nothing jumps.

Contentment scales the rate at which the animal fills:

```
below  25 %  →  it does not fill at all
25–60 %      →  40 % → 100 % of the vanilla rate
60–100 %     →  100 % → 140 %
```

**Nothing accumulated is ever lost.** A herd that goes hungry for a week loses the week, not the
progress it had already made. Every number above is a setting, and each of the five inputs can be
switched off on its own.

## How it is built

### The need

`NeedDef` has `minIntelligence` — a floor — and it is the single line that keeps mood, recreation,
comfort, beauty, indoors, outdoors, drug desire and room size off animals. Eight of the ten needs
in the base game set it to `Humanlike`; `Food` and `Rest` leave it at its default, which is
`Animal`, and that is the whole reason animals have those two and nothing else.

There is no matching ceiling, so no def field can say *animals and nothing else*. Hence one
postfix on `Pawn_NeedsTracker.ShouldHaveNeed`, which is also where the player-faction and
producers-only rules live. `requiredComps` would have covered the second of those declaratively,
but it is a conjunction: it can ask for a gatherable comp, or for an egg layer, never for either.

A second postfix on `Pawn.SetFaction` calls `AddOrRemoveNeedsAsAppropriate`, so a freshly tamed
muffalo gets its need at once rather than at the next load, and a sold one loses it.

### The production

The obvious target is the amount an animal gives — `CompHasGatherableBodyResource.ResourceAmount`.
It is the wrong one: every subclass overrides it, so patching the base catches nothing and
patching `CompMilkable` would leave `CompShearable` alone, and every modded product with it.

`CompTick` is declared once, on the base, and no vanilla subclass overrides it. One patch there
covers milk, wool, and anything a mod hangs off the same comp. Eggs need their own, because
`CompEggLayer` is a different class with its own `eggProgress`.

Both patches are the same shape, and it is a shape worth naming:

```csharp
public static void Prefix(CompHasGatherableBodyResource __instance, out float __state)
    => __state = __instance.fullness;

public static void Postfix(CompHasGatherableBodyResource __instance, float __state)
{
    float delta = __instance.fullness - __state;
    if (delta <= 0f) return;
    ...
    __instance.fullness = __state + delta * factor;
}
```

The prefix reads the field rather than recomputing vanilla's increment, so the mod never has to
know the formula and keeps working if it changes. Only a **rising** delta is scaled, which is what
makes the mod incapable of taking anything away: gathering zeroes `fullness`, laying zeroes
`eggProgress`, and both pass through untouched. It is also why the unfertilized-egg stall needs no
special case — vanilla holds `eggProgress` still, the delta is zero, there is nothing to scale.

### The feed

`Thing.Ingested(Pawn, float)` is the single funnel every meal passes through, and unlike
`IngestedCalculateAmounts` it is not virtual, so one patch sees every food in the game.

Grazing is not a special path: a grazing animal ingests the living `Plant` itself. `food is Plant`
is therefore an exact test for *ate grass out of the ground*, and it is the only one that works —
hay and a growing plant both carry `FoodTypeFlags.Plant`, so the flags cannot tell a pasture from
a hopper.

## Neutral by construction

`Contentment.RateFactor` returns exactly `1f` for any animal with no contentment need — a wild
one, another faction's, or every animal at all when the need is switched off. Absence is not a
special case, it is the neutral value. That is what makes the mod safe to add to a running save
and safe to remove from one.

## Testing

Two halves, because they answer different questions.

```bash
powershell -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
```

Twenty-one tests, no game launched. They ask whether the vanilla classes this mod hangs
itself off still do what it hangs itself off them for: that `CompTick` is declared once and
overridden by no subclass, that it is still what stores into `fullness`, that `Thing.Ingested` is
still the non-virtual funnel, that every `[HarmonyPatch]` still resolves, and that the patches can
really touch the fields they wrap. Twelve of the original seventeen have been seen to fail under a
deliberate fault; the five that assert facts about the game's own assembly cannot be, and the file
says which are which rather than glossing it. Four additional checks validate shipped XML, NeedDef fields and scalar types, DefInjected targets, and the GitHub metadata; these four have not been mutation-tested.

That last test is not decoration. It found, on its first run, that both production patches threw
`FieldAccessException` at the first tick of every animal, which had gone unnoticed because the mod
had never been run in a game. See `Source/AccessChecks.cs`.

Its companion enumerates instead of listing: every non-public member of the game the mod's IL
touches, minus those reached from a subclass of their own declaring type, which need no waiver.
That is how a third one turned up — `Pawn_NeedsTracker.pawn`, private, read by the postfix that
grants the need at all, and with no instance to build it could never have been caught by trying.

[`_tools/FUNCTIONAL-SCENARIOS.md`](_tools/FUNCTIONAL-SCENARIOS.md) is the other half: fifteen
scenarios to play, one thing to watch in each, and what a failure looks like in `Player.log`. No
amount of reflection can tell you whether a well-kept cow fills faster than a neglected one.

## Building

```bash
cd ContentedLivestock/Source
dotnet build
```

Output goes to `Mod/Assemblies/`; intermediates go to `.build/`, outside the folder the Workshop
uploader sends.

## Showcase

`Art/Preview.png` holds the illustration without text; `Art/Preview-source.png` preserves
its original. `Art/preview.html` composes the overlay at 896x504 using the single palette
in `Art/preview-palette.json`. The version badge reads the shipped About.xml.

Run `node Art/render-preview.cjs` with `NODE_PATH` pointing to installed `playwright` and
`sharp` packages. Chrome defaults to its standard Windows installation; `CHROME_PATH`
can override it. The renderer waits for fonts, checks the actual font faces and contrast,
and writes `Mod/About/Preview.png`, a 268px thumbnail and QA evidence under `Art/`.
`About/ModIcon.png` is reduced from the same folder, cropped to the drawing's own bounding box
first so it keeps as much of its 32 pixels in the mod list as it can:

```bash
ffmpeg -i Art/ModIcon-source.png -vf "crop=1100:1100:35:92,scale=128:128:flags=lanczos" \
  -compression_level 100 -pred mixed Mod/About/ModIcon.png
```

## What it deliberately does not do

- **No thoughts, no mental states, no new jobs.** Nothing new to do — only reasons for what you
  already do.
- **No reproduction, taming, training, wildness or appetite changes.** One rate, one mod.
- **No alert.** An animal that has stopped producing says so in its own inspect pane, which is
  where you were already looking.
- **No wild animals.** A need ticking on every squirrel on the map is a performance bill for
  nothing.
