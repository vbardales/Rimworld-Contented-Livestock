# Publication

What the Steam Workshop page asks for and the repository holds nowhere else. It serves twice: for the
next release, and for whoever takes the mod over. Workshop item **3806136625**, version 0.1.0 uploaded from
the game, private. `Mod/About/PublishedFileId.txt` holds the id and must never be lost: without it the next
upload creates a second item.

Publication goes through GitHub Actions, not the in-game button (root `AGENTS.md`,
`Rimworld-Release-Admin/docs/OPERATIONS.md`). The workflow is generated and no dry-run has run: see section 6.

## Status on 2026-09-24

Prepared, not released. The gate before this one, `tested`, is not met, so nothing below has been
sent, posted or tagged.

| Blocker | State |
| --- | --- |
| Manual scenarios in `_tools/FUNCTIONAL-SCENARIOS.md` | 4 of 18 complete, 1 partial, 12 unplayed, 1 out of scope (14). Method and progress: `docs/MANUAL-REVIEW.md` |
| Pickle passes against the current revision | `runtime-evidence` passed 17 of 24, `avec-rimmsqol` 6 of 6, `runtime-film` 1 of 1, 0 failed: every conditional scenario has run |
| Presentation pictures | all four taken and opened; picture 1 is clean since the third run (2026-09-25) and waits for the owner's eye |
| Publication workflow | generated 2026-09-24 (`.github/`), 57 of 57 script tests pass; no dry-run has run, see section 6 |
| Tag and GitHub release | created by the CI after a successful upload, never by hand |
| Item tested by subscribing to it, then made public by hand | not done |

What is verified: rebuilding `Source/` reproduces the shipped DLL exactly (SHA-256 starts
`7653167da2c9a605`, checked by a second rebuild). `Mod/` now differs from the 0.1.0 upload in four files: the
two below and the English and French `Keyed/ContentedLivestock.xml` (the tip of an animal below the floor was
reworded on 2026-09-25).
`About/About.xml`: the sentence promising that the mod is safe to add to and to remove from a save was
removed on 2026-09-24 (backward compatibility of saves is not handled or tested). `Assemblies/ContentedLivestock.dll`:
the pen rule was corrected on 2026-09-25 (see `CHANGELOG.md`); the 0.1.0 DLL started `e69349c34f01e7e3`.
Both ship with the next release. Pickle evidence taken before 2026-09-25 is on the older DLL, so a full
pass on the final SHA is owed. Under the fail fast policy (section 6) it runs after the publication, not
before it, but no scenario may still be red: the fixes of the test steps found on 2026-09-25 must first come
back green.

## Steam description

The single source of the Workshop description, decided by the owner on 2026-09-25 (`Rimworld-Release-Admin/docs/OPERATIONS.md`,
"Changing where the Steam description comes from"). It is written **once**, in Markdown, in the fenced block below. The CI
converts it to Steam BBCode and **generates the plain-text `<description>` of `Mod/About/About.xml` from it**, so nothing is
kept in step by hand: edit this block, never `About.xml`, and run `node .github/scripts/sync-about-description.mjs --write`
after a change (read the diff, commit both). Every dry-run and publish stops if `About.xml` differs. The block cannot contain
a code fence, and its last line is the source link. Steam accepts at most 8000 bytes of BBCode. Sent only when the publish
is dispatched with the description option, and then it **overwrites what is on the page**: read the description that the
dry-run prints, and compare it with the page, before any publish.

The page created for 0.1.0 carries the older text: it has the promise about saves, puts SOURCE CODE before IF I GO QUIET,
and has no licence line. The first publish with the description option corrects all three.

```markdown
A cow in RimWorld gives the same fourteen milk whether it spends its life on good grass or in a concrete corridor. This mod makes how you keep an animal decide what it gives you.

## WHAT IT ADDS

Every colony animal that produces something gets a contentment need, alongside food and rest. It is not a mood - animals have no thoughts and get none here. It is a slow state, built from five things:

- **What it last ate.** Grazing a living plant is the best thing that can happen to a grazer; then raw produce and meat, then hay, then kibble, then carrion. The memory of a meal fades over two days.
- **Its pasture or its room.** Roped animals are judged on whether their pen grows back faster than the herd eats it - the figure the pen marker already shows you. Everything else is judged on floor space per animal.
- **Its temperature**, measured against its own comfortable range. A heated barn matters to a chicken and not to a husky.
- **Its health.** Pain, bleeding and hunger all pull contentment down.
- **Its company.** A bond with a colonist helps; a herd animal kept away from its own kind suffers.

Contentment then decides how fast the animal fills with milk, wool or eggs. Content, it fills faster than vanilla. Neglected, slower. Below a floor you can set, it stops filling altogether - but never loses what it had already accumulated. A bad week costs you the week, not the progress.

Nothing jumps. Contentment walks toward its target over about a day, so losing a pasture takes a day to show and a day to undo.

## WHY THE NEED, AND NOT A MOOD

An animal in RimWorld carries exactly two needs: food and rest. Eight of the ten in the base game are barred from animals by a single line of their definition. That is not an oversight to be worked around - it is the reason a herd is cheap to run - so this adds one need and no thoughts, no mental states, and no new jobs. Everything it reads is something the game already tracks and you already build for.

Production is scaled at the tick rather than at the yield. The obvious target is the amount an animal gives, but that is a property each kind of animal product overrides separately, so patching it would catch cows and miss sheep, and would miss every modded product entirely. The filling itself is written once. One patch covers milk, wool, eggs, and anything a mod hangs off the same machinery.

## WHAT IT DELIBERATELY DOES NOT DO

It does not touch reproduction, taming, training, wildness, or how much an animal eats. Contentment changes the rate of one thing only.

It does not give animals thoughts, mental breaks or moods, and it adds no new jobs for your colonists. There is nothing new to do - only reasons for what you already do.

It does not put a need on wild animals or on other factions' animals. Only your own, and by default only the ones that actually produce something.

It does not add an alert. An animal that has stopped producing says so in its own inspect pane, and that is where you were already looking.

## COMPATIBILITY

Requires [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077), loaded before this mod (built and checked with Harmony 2.4.2.0). [RIMMSQOL](https://steamcommunity.com/sharedfiles/filedetails/?id=1084452457) is optional: mod settings are always available through Mod options.

Works with modded animals and modded animal products without patches, as long as they use the game's own milkable, shearable or egg-laying machinery.

Every setting is adjustable, and each of the five inputs can be switched off on its own. Set the fastest rate to 100% for a version that only ever penalises.

## LICENCE

This mod is MIT licensed. Full attribution: [ATTRIBUTION.md](https://github.com/vbardales/Rimworld-Contented-Livestock/blob/main/ATTRIBUTION.md). Licence text: [LICENSE](https://github.com/vbardales/Rimworld-Contented-Livestock/blob/main/LICENSE).

## IF I GO QUIET

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

## AI-GENERATED

This mod was written with Claude Code (Anthropic) and OpenAI Codex under human direction, review and testing. The Preview and the ModIcon were generated with DALL-E (OpenAI). Stated openly: working with these tools is my job.

## THANKS

ConcernedApe, whose farm animals in Stardew Valley refuse to give anything at all when they are unhappy, and give their best when they have been let out on fresh grass. The idea is his; none of his work is here.

Andreas Pardeike, for [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077), which every patch of this mod stands on. The author of [RIMMSQOL](https://steamcommunity.com/sharedfiles/filedetails/?id=1084452457), the tool the optional settings shortcut was built to be revealed by, and which the tests exercised. The tests also ran on [Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678), [RimLogging](https://steamcommunity.com/sharedfiles/filedetails/?id=3733484696) and [Nelim's Pickle Tools](https://steamcommunity.com/sharedfiles/filedetails/?id=3806142401): development only, never a dependency of this mod.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Contented-Livestock)
```
## 2. Pictures, in the order to upload

The CI sends only the header image (`Mod/About/Preview.png`, when its option is on). The gallery is a manual
step on the Steam page, in this order. Run the scenes by submitting a request to TicketDispatcher, not by
launching anything (`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`); to redo one picture, filter on its
scenario with `-Filter '::<scenario name>'`. The scenes are
`Tests/Pickle/Mod/Pickle/Features/16-publication-shots.feature`, on the `wsl-deps.studio.map` set. The
2026-09-24 run and its findings are in `docs/runs/2026-09-24.md`; the media are in
`Tests/Pickle/evidence/2026-09-24/publication-shots/`, as JPEG at 1920 x 1080.

Steam shows the first picture large, so it should be the most demonstrative, not the prettiest. Order:

1. **A cow with its Contentment bar and the live tip**, the five contributions and the rate. It is the
   mod's whole idea in one frame.
2. **The well-kept cow after two game hours**, then
3. **the badly kept cow after the same two hours**, to be uploaded as a pair. Each shows its own bar and
   its own milk fullness; the scenario asserts the first gained more before it takes them. The inspect pane
   shows one animal at a time, so a single frame with both was not possible.
4. **The settings page** over the meadow, English. Owner's remark of 2026-09-25: the first version (ScreenshotMode on)
   showed no contentment bar, since that mode hides the game's interface. It is being redone without the mode, with
   a cow selected to the left of the window so that the bar in the bottom-left pane stands beside the settings, then
   cropped like picture 1 (the left 1500 pixels). The redo waits for the queued requests (a request stages the
   tree as it is when it plays); the scene is ready in the session's notes and goes in as the third scenario of
   `16-publication-shots.feature`. Until then the settings-only capture in `Tests/Pickle/evidence/2026-09-24/` stands
   in.

**These are staged, and the page must not say otherwise.** Contentment is set directly and the feed memory
is planted, because nobody waits a game week for a store picture. The rates and the milk are the real
ones; only the starting state is set. Do not caption them as a week of play.

What opening them showed, 2026-09-24:

- **Pictures 2, 3 and 4 are usable.** The pair shows milk fullness 11% against 4.7% after the same two game
  hours, and each pane shows its own Contentment bar. The gain is 2.3 times, not the 2.9 of the two
  production factors (140% and 49%), because contentment drifts over the two hours: **do not quote a
  ratio in a caption.** The settings page is clean.
- **Picture 1 had a stray tooltip, and two attempts did not remove it; the third run did (2026-09-25).** Another
  pawn's name ("Miel, Surveyor") floated beside the cow, drawn because Pickle's pointer rests at the screen centre
  after a camera jump and the game draws the tooltip of whoever is under it. Showing the cow three cells left and
  four up was not enough, because the glade is the station of the actress Miel and she walks under the pointer;
  the scene now sends her to the zen garden first. The capture of the third run shows Daisy left of centre, her bar
  at 72 percent, the tip at the top left ("Last fed on: +15%"), and no stray label. The earlier flawed captures
  are deleted.
- **The tip is a dialog, not the game's hover tooltip.** It carries the real text of the need, in a message box
  moved to the top left. Say "the contentment tip", not "hover tooltip".
- The right edge of the full frame shows the fixture's own alerts ("Need colonist beds", "Pen needed", "Medical
  treatment needed") and the Learning helper. They were kept on purpose at first (the alerts are part of the real
  interface), then **picture 1 is cropped to its left 1500 pixels** at the owner's suggestion (2026-09-25): the
  right part carries nothing of the subject, and the crop puts the cow, the tip and the panes at a larger scale.
  The crop keeps the full height (1080), so the left panes and the bottom bar stay; it is 1500 x 1080, not the
  16:10 of the upload budget, and is scaled to 1280 pixels wide (1280 x 922). Pictures 2, 3 and 4 are still to be
  looked at for the same crop.- The files are 1920 x 1080 and 0.6 MB each; the upload budget asks for JPEG at 1280 x 800, each file at most
  2 MB, the batch at most 8 MB. They are resized once all four are final, not before.

## 3. Dependencies and DLC

- **Hard dependency: Harmony only** (`modDependencies`, with its Workshop and download links). The code
  uses `HarmonyLib` and no other third-party assembly.
- **Optional: RIMMSQOL**, which can reveal the hidden MainButtons shortcut. It is not in `loadAfter`
  because it is not needed for anything to work; settings are always under Mod options.
- **`loadAfter`** holds Harmony, the base game and the five expansions, for order only.
- **No expansion is required.** No `LoadFolders.xml`, no `IfModActive`. Supported version: 1.6.

## 4. Content boxes

No adult content. The Preview and the ModIcon were opened: a lit animal shelter at night with a cow, a
calf, a pail of milk, eggs and a fleece; and a cartoon mascot among a cow, a sheep, a hen and a pig in a
pen. The pictures above were opened as they were taken.

## 5. Steam change note

The workflow reads the Steam change note from the fenced block under the `### 1.0.0` line below, sent as
written (BBCode, at most 8000 bytes, no double quote and no backslash: the upload library turns every double
quote into a typographic one). The GitHub release notes come from the `## [1.0.0]` section of `CHANGELOG.md`,
which is renamed from `## Unreleased` in the commit that carries the final suite, because any later commit
changes the SHA that the dry-run validates.

The version is **1.0.0**, the first production release (`PUBLISHING.md`, "Mise en production d'une 1.0.0"),
tag `v1.0.0`. The 0.1.0 uploaded from the game is a prepublication and has no GitHub tag, so nothing collides.
Virginie decides if another number is wanted.

### 1.0.0

```
[b]1.0.0[/b]
First release. Colony animals that produce milk, wool or eggs now carry a contentment need, built from what they ate, their pasture or room, their temperature, their health and their company. Contentment sets how fast they fill: nothing below a floor you choose, up to 40% faster above a plateau. Nothing already accumulated is ever lost. Every threshold and rate is a setting, and each of the five inputs can be switched off. Needs Harmony.
```

## 6. Publishing through the CI

Rules that never bend (root `AGENTS.md`): a dry-run for the exact commit passes first and its run ID and SHA
are recorded next to `STATUS.md`; `publish` takes a full 40-character SHA, never a branch; **only Virginie
approves the `steam-production` environment**; Steam credentials never enter this repository; the CI creates
the tag and the GitHub release after a successful upload, so **none is created by hand**.

The workflow was generated on 2026-09-24 by `Rimworld-Release-Admin/scripts/generate-publish-workflow.sh`
(template stamp `eba6b3fdf670`), which writes under `.github/` only: `workflows/publish-tag.yml`,
`workflows/script-tests.yml`, `publish.config.json`, `scripts/` and `tests/`. Its 57 script tests pass locally (regenerated on 2026-09-25 for the Markdown description, template stamp `51b1f34258b9`)
(`node --test '.github/tests/*.test.mjs'`). Values: workshop id `3806136625`, package id
`nelim.contentedlivestock`, required payload `Assemblies/ContentedLivestock.dll`, description from this file
under `^## Steam description$` (Markdown; `About.xml` is generated from it). **No dry-run has run.** The CI/CD session reviews the diff and the dry-run log, and checks the
`release-dry-run` and `steam-production` environments and their secrets; this repository touches none of them.

`Mod/` has no `.steamignore` here (that belongs to another release path), so everything in `Mod/` is uploaded:
it holds only About, Assemblies, Defs, Languages, `ATTRIBUTION.md` and `LICENSE`.

**The final commit carries all of this at once**, because the dry-run validates one SHA and any later commit
changes it (CI/CD session, 2026-09-24). Do not do these one by one:

1. the last changes to `Mod/`, held back until the queued requests are back (a request stages the tree as it is
   when it plays): the `About.xml` description regenerated from the Markdown block (`node .github/scripts/sync-about-description.mjs --write`, diff read); a copy of `ATTRIBUTION.md` in `Mod/`
   if the root one changes; and the wording of the producers-only setting, which had no verb: **chosen by the owner on 2026-09-25, option C**,
   "Only animals that give milk, wool or eggs have contentment" and, in French, "Seuls les animaux qui donnent du
   lait, de la laine ou des œufs ont du bien-être" (key `ContentedLivestock.Settings.ProducersOnly`; its tip does
   not change), already noted in `CHANGELOG.md`;
2. `## Unreleased` in `CHANGELOG.md` renamed to `## [1.0.0] - <date>`, with a non-empty body;
3. the four final pictures, resized to JPEG 1280 x 800, at most 2 MB each and 8 MB the batch, committed in
   `Art/WorkshopScreenshots/` and named `01-...`, `02-...`, in the upload order of section 2 (Virginie asked
   for this, so the dry-run lists them as a reminder of the manual gallery upload; it sends nothing);
4. the workflow regenerated with the **full** argument list below, never only the new option: a `--replace`
   with an argument missing changes the config, and a later one typed from memory without `--gallery-dir`
   silently drops `galleryDir`. Then run `node --test '.github/tests/*.test.mjs'` and check that
   `git diff` shows only `galleryDir` added in `.github/publish.config.json` (files that differ by line
   endings only are normalized on commit).

```bash
bash /c/Users/nelim/Documents/rimworld/Rimworld-Release-Admin/scripts/generate-publish-workflow.sh \
  /c/Users/nelim/Documents/rimworld/ContentedLivestock --replace \
  --workshop-id 3806136625 --package-id nelim.contentedlivestock \
  --release-title "Contented Livestock {version}" \
  --require Assemblies/ContentedLivestock.dll \
  --description-markdown PUBLICATION.md --description-heading '^## Steam description$' \
  --about-from-description \
  --gallery-dir Art/WorkshopScreenshots
```

The gallery listing is alphabetical and counts only png, jpg, jpeg and gif files, non-recursive: the folder
must hold nothing else that should be listed. Send the CI/CD session the SHA once the final commit is pushed.

The description is an option, off by default, and it must be on in **both** the dry-run and the publish:
`dispatch-publish.sh` refuses a publish whose options differ from the dry-run's, so add `--description`
to the command. The dry-run prints its length, SHA-256 and a line diff against the public page, which is how
the corrections of the Steam description are seen before they go. Preview (`--preview`) only if the page image must change.
Visibility is never sent.

**Fail fast policy (Virginie, 2026-09-25; `AUDIT.md`, step `prepublished` to `published`, and root
`PUBLISHING.md`).** We publish once no red is left open, and the non-regression pass runs after the
publication. **Before the `publish` is dispatched, nothing of this is skipped:**

1. **No red scenario without a green rerun.** Every scenario that failed must have been replayed green on a
   build that holds its fix. Open here on 2026-09-25: the hen of scenario 11 (`...-217d`), scenario 12
   (`...-088f`), scenario 5 (`...-69e3`), scenario 8 (`...-d762`) and presentation picture 1 (`...-29ec`).
   Those failures were faults of the test steps, fixed and resubmitted; until each has come back green they
   count as red.
2. **The Workshop gallery** (four pictures, section 2) and **the owner's manual validations** (the verdicts
   on `docs/MANUAL-REVIEW.md`).
3. **The guard rails, unchanged:** dry-run of the exact commit first, `publish` with the full SHA, approval of
   `steam-production` by Virginie alone.
4. **The rollback target, chosen by Virginie on 2026-09-25: the item goes back from public to private.** If the
   non-regression pass comes back red on the published 1.0.0, Virginie returns the item to private by hand on
   Steam (the visibility is hers, never the CI's nor a session's); no rollback version is published to do it.
   The fix is then published as a new version, through the same gates, and the item is made public again by
   hand. This is a visibility rollback, not the version rollback described in `AUDIT.md`: the commit to fall
   back on, if a version is ever wanted, is the last one whose out-of-game tests and passes were green.
**What is lifted:** waiting for the non-regression pass, that is the replay of the rest of the suite (the
scenarios that were never red, and the whole suite on the final build) and of the game passes still queued.
They run right after the publication, as small tickets, and their verdict goes in `STATUS.md` and
`docs/runs/`. If one comes back red it is a defect of the published version, said as such: a **rollback published
as a new version** (`ref` = the full SHA of the last good commit, the next patch number, a note "Reverts to ...,
because ..."; the workflow refuses an existing tag and versions only go up), then a separate fix.
After a publish: check the public page against the Steam description, subscribe to the item yourself and check it loads
in game, then **Virginie changes the visibility by hand**: the CI never sends it, and RimWorld never did.
Post the thanks below only once the item is public: a link to a private item opens for nobody.

## 7. Thanks to post on the mods' pages

One per page, once they can see the link. Pasting the bare item URL gives a thumbnail:
`https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625`. Each is under 1000 characters, the
limit of a Steam comment.

Checked against the global register (`WORKSHOP_COMMENTS.md` at the collection root, 2026-09-25): **Harmony**
(2009463077), **RIMMSQOL** (1084452457), **Pickle** (3791648678) and **RimLogging** (3733484696) are already
`posted` there, so **nothing is posted again**. After the item is public, add `Contented Livestock` to the `Covers`
column of those four rows. **PickleTools** (3806142401) is the author's own project: `not_applicable`, no self-comment.
All four external recipients are also thanked in the Steam description, as the workflow asks for a named
or exercised integration.

**Immersive Taming** (GuppyFacesAreCute, 3778917393) - not in the register yet: add a `drafted` row for it. Optional,
and a decision for the author of the mod, not for me

```
While checking that nobody had done it already, I found that Immersive Taming patches the same two places I needed, the gatherable comp and the egg layer, to stop a merely tolerated animal from producing. That told me the hook works. Contented Livestock uses a different one, the tick rather than the yield, and a different idea, a rate that follows how an animal is kept. No code is shared, and I wanted to say thank you for the proof. 😊
https://steamcommunity.com/sharedfiles/filedetails/?id=3806136625
```

That last one is not inspiration in the usual sense, and `ATTRIBUTION.md` says so plainly. Post it only if
it reads to you as a thank-you rather than a mention. ConcernedApe has no Workshop page, so his credit
lives in the description and the README.
