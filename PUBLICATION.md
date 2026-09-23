# Publication

What the Steam Workshop page asks for and the repository holds nowhere else. It serves twice: for the
first public release, and for whoever takes the mod over. Workshop item **3806136625**, version 0.1.0,
created private. `Mod/About/PublishedFileId.txt` holds the id and must never be lost: without it the next
upload creates a second item.

## Status on 2026-09-23

Prepared, not released. The gate before this one, `tested`, is not met, so nothing below has been
sent, posted or tagged.

| Blocker | State |
| --- | --- |
| Manual scenarios in `_tools/FUNCTIONAL-SCENARIOS.md` | 4 of 18 complete, 1 partial, 13 unplayed |
| Pickle passes against the current revision | `runtime-evidence` passed 17 of 24, 0 failed. `avec-rimmsqol` and a FilmTicks set have not run against it |
| Presentation screenshots for the page | scenes written in `16-publication-shots.feature`, not run |
| Captures of the last run actually opened | 2 of 22 |
| Tag and GitHub release | not created, awaiting a decision |
| Item tested by subscribing to it, then made public by hand | not done |

What is verified: the repository is clean and pushed; `Mod/` is byte-identical to what was uploaded
(no change since commit `4531a66`); rebuilding `Source/` reproduces the shipped DLL exactly
(SHA-256 starts `e69349c34f01e7e3`), so the item is reproducible from this repository.

## The description

`SetItemDescription` is called only when RimWorld creates an item, so the Workshop page still carries the
description as it was on 0.1.0. A later change to `About.xml` never reaches it: correct the page by hand.

The page as created is out of order against the convention. It has **SOURCE CODE before IF I GO QUIET**,
and **no licence line at all**. The tail should read, in this order, after the body:

```
[h2]IF I GO QUIET[/h2]
If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

[h2]AI-GENERATED[/h2]
This mod was written with Claude Code (Anthropic) under human direction, review and testing. Stated openly: working with these tools is my job.

[h2]THANKS[/h2]
ConcernedApe, whose farm animals in Stardew Valley refuse to give anything at all when they are unhappy, and give their best when they have been let out on fresh grass. The idea is his; none of his work is here.

See ATTRIBUTION.md in the repository. This mod is MIT licensed.

[url=https://github.com/vbardales/Rimworld-Contented-Livestock]Source code on GitHub[/url]
```

`About.xml` has the same ordering fault and is left as it is on purpose: changing it now would make
`Mod/` differ from the uploaded item, and the tag below is only true while it does not. Bring it in step
at the next update.

## Screenshots, in the order to upload

The scenes are written and **not yet run**: `Tests/Pickle/Mod/Pickle/Features/16-publication-shots.feature`,
on the `wsl-deps.studio.map` set (the zen-meadow fixture plus ScreenshotMode), through the shared launcher:

```bash
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod ContentedLivestock -DepMap wsl-deps.studio.map
```

Steam shows the first picture large, so it should be the most demonstrative, not the prettiest. Order:

1. **A cow with its Contentment bar and the live tip**, the five contributions and the rate. It is the
   mod's whole idea in one frame.
2. **The well-kept cow after two game hours**, then
3. **the badly kept cow after the same two hours**, to be uploaded as a pair. Each shows its own bar and
   its own milk fullness; the scenario asserts the first gained more before it takes them. The inspect pane
   shows one animal at a time, so a single frame with both was not possible.
4. **The settings page** over the meadow, ScreenshotMode on, English.

**These are staged, and the page must not say otherwise.** Contentment is set directly and the feed memory
is planted, because nobody waits a game week for a store picture. The rates and the milk are the real
ones; only the starting state is set. Do not caption them as a week of play.

Nothing about them is confirmed until they are opened: whether the interface clutter (the Learning helper,
the colonist bar) sits badly on the meadow, whether the tip dialog and its OK button read well, and whether
the cows have wandered out of frame after two hours. The camera follows the selected animal, so the last
is unlikely. The Needs pane is the subject of scenes 1 to 3, which is why ScreenshotMode is not used there;
if it turns out to hide the pane, that is the right call, and if it does not, the scenes can gain it.

Upload budget, from the reference release of another mod here: JPEG at 1280 x 800, each file at most
2 MB, the batch at most 8 MB. Re-check after any recompression.

## Dependencies and DLC

- **Hard dependency: Harmony only** (`modDependencies`, with its Workshop and download links). The code
  uses `HarmonyLib` and no other third-party assembly.
- **Optional: RIMMSQOL**, which can reveal the hidden MainButtons shortcut. It is not in `loadAfter`
  because it is not needed for anything to work; settings are always under Mod options.
- **`loadAfter`** holds Harmony, the base game and the five expansions, for order only.
- **No expansion is required.** No `LoadFolders.xml`, no `IfModActive`. Supported version: 1.6.

## Content boxes

No adult content. The Preview and the ModIcon were opened: a lit animal shelter at night with a cow, a
calf, a pail of milk, eggs and a fleece; and a cartoon mascot among a cow, a sheep, a hen and a pig in a
pen. The screenshots above are still to be opened once they exist.

## Steam release notes, for the first upload

```
First release. Colony animals that produce milk, wool or eggs now carry a contentment need, built from
what they ate, their pasture or room, their temperature, their health and their company. Contentment
sets how fast they fill: nothing below a floor you choose, up to 40% faster above a plateau. Nothing
already accumulated is ever lost. Every threshold and rate is a setting, and each of the five inputs can
be switched off. Needs Harmony.
```

## After the upload

- `Mod/About/PublishedFileId.txt` is unchanged for an update. `git status` must stay clean.
- Steam creates a new item private and RimWorld never calls `SetItemVisibility`: **subscribe to the item
  yourself, check it loads, then switch it to public by hand**.
- Post the thanks below only once the item is public: a link to a private item opens for nobody.

## Tag and release

Not created. The tag belongs on a commit whose `Mod/` matches the upload, and every commit since
`4531a66` does, so the current head is a truthful target. The GitHub release takes the `0.1.0` section
of `CHANGELOG.md` as its notes. A public tag and release are an outward-facing step and wait for a yes.

## Thanks to post on the mods' pages

One per page, once they can see the link. Pasting the bare item URL gives a thumbnail:
`https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625`. Each is under 1000 characters, the
limit of a Steam comment.

**Harmony** (Andreas Pardeike)

```
Contented Livestock changes how fast a cow, a sheep or a hen fills, and it does it with five small Harmony patches: the tick of the milk and egg comps, the food an animal eats, and who gets a need at all. Without Harmony there would be no way to reach any of those places from a mod that adds no new class of animal. Thank you for it, and for keeping it working through every RimWorld update! 🙏
https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625
```

**RIMMSQOL** (packageId prefix MalteSchulze; check the author name on the page before posting)

```
Contented Livestock ships a settings shortcut on the main bar, hidden by default, and RIMMSQOL is the mod I built it for: you can reveal it from your own list of main buttons, and it opens the same settings page as Mod options. I tested reveal, open, hide and forget, and that the choice survives a restart. Nothing depends on it, but it made the design easy. Thank you for it! 😊
https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625
```

**Immersive Taming** (GuppyFacesAreCute) - optional, and a decision for the author of the mod, not for me

```
While checking that nobody had done it already, I found that Immersive Taming patches the same two places I needed, the gatherable comp and the egg layer, to stop a merely tolerated animal from producing. That told me the hook works. Contented Livestock uses a different one, the tick rather than the yield, and a different idea, a rate that follows how an animal is kept. No code is shared, and I wanted to say thank you for the proof. 😊
https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625
```

That last one is not inspiration in the usual sense, and `ATTRIBUTION.md` says so plainly. Post it only if
it reads to you as a thank-you rather than a mention. ConcernedApe has no Workshop page, so his credit
lives in the description and the README.
