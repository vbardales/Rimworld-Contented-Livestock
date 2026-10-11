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
workflow_stage: playTests[1.0.0]
audit_revision: 5fbc56736e3477a3f5a8b1600e3a7427749ff80d
audit_date: 2026-10-10
licence:      original
license_spdx: MIT
licence_at:   an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the `LICENSE` is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic is Stardew Valley's, credited in ATTRIBUTION.md and reused from none of its lines.
upstream_mod_remotes: N/A
dependencies: "brrainz.harmony (required); RIMMSQOL optional, Pickle integration and restart persistence passed"
showcase:     complete
tested_on:
workshop:     "3806136625 (0.1.0; visibility and subscription test unverified)"
automated_tests: 35 of 35 passed (rerun 2026-10-10 on 5fbc567 after the move of _tools/ to scripts/, against the shipped DLL 47556223324698BC); Tests/Pickle/Check-Steps.ps1 could not run (Pickle's CucumberExpressions.dll not found under the Windows Workshop folder), so the step expressions are unverified, not failing
pickle_scenarios: 51 defined; on the current DLL only the initial pass of 2026-10-10 (no optional mods, English, `-DepMap` omitted by mistake): 30 passed, 1 failed (scenario 02 trade, step lookup, fixed, replay owed), 20 skipped for missing companions (docs/runs/2026-10-10.md); older results: scenario 10 corrected rerun passed 1/1 (2026-09-24), feature 03 avec-rimmsqol 4 of 4 (2026-09-30, older DLL), 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented; 4 completed with reviewed media (0, 1, 6, 13); rule of 2026-09-25 (owner): she validates only what Claude cannot, so Claude's own verdict counts for what it can read. Validated by Claude on 2026-09-25 from opened captures: 3, 7, 9, 10, 11 (cow and sheep), 12, 16, and 4 and 15 for their machine-readable content; left for her eye: the reset confirmation window and slider caps of 15, and the four Workshop pictures (1 accepted, 4 sent); rerun done since: 5, 11 (hen), 15 (keyed clicks); 8 validated 2026-09-28 (growth staged: Desert tile); 14 out of scope. Table in docs/MANUAL-REVIEW.md
manual_visual_evidence: on disk, `Tests/Pickle/evidence/`, about 20 MB after the cut of 2026-10-02 (what stays and why: docs/runs/README.md "What to keep"). Nothing of this is in git.
remaining:
  - "unverified (playTests 8.c, 8.f): only one pass has run on the current DLL (SHA256 starts 47556223324698BC: pen rule a042c76, then the grey default tick of 018c117): the initial pass of 2026-10-10, 30 of 51 passed, 1 red (scenario 02 trade: the step looked for the muffalo among spawned pawns, but a trader carries it unspawned; `Driver.PawnNamed` now also searches carried pawns, steps DLL rebuilt, replay alone owed), 20 skipped because it ran without `-DepMap wsl-deps.runtime-evidence.map` (ScreenshotMode and KeyedClick not staged): pass 1 of TESTING.md is to redo with that map. The @requires conditions are RIMMSQOL (features 03, 05, 06, 07), ScreenshotMode (02, 09, 10, 16, 03), FilmTicks (15), KeyedClick (22) and ScreenshotStudio (16); their last runs predate this DLL (feature 03 on 2026-09-30, restart chain and FilmTicks on 2026-09-24, KeyedClick on 2026-09-28, Workshop pictures on 2026-09-24/25). Two passes at least (without optional mods, with RIMMSQOL) and one pass per language."
  - "unverified (playTests 8.k): manual scenarios not yet validated, see manual_scenarios and docs/MANUAL-REVIEW.md: the reset confirmation window and slider caps of scenario 15, and the Workshop pictures."
  - "unverified (playTests 8.h, 8.i): settings and translated UI replayed in English and French on this DLL, raw keys, fallback text, clipping, Player.log; the reworded `Tip.Halted` and the seven French corrections of 2026-10-02 have been read in game in neither language."
  - "unverified (playTests 8.m): code review not done, `code_review_sha` absent. Review 0.1.0..HEAD once, at the end of playTests, when the code is stable and played."
  - "verified 2026-10-10 (3.b): `dotnet build Source/ContentedLivestock.csproj` (with restore: `--no-restore` fails with MSB3644 here) rebuilds a DLL byte for byte identical to the shipped one, SHA256 starts 47556223324698BC."
  - "unverified: Tests/Pickle/Check-Steps.ps1 cannot run here (Pickle's CucumberExpressions.dll is not in the Windows Workshop folder; Pickle runs in the WSL). Run it where Pickle's assemblies exist before shootGallery."
  - "unverified (owner): `Art/ModIcon-source.png` changed on 2026-10-04 and was newer than its derivatives. Regenerated 2026-10-10: `Mod/About/ModIcon.png` (128 x 128, contained on transparency as Render-Preview.cjs does, 35.9 KB, above the 20 to 30 KB band of AUDIT.md 2.b), `Art/ModIcon.ico` (six sizes), then `node ../scripts/Render-Preview.cjs` for `Mod/About/Preview.png`, `Art/Gallery/0-preview.png` and `Art/Preview.ico`. 2.c, legibility at 32 px, is for the owner to judge and the new Preview badge is for her eye (STYLE_RIMWORLD.md)."
  - "prepared, not released (PUBLICATION.md): section 1 holds the full Steam description in BBCode, the dependency and content-box answers and three thanks drafts under 1000 characters. Publication goes through the CI (workflow generated 2026-09-24, 48 of 48 script tests passed, version 1.0.0). CHANGELOG.md keeps `## Unreleased` until the dry-run commit. Needs the tested gate, a presentation picture to redo (the cow with its tip: a stray tooltip, scene fixed, rerun owed), the owner's review of PUBLICATION.md and CHANGELOG.md for the 1.0 line, and a yes for the tag and the GitHub release. Not before shootGallery."
  - "unverified (mountPreview 10.f): `social_preview_sha256` not recorded. The repository is public: send `Mod/About/Preview.png` as the GitHub social preview after the Preview is accepted, then record the sha256."
  - "unverified: `tested_on` stays empty until a green in-game pass records the game and integration versions."
session:      8f889417-0818-4ca5-a904-18eca3503de7
updated:      2026-10-10, audit against the AUDIT.md of 2026-10-10: done becomes playTests[1.0.0], _tools/ moved to scripts/, journal moved to docs/runs/, icon derivatives and Preview regenerated, FRENCH_REVIEW.md regenerated by the shared script
protocols_read_sha: a5c7cf48b349ae00e7d28fd643e852dc860dfaf2
---

# Contented Livestock: status

The dated journal of earlier audits (2026-09-12 to 2026-10-02) is verbatim in
[docs/runs/status-journal-until-2026-10-10.md](docs/runs/status-journal-until-2026-10-10.md). This file keeps the
current state only.

## Workflow audit: 2026-10-10

**Old state `done`, state retained `playTests[1.0.0]`** (the table of AUDIT.md section 16 gives `done` as `playTests`;
the target version is 1.0.0, the content of `## Unreleased` in `CHANGELOG.md`). Revision audited:
`5fbc56736e3477a3f5a8b1600e3a7427749ff80d`. Working tree at audit start: three modified files under `Art/`
(`ModIcon-source.png`, `ModIcon.ico`, `Preview.ico`), left by the owner. This audit's own edits are listed below.

Checked directly, not from this file:

- **Transitions 1 to 7 hold.** `Mod/` carries `About.xml`, `ModIcon.png`, `Preview.png`, `PublishedFileId.txt`, the DLL; no
  `.ico`, no `.dds`, no `desktop.ini` is tracked. The old `stage` field is removed (retired 2026-10-09).
- **Tests (7.b, 7.c).** `scripts/Run-Functional-Tests.ps1`: 35 of 35 passed on 2026-10-10, before and after the move
  of `_tools/` to `scripts/` (XML parse, key parity and parameters in EN and FR included).
- **Scenarios (7.a).** The 18 manual scenarios are in `scripts/TEST_SCENARIOS.md` (the name AUDIT.md 7.a gives).
- **Pickle suites (7.d).** `Tests/Pickle/` carries 24 scenarios, written; `TESTING.md` declares the passes.
- **Translations (7.g).** `translation_fr: complete` rests on Virginie's review of 2026-10-02 (revision `dadebc2`, 7
  corrections applied). No agreement with a pawn's gender exists in the texts, so no `{PAWN_gender}` switch applies.
  No U+2014 character in the repository documents, in `About.xml` or in `Languages/`. The mod has no counted noun
  phrase, so no `.One` or `.Many` family is needed.
- **Mod root.** No `.XXX` or `_XXX` entry is left except `.git`, `.gitignore`, `.github`: `_tools/` is now `scripts/`
  (history kept with `git mv`) and `.build/` is renamed `build/` (owner rule of 2026-10-10, PUBLISHING.md) and emptied. Build intermediates go to `build/`, ignored; props, .gitignore and
  the scratch of `scripts/Settings-Tests.ps1` follow. The redirect
  `_tools/preview.html` (target `Art/preview.html` does not exist) is removed. `scripts/results/` is kept: the
  dated 2026-09-13 records are cited by the journal.
- **French review file.** `FRENCH_REVIEW.md` regenerated by the shared `../scripts/Make-FrenchReview.ps1` (title with the
  mod name, repository type `original`, revision `742a881`); the French texts are unchanged. The mod's own
  `scripts/Generate-FrenchReview.ps1` is removed.
- **Art (2.b).** The ModIcon source was newer than its derivatives: regenerated, see `remaining`.

Why not `shootGallery`: nothing of playTests has run on the current DLL (see `remaining`). The audit does not launch the
game; the passes go through the Ticket Manager.

Next transition, strictly (AUDIT.md section 8): one initial Pickle ticket that plays all scenarios, then each red
scenario alone; the conditional scenarios on their passes; the in-game settings and the EN and FR interface; the
remaining manual validations; the code review (8.m); `tested_on`.

Recommendation, not a blocker: bring `ModIcon.png` under 30 KB if the owner wants the band respected (it was 32.5 KB before, also above). The scenario file is `scripts/TEST_SCENARIOS.md` since 2026-10-11 (AUDIT.md 7.a name, asked by the Audit workflow session).

## Settings audit

Complete for the technical gate (2026-09-13, rechecked by the automated tests on 2026-10-10). Eleven useful settings, in
native Mod options (**Options de mod, Contented Livestock**), no dependency on RIMMSQOL. The MainButtons shortcut
`Nelim_ContentedLivestockSettings` is hidden by default (`buttonVisible=false`), opens the same
`Dialog_ModSettings` and persistence, and is revealed by RIMMSQOL (Pickle: reveal, open, hide, forget, persistence
across processes, passed 2026-09-24 and 2026-09-30). `Normalize()` bounds every slider and treats NaN and infinity as
defaults; the settings save on close and apply when play resumes; scope is global. The 35 tests cover defaults, bounds,
the 32 input-toggle combinations, rate and speed curves, real Scribe save and load, older files and the shortcut
contract. In-game checks, then the EN and FR replay (`passed`), belong to playTests: see `remaining`. The full record
of 2026-09-13 is in the journal.

## Translation audit

Where the text lives: `Mod/Languages/{English,French}/Keyed/ContentedLivestock.xml` and
`Mod/Languages/French/DefInjected/{NeedDef/Needs_Contentment.xml,MainButtonDef/MainButtons_ContentedLivestock.xml}`
(three files, listed with every row in `FRENCH_REVIEW.md`). Inventory from the shipped XML and the source; every key
resolves to nonempty EN and FR text (35-test suite). **French review line:** reviewer Virginie, 2026-10-02, French files
as of revision `dadebc2`, 7 corrections requested and applied, no dynamic gender agreement needed, `translation_fr:
complete`. The `Tip.Halted` rewording of 2026-09-25 is in both languages; its in-game reading is part of playTests.

## Dependencies and integrations (audit 2026-10-02, revalidated for the declared state on 2026-10-10)

Required: `brrainz.harmony`. Optional integration: RIMMSQOL (reveals the hidden shortcut), exercised by the
`avec-rimmsqol` pass. Pickle and its companions are development only. The mod adds no animal and patches no other mod, so
the four animal integrations of `ANIMALS.md` do not apply. No DLC dependency.

## Publication state

`PublishedFileId.txt` holds item 3806136625 (0.1.0, prepublished 2026-09-23, private). `CHANGELOG.md` keeps
`## Unreleased` (1.0.0) above `## [0.1.0]`. Gallery: `Art/Gallery/0-preview.png` to `5-grass-and-kibble-cows-contentment-bars.jpg`,
indexes contiguous. Details and the Steam description: `PUBLICATION.md`.

## What this mod taught the repository

- **A mod built against `Krafs.Rimworld.Ref` can be entirely dead with nothing in any log to say so.** The reference assembly
  makes the game's non-public fields public, so the code compiles; the access is only legal at runtime under
  `IgnoresAccessChecksTo("Assembly-CSharp")`, which `Krafs.Publicizer` applies through the generated AssemblyInfo, switched
  off here by `GenerateAssemblyInfo=false`. The fix is `Source/AccessChecks.cs`.
- **The test that catches it performs the access, it does not read metadata.** A verdict raised by the CLR beats a verdict
  read off an attribute.
- After any bulk edit of this file, `grep -c '^---$' STATUS.md` returns 2: an unterminated front matter turns the whole card
  into prose without any error.
