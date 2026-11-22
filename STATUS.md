---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: complete
dependencies_audit: complete
mod:          Contented Livestock
packageId:    nelim.contentedlivestock
repo:         Rimworld-Contented-Livestock
visibility:   public
detached:     yes
workflow_stage: shootGallery[1.0.0]
audit_revision: 5fbc56736e3477a3f5a8b1600e3a7427749ff80d
audit_date: 2026-10-10
licence:      original
license_spdx: MIT
licence_at:   an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the `LICENSE` is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic is Stardew Valley's, credited in ATTRIBUTION.md and reused from none of its lines.
upstream_mod_remotes: N/A
workshop_required_items: "n/a, not released yet (prepublication 0.1.0 only, owner decision 2026-11-10: we will see at 1.0.0)"
dependencies: "brrainz.harmony (required); RIMMSQOL optional, Pickle integration and restart persistence passed"
showcase:     complete
tested_on:    "RimWorld 1.6.4871 rev600, Harmony 2.4.2.0, initial pass 2026-11-13 on 64ad171 (DLL unchanged since C105BF9A830D66C7); RIMMSQOL restart chain 05, 06, 07 green 2026-11-13 (8e5a)"
workshop:     "3806136625 (0.1.0; visibility and subscription test unverified)"
automated_tests: 33 of 33 passed plus Check-HarmonyContract 6 of 6 (2026-11-02, the 35 of before minus the two tests moved to that shared check; 35 of 35 rerun on 03da150 after the harness came back under Tests/Run-Functional-Tests.ps1, `-HarmonyPath` default now the 1.6 Assemblies folder; before, rerun 2026-10-17 after the French text corrections, on 1218fe6, `-HarmonyPath` the Workshop Harmony 1.6 Assemblies folder, DLL unchanged C105BF9A830D66C7; before, 2026-10-17 on 5775be9 against the shipped DLL C105BF9A830D66C7, after the removal of the slider default tick; before it, 2026-10-14 on 3655b90, DLL D2E97D352AE24E64); step expressions checked 2026-11-02 by the shared scripts/Check-Steps.ps1 (106 compile, see remaining)
pickle_scenarios: 51 defined; on the current DLL only the initial pass of 2026-10-10 (no optional mods, English, `-DepMap` omitted by mistake): 30 passed, 1 failed (scenario 02 trade, fixed, then green in replay 3 on 77ba6ef, 1 of 1, both captures opened), 20 skipped for missing companions (Docs/runs/pickle.md); older results: scenario 10 corrected rerun passed 1/1 (2026-09-24), feature 03 avec-rimmsqol 4 of 4 (2026-09-30, older DLL), 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented; 4 completed with reviewed media (0, 1, 6, 13); rule of 2026-09-25 (owner): she validates only what Claude cannot, so Claude's own verdict counts for what it can read. Validated by Claude on 2026-09-25 from opened captures: 3, 7, 9, 10, 11 (cow and sheep), 12, 16, and 4 and 15 for their machine-readable content; left for her eye: the reset confirmation window and slider caps of 15, and the four Workshop pictures (1 accepted, 4 sent); rerun done since: 5, 11 (hen), 15 (keyed clicks); 8 validated 2026-09-28 (growth staged: Desert tile); 14 out of scope. Table in docs/MANUAL-REVIEW.md
manual_visual_evidence: none kept on disk (2026-10-18, owner rule: Tests/Pickle/Evidence/ holds minified proofs only, under 2 MB; runs land in Tests/Pickle/Inbox/). History is one line per run in docs/runs/. Nothing of this is in git.
remaining:
  - "gallery 2026-11-22 (tickets 8e91 and 8b22 green 4 of 4, passed, folder look-fix2-6 read and left Inbox, minified to Tests/Pickle/Evidence/look-fix2-6 with RELEASE.md; scene 1 in Evidence/look-fix2-1): score-gallery by the session, 1 to 5 candidate (scenes 2 and 3 diptych: Buttercup full bar, Thistle short bar; 4 front view of Buttercup with Nelim beside, 15h; 5 closing 18h, tooltip on Thistle minor; image 4.5, adequacy 4.5, understanding 4.5, decoration 4; bars readable at 268 px). Nelim face read at 5x on 4 and 5: no sweat drop, only a very faint cheek tint (default face shading, not the heat blush), accepted. Clean originals in Art/Gallery-clean (1 to 5), subtitled copies burned in Art/Gallery with the lines of PUBLICATION.md (4 opened: one line, readable). Scene 6 (settings page) DECIDED by the session 2026-11-22: accepted as an interface capture, no subtitle. The forest and river map with orange smileys is the scripted window-backdrop-for-height place (feature 16 line 354), by design; cropped to 1416 x 1080 from x 0 (window plus the Daisy pane with the contentment bar), Art/Gallery-clean and Art/Gallery 6-settings-page.jpg, text and sliders readable. Open only: em dash in the English settings text `eggs and below a floor` needs Virginie. Replay 9.a to 9.f done 2026-11-22 (ledger .replays/ContentedLivestock-20261122-9.a-9.f.tsv): 9.a to 9.e done, first open 9.f, stage unchanged shootGallery[1.0.0]. Next: her oui on the whole gallery (9.f, Get-GalleryHash 942dc9a4 at that time), then mountPreview. Evidence/look-fix2-6 deleted."
  - "seen, not fixed (replay 2026-11-22): Docs/ migration of AGENTS.md 2026-11-19 (PROTOCOLS-READ.md, runs/ files other than pickle.md and cited posted logs); npt-sync WARN, run sync-nsb-npt (NPT 2026-11-21); Tests/Pickle/README.md says the suite never ran."
  - "CI regenerated 2026-11-17 (stamp d20db370c66b, `.github` + `Tests/Test-Mod.ps1` committed, Test-Mod 6 of 6 ok). Steam tags are now the default of each publish, `--tags` removed: the existing dry-run is void, redo it WITHOUT `--tags` before any publish (it shows the tag set beside the page tags). A real publish needs `STEAM_REFRESH_TOKEN` on `steam-production` (Virginie manages secrets, never ask CI/CD)."
  - "French text changed 2026-11-13 (e2fb285, text only, DLL unchanged): `Settings.ConfirmReset` and `Nelim_ContentedLivestockSettings.description` now cite `Contented Livestock (Bétail épanoui)` (title decided by Virginie 2026-11-13, Audit registry, Docs/review-names.md). Not read in game. RIMMSQOL in `Settings.Scope`: name decision pending with Virginie (my proposal: keep as is). Ticket 94ca stages the tree at its run, so it carries this text."
  - "unverified (playTests 8.k): manual scenarios not yet validated, see manual_scenarios and docs/MANUAL-REVIEW.md: slider caps of scenario 15 read by Claude in the capture of 2026-10-14 (validated 2026-10-17), the reset confirmation window accepted by the owner on 2026-10-17 (vanilla message box size, also accepted 2026-09-27); the two bar pictures of scenario 4 read at a glance, validated by Claude 2026-10-17 (grazer bar about four fifths, kibble bar about a quarter); left: the Workshop pictures (gallery, belong to shootGallery), no more manual validation owed to her."
  - "unverified (playTests 8.h, 8.i): settings and translated UI replayed in English and French on this DLL, raw keys, fallback text, clipping, Player.log; the reworded `Tip.Halted` and the seven French corrections of 2026-10-02 have been read in game in neither language."
  - "unverified (owner): `Art/ModIcon-source.png` changed on 2026-10-04 and was newer than its derivatives. Regenerated 2026-10-10: `Mod/About/ModIcon.png` (128 x 128, contained on transparency as Render-Preview.cjs does, 35.9 KB, above the 20 to 30 KB band of AUDIT.md 2.b), `Art/ModIcon.ico` (six sizes), then `node ../scripts/Render-Preview.cjs` for `Mod/About/Preview.png`, `Art/Gallery/0-preview.png` and `Art/Preview.ico`. 2.c, legibility at 32 px, is for the owner to judge. Accepted by the owner on 2026-10-10 (the Preview with the new badge). On 2026-10-12 the echo became `Art/echo-source.png` (cow line art from her, 1536 x 1024, opened on a light background: clean strokes, real alpha), `Art/Preview.config.json` points at it (`echo.height` 133 for its 3:2 ratio, `flipX` kept), the Preview was rendered again and opened at full size and at 268 px: the cow sits beside the title without touching it and the title stays legible. `Art/Gallery/0-preview.png` is a byte copy. Sent as the GitHub social preview the same day: the repository `og:image` hashes to the recorded `social_preview_sha256`."
  - "prepared, not released (PUBLICATION.md): section 1 holds the full Steam description in BBCode, the dependency and content-box answers and three thanks drafts under 1000 characters. Publication goes through the CI (workflow generated 2026-09-24, 48 of 48 script tests passed, version 1.0.0). CHANGELOG.md keeps `## Unreleased` until the dry-run commit. Needs the tested gate, a presentation picture to redo (the cow with its tip: a stray tooltip, scene fixed, rerun owed), the owner's review of PUBLICATION.md and CHANGELOG.md for the 1.0 line, and a yes for the tag and the GitHub release. Not before shootGallery."
  - "unverified: `tested_on` stays empty until a green in-game pass records the game and integration versions."
session:      72f45cb8-7e45-4dea-bfa8-11aee1b7b75b
ecosystem_line: 1.0
updated:      2026-11-22, audit replay second pass after the refusal (first open 9.a); 2026-11-20, owner refused gallery 1 to 6 (no trousers, smile misplaced, wrong hairstyle, red face), captures deleted, 5 refile tickets queued, stage shootGallery[1.0.0]
echo_review_sha: c1ea64fc52a95f0771d2842a1073cc3c64eb0338
social_preview_sha256: 73254f46f75d151ad84884a4b5120e65e60fd426a0a83967771e7b5385d96f52
code_review_sha: e26a51c0ea2e7f175b8180173155252f199c275a
protocols_read_sha: bf98fb75fbf9176ef5d4d97359edaf48c12cd8a1
---
# Contented Livestock: status

This file keeps current state only (older journals deleted 2026-11-22, git history keeps them).

## Workflow audit: 2026-10-10

**Old state `done`, state retained `playTests[1.0.0]`** (table of AUDIT.md section 16 give `done` as `playTests`;
target version 1.0.0, content of `## Unreleased` in `CHANGELOG.md`). Revision audited:
`5fbc56736e3477a3f5a8b1600e3a7427749ff80d`. Working tree at audit start: three modified files under `Art/`
(`ModIcon-source.png`, `ModIcon.ico`, `Preview.ico`), left by owner. This audit's own edits listed below.

Checked directly, not from this file:

- **Transitions 1 to 7 hold.** `Mod/` carry `About.xml`, `ModIcon.png`, `Preview.png`, `PublishedFileId.txt`, DLL; no
  `.ico`, no `.dds`, no `desktop.ini` tracked. Old `stage` field removed (retired 2026-10-09).
- **Tests (7.b, 7.c).** `Tests/Run-Functional-Tests.ps1`: 35 of 35 passed 2026-10-10 (33 since 2026-11-02, two checks moved to the shared Check-HarmonyContract, 6 of 6), before and after move
  of `_tools/` to `scripts/` (XML parse, key parity, parameters in EN and FR included).
- **Scenarios (7.a).** 18 manual scenarios in `TESTING.md` (name AUDIT.md 7.a give).
- **Pickle suites (7.d).** `Tests/Pickle/` carry 24 scenarios, written; `TESTING.md` declare passes.
- **Translations (7.g).** `translation_fr: complete` rest on Virginie's review of 2026-10-02 (revision `dadebc2`, 7
  corrections applied). No agreement with pawn's gender in texts, so no `{PAWN_gender}` switch apply.
  U+2014 (em dash, rule of 2026-10-10): none in `About.xml` or Steam description (`Check-Status.ps1` warn there, say 0). Older files still carry some (README, ATTRIBUTION, FRENCH_REVIEW, `Mod/Languages/{English,French}/Keyed`, comments in `Source/`): rule is for text written from now on; two French and three English player-facing strings are text change needing Virginie's review, so left (recommendation below). Earlier version of this line said none, from `grep -P` that failed silently. Mod has no counted noun
  phrase, so no `.One` or `.Many` family needed.
- **Mod root.** No `.XXX` or `_XXX` entry left except `.git`, `.gitignore`, `.github`: `_tools/` now `scripts/`
  (history kept with `git mv`) and `.build/` renamed `build/` (owner rule 2026-10-10, PUBLISHING.md) and emptied. Build intermediates go to `build/`, ignored; props, .gitignore and
  scratch of `Tests/Settings-Tests.ps1` follow. Redirect
  `_tools/preview.html` (target `Art/preview.html` not exist) removed. `scripts/results/` kept: dated 2026-09-13 records cited by journal.
- **French review file.** `FRENCH_REVIEW.md` regenerated by shared `../scripts/Make-FrenchReview.ps1` (title with mod name, repository type `original`, revision `742a881`); French texts unchanged. Mod's own
  `scripts/Generate-FrenchReview.ps1` removed.
- **Art (2.b).** ModIcon source newer than derivatives: regenerated, see `remaining`.

Why not `shootGallery`: nothing of playTests ran on current DLL (see `remaining`). Audit not launch game; passes go through Ticket Manager.

Next transition, strictly (AUDIT.md section 8): one initial Pickle ticket play all scenarios, then each red
scenario alone; conditional scenarios on their passes; in-game settings and EN and FR interface; remaining manual validations; code review (8.m); `tested_on`.

Recommendations, not blockers: replace em dashes of player-facing strings in `Mod/Languages/*/Keyed/ContentedLivestock.xml` at next text change, with her review; bring `ModIcon.png` under 30 KB if owner want band respected (was 32.5 KB before, also above). Scenario file is `TESTING.md` since 2026-10-11 (AUDIT.md 7.a name, asked by Audit workflow session).

## Ecosystem

Refresh of 2026-11-17 (AUDIT 1.a and 8.0, redone from scratch by PiI on the owner's order): 24 Steam queries through Chrome (219 items) plus one corpus scan of contentment and animal mood defNames, full study in `docs/inventory/ecosystem-steam/ContentedLivestock.md` of the protocols repository (commit 615b066). Original creation, no upstream, no original id to search.

| Workshop id | Title | Type | Found by |
|---|---|---|---|
| 2960610215 | Livestock Traders | linked, same subject area, no overlap | Steam |
| 3556058978 | FEB's Biopunk Livestock | linked, no overlap | Steam |
| 1700683323 | Vanilla Animals Expanded - Livestock | linked, dead 1.0 pack | Steam |
| 2581603685 | Mood Matters | linked, pawn mood only | Steam |
| 2680751877 | Caravan Mood Buff | linked, pawn mood only | Steam |
| 3735168948 | Extended Husbandry | linked, growth drugs and implants, no need | Steam |
| 3768408159 | Caravan Husbandry | linked, husbandry in caravans | Steam |
| 2900645347 | Vanilla Outposts Expanded Expanded: Ranch (Continued) | linked, ranch outpost | Steam |

Refresh of 2026-11-19 (DELTA since 2026-11-17 by PiI, Chrome searches `Contented Livestock`, `animal contentment`, `animal happiness`, `livestock mood`, `animal needs`, `animal welfare`): nothing new, no translation, patch, retexture or replacement of ours; two recent unrelated ids (3839936205, 3841771415). Nothing subscribed.

Verdict: no duplicate, no fork, no replacement, no mod that patches, retextures, translates or cites 3806136625; nobody else ties production to animal care. The mod goes on. Nothing subscribed.

## Settings audit

Complete for technical gate (2026-09-13, rechecked by automated tests 2026-10-10). Eleven useful settings, in
native Mod options (**Options de mod, Contented Livestock**), no dependency on RIMMSQOL. MainButtons shortcut
`Nelim_ContentedLivestockSettings` hidden by default (`buttonVisible=false`), open same
`Dialog_ModSettings` and persistence, revealed by RIMMSQOL (Pickle: reveal, open, hide, forget, persistence
across processes, passed 2026-09-24 and 2026-09-30). `Normalize()` bound every slider, treat NaN and infinity as
defaults; settings save on close, apply when play resumes; scope global. 35 tests cover defaults, bounds,
32 input-toggle combinations, rate and speed curves, real Scribe save and load, older files, shortcut
contract. In-game checks, then EN and FR replay (`passed`), belong to playTests: see `remaining`. Full record
of 2026-09-13 in journal.

## Translation audit

Where text live: `Mod/Languages/{English,French}/Keyed/ContentedLivestock.xml` and
`Mod/Languages/French/DefInjected/{NeedDef/Needs_Contentment.xml,MainButtonDef/MainButtons_ContentedLivestock.xml}`
(three files, listed with every row in `FRENCH_REVIEW.md`). Inventory from shipped XML and source; every key
resolve to nonempty EN and FR text (35-test suite). **French review line:** reviewer Virginie, 2026-10-02, then 2026-10-17 for the five texts changed after ChatGPT reviews (revision 3aa4ac7), and for `Settings.SpaceTip` (revision 77756c9), French files
as of revision `dadebc2`, 7 corrections requested and applied, no dynamic gender agreement needed, `translation_fr:
complete`. `Tip.Halted` rewording of 2026-09-25 in both languages; in-game reading part of playTests.

## Dependencies and integrations (audit 2026-10-02, revalidated for the declared state on 2026-10-10)

Required: `brrainz.harmony`. Optional integration: RIMMSQOL (reveal hidden shortcut), exercised by
`avec-rimmsqol` pass. Pickle and companions development only. Mod add no animal, patch no other mod, so
four animal integrations of `ANIMALS.md` not apply. No DLC dependency.

## NSB

Sync check 2026-11-17: NSB changed since 2026-11-15 only in VTW body-type tests and notes (Nelim is Female, VTW row, not shown in our shots), a seed path note for AB, the Roster.xlsx and the Beauty2 mouth values; no place, colonist or animal sheet the mod uses moved, so the read dates below stay (only opened files get a new date). NPT: nothing since 2026-11-16. No owner question, no included animal (the mod adds none). Earlier sync 2026-11-15: NSB changed since 2026-11-05 (decor, batches 5l and 5m, fixture z3, Beauty2 mouth patch): nothing the mod uses moved. Feature 16 loads `Nelims-tribe-decor-mods-z3` and frames Nelim's Sanctuary `bare-clearing` (still item 2 of GALERIE-ORDRE.md). NPT added a step that hides the main bar, the speed controls and the mouse-over readout (no description yet): not used, the Needs pane and the tip are the subject and the six gallery pictures are final.

Places read: 2026-11-15 Tribe read: 2026-11-22 (NSB since 2026-11-17: Jiro wardrobe photos, Miel and Soren roster steps, Iori beard, BiB gene renames: no Nelim, no cow, no clearing change; the step "Nelim has her own face" now sets MouthLipsSmirk instead of MouthSmirkSmile, same step text, canon smirk kept, not used by feature 16 captures as a new setup) (2026-11-17: VTW-BODYTYPES.md opened: Nelim is Female, VTW, temporary go for SaB, no effect on our outfit or shots) Steps read: 2026-11-22 (NPT since 2026-11-20: ClickDiagnostics log steps, animal made wild and designated for taming, "X faces Y" renamed "X turns toward Y": none used by feature 16, Check-Steps clean 1116 lines; 2026-11-20: NPT since 2026-11-19: date step used in scenes 4 and 5, "sun light dimmed, lamps kept" and the nth-button steps not needed; NSB unchanged) (NPT since 2026-11-18: only catalogue sets and def metadata batches for other mods, nothing CoL uses; before it, since 2026-11-17: only a face-parts catalogue note, ace6816b, vanilla face without Facial Animation, no vanilla mouth: not used; before it, Beauty2 mouth DY step b6dec3e: not used, cows and Nelim keep the default mouth)

| Place | Shots | Changes for the gallery | Last read |
|---|---|---|---|
| bare-clearing (195, 152) | 1 to 4 | TorchLamp (192, 154) lit, PlantPots, fully grown Plant_Daylily and Plant_YellowTallGrass (straw), moved between morning and evening, removed after each scene | 2026-11-15 |

| Colonist | Shots | Outfit | Last read | Exceptions |
|---|---|---|---|---|
| Nelim (in the save) | 1 to 4 in frame, mid-step; scene 5 sent to x 97 | none shown | 2026-11-15 | none |

| Animal | Shots | Outfit | Last read | Exceptions |
|---|---|---|---|---|
| Daisy (1), Buttercup (1, 2, 3, 4), Thistle (1, 2, 4) (anonymous Cow, named by the scenario) | 1 to 4 | none | 2026-11-15 (SANCTUAIRE-LIEUX: anonymous fauna, Vache 4, is decor) | none, no NSB name used |

| Animal the mod includes | Shots |
|---|---|
| none: the mod adds a need to existing livestock, no animal | n/a |

## Shotlist

Rewritten 2026-11-17 in the header of `16-publication-shots.feature` (4 story scenes and the settings window set aside) and the scenarios written from it; Check-Steps clean, Check-ShotlistVsScenario OK. Opus director pass kept: opener at hour 10, diptych with one subtitle per capture, Thistle the westmost cow away from the pots, hours 10, 12, 15 and 18 with two game hours played in scenes 2, 3 and 4, a recovered Thistle in the closing image, Nelim never standing still; refused: a standing pose at close range, a bare-ground fix by terrain (grown grass and daylilies used). NPT steps used (all in `steps.md`): UI scale, `I set the hour to`, camera head frame of two pawns, `I frame the area centred on`, plants fully grown, faces. Story: one day at Nelim's clearing, morning to evening, how a cow is kept shows in how fast it fills.

Plan score by `score-gallery` (no capture for this plan, stale 2026-11 captures of the old scenes are not rated): S1 5.0, S2 5.0, S3 5.0, S4 5.0, mean 5.0. Owner choice 2026-11-17 ("Drop the tip, UI 200"): no live tip in the opener, UI scale 200 in all four scenes, so the bar is a stripe at 268 px in each (S3 the thumbnail picture); the tip text stays in the settings scene. j of every scene is ok on paper and must be checked at rate-gallery with the 268 px reduction. k ok on the series: wide (1, 4), medium (2), close (3), opener and closing image, rhythm 10, 12, 15, 18.

| # | name | a time frame | b decor | c living | d pawn | e action | f composition | g subject | j mod at 268 px | plan |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | nelim-meets-her-cows (wide, UI 200) | clearing, 10:00, clear, +70 ticks | TorchLamp lit, 4 PlantPots, 2 Plant_Daylily, YellowTallGrass at the foot | Daisy front, Buttercup profile, Thistle from behind | yellow tunic, dark brown hair, canon smirk | Nelim mid-stride, one step from Daisy (forced walk, 40 ticks, pause) | wide, off-centre, pot and grass foreground | Nelim arrives at three cows, one at 72 percent | ok (stripe at UI 200, no tip) | 5.0 |
| 2 | buttercup-and-thistle (diptych) | 12:00 after two game hours | torch, 6 pots, daylily, grass | Buttercup front, Thistle profile | same outfit, mid-step toward them | forced walk to x 186 | medium, camera 3 cells right, UI 200 | same two hours, full bar then short bar | ok (stripe, full then short) | 5.0 |
| 3 | buttercup-up-close (close) | 15:00 (set 13, two hours) | pot, daylily, grass at her feet, torch edge | Buttercup front, full milk | same outfit, pleased, canon smirk | mid-step beside her (30 ticks) | head frame at root size 9, UI 200 | a content cow, full bar, her keeper | ok (thumbnail picture) | 5.0 |
| 4 | thistle-back-on-her-feet (closing, wide) | 18:00 (set 16, two hours), late light | torch the visible light, pots moved, daylily, grass | Daisy front, Thistle profile, Buttercup from behind | same outfit as scene 1 | Nelim walking away west to the torch | area (193, 152) at root size 9, UI 200 | the herd settled, Thistle at 60 percent | ok (stripe at UI 200) | 5.0 |

Main risks: UI scale 200 never played with these scenes, the big Needs pane may bury the cow under a big Needs pane, the hot-weather alert shows in S2, the tight head frame and the walk 30 ticks before the pause (S3) may blur Nelim, a recovered Thistle at 60 percent is staged. Subtitles (to write in PUBLICATION.md at shootGallery): 1 Nelim meets her three cows, and Daisy is settled. 2 Two hours later, Buttercup is full of milk. 3 Two hours later, Thistle is lagging behind. 4 Buttercup is content, so her milk fills at 140 percent of the usual rate. 5 By evening Thistle is back to 60 percent, and Nelim heads home. Gallery pictures 1 to 5 in `Art/Gallery/` are the 2026-09 pictures of the old scenes (stale): they go with a `git rm` when each scene is played (GALLERY.md, "Réécrire une scène").

## Gallery (2026-11-22, redo after the owner refusal of 2026-11-20)

Session verdicts by `score-gallery` (image 4.5, adequacy 4.5, understanding 4.5, decoration 4 on 2 to 5; 1 read by the session from the probe 342f, 6 is an interface shot). Clean originals in `Art/Gallery-clean/`, subtitled copies in `Art/Gallery/`, lines in `PUBLICATION.md` (Gallery subtitles). Upload order = story order, opener wide first. Nelim faces read at 5x on 4 and 5: no sweat drop, no heat blush.

| # | file | scene | verdict | subtitle |
|---|---|---|---|---|
| 0 | `0-preview.png` | Preview copy (byte-identical to `Mod/About/Preview.png`) | n/a | none |
| 1 | `1-nelim-meets-her-three-cows.jpg` | wide opener, 10h (probe 342f, Evidence/look-fix2-1) | candidate | yes |
| 2 | `2-buttercup-full-of-milk.jpg` | medium, 12h, well kept, full bar (diptych with 3) | candidate | yes |
| 3 | `3-thistle-lagging-behind.jpg` | medium, 12h, badly kept, short bar | candidate | yes |
| 4 | `4-buttercup-up-close.jpg` | close, 15h, front view, Nelim beside her | candidate | yes |
| 5 | `5-thistle-back-on-her-feet.jpg` | closing, 18h, tooltip on Thistle minor | candidate | yes |
| 6 | `6-settings-page.jpg` | interface window on window-backdrop-for-height, cropped 1416 x 1080 with the Daisy pane | accepted by the session | none (interface) |

Owner refusal of 2026-11-20 (no trousers, smile placement, wrong hairstyle, red face) is closed by the redo: look block in every scene, heat and blush removed by NPT (map 20 degrees, FacialAnimationPerformancePatch dropped from wsl-deps.studio.map). `gallery_validated_sha` absent; waits her oui on the whole gallery (AUDIT 9.f).

## Publication state

`PublishedFileId.txt` hold item 3806136625 (0.1.0, prepublished 2026-09-23, private). `CHANGELOG.md` keep
`## Unreleased` (1.0.0) above `## [0.1.0]`. Gallery: `Art/Gallery/0-preview.png` to `5-grass-and-kibble-cows-contentment-bars.jpg`,
indexes contiguous. Details and Steam description: `PUBLICATION.md`.

## What this mod taught the repository

- **Mod built against `Krafs.Rimworld.Ref` can be entirely dead, nothing in any log say so.** Reference assembly
  make game's non-public fields public, so code compile; access only legal at runtime under
  `IgnoresAccessChecksTo("Assembly-CSharp")`, which `Krafs.Publicizer` apply through generated AssemblyInfo, switched
  off here by `GenerateAssemblyInfo=false`. Fix is `Source/AccessChecks.cs`.
- **Test that catch it perform the access, not read metadata.** Verdict raised by CLR beat verdict
  read off attribute.
- After any bulk edit of this file, `grep -c '^---$' STATUS.md` return 2: unterminated front matter turn whole card
  into prose without any error.
