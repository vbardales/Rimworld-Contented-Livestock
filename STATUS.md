---
localization: complete
translation_en: complete
translation_fr: unchecked
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
automated_tests: 35 of 35 passed (rerun 2026-10-17 on 5775be9 against the shipped DLL C105BF9A830D66C7, after the removal of the slider default tick; before it, 2026-10-14 on 3655b90, DLL D2E97D352AE24E64); Tests/Pickle/Check-Steps.ps1 could not run (Pickle's CucumberExpressions.dll not found under the Windows Workshop folder), so the step expressions are unverified, not failing
pickle_scenarios: 51 defined; on the current DLL only the initial pass of 2026-10-10 (no optional mods, English, `-DepMap` omitted by mistake): 30 passed, 1 failed (scenario 02 trade, fixed, then green in replay 3 on 77ba6ef, 1 of 1, both captures opened), 20 skipped for missing companions (docs/runs/2026-10-10.md); older results: scenario 10 corrected rerun passed 1/1 (2026-09-24), feature 03 avec-rimmsqol 4 of 4 (2026-09-30, older DLL), 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented; 4 completed with reviewed media (0, 1, 6, 13); rule of 2026-09-25 (owner): she validates only what Claude cannot, so Claude's own verdict counts for what it can read. Validated by Claude on 2026-09-25 from opened captures: 3, 7, 9, 10, 11 (cow and sheep), 12, 16, and 4 and 15 for their machine-readable content; left for her eye: the reset confirmation window and slider caps of 15, and the four Workshop pictures (1 accepted, 4 sent); rerun done since: 5, 11 (hen), 15 (keyed clicks); 8 validated 2026-09-28 (growth staged: Desert tile); 14 out of scope. Table in docs/MANUAL-REVIEW.md
manual_visual_evidence: on disk, `Tests/Pickle/evidence/`, about 20 MB after the cut of 2026-10-02 (what stays and why: docs/runs/README.md "What to keep"). Nothing of this is in git.
remaining:
  - "unverified (owner, translation_fr): ChatGPT review of 2026-10-17 applied on her word in c93dbe1 (French text only, DLL unchanged): `Nelim_Contentment.description` says `malheureux` instead of `mal en point` (health is its own input); a second review the same day (applied on her word) rewrote `Tip.Halted` as `Bien-être insuffisant pour produire` (no subject to agree with) and `Settings.FloorTip` without the animal pronoun, and left description as is (agrees with the noun animal); a third review the same day (applied on her word) changed `temperature qu'il subit` to `temperature ambiante` in the description and `Settings.ConfirmReset` to `leurs valeurs par defaut` (kept `animaux a corde`, vanilla term unchecked). Owed read also covers those two, `Settings.FeedTip` says `végétaux crus et la viande` instead of `produits crus`; PUBLICATION.md section 6 now says six gallery pictures. `FRENCH_REVIEW.md` regenerated (7c5074b). Owed: her read of these three French texts, then scenario 15 (settings page) replayed in French (`Tip.Halted` reads in the need tip, not the settings page: check where it shows); `translation_fr` stays unchecked until then (text-only edit rule, TRANSLATIONS.md)."
  - "unverified (playTests 8.c, 8.f): pass 3 (feature 03 with RIMMSQOL, English, 2026-10-11) passed 4 of 4, capture not opened; scenario 02 (trade) passed 1 of 1 in replay 3 (2026-10-12, 77ba6ef) after three fixes of the step code, both captures opened: the dialog lists the muffalo at $420, and the bought muffalo shows its Contentment need (it still reads carried by the trader, its faction is the player); pass 2 (features 01 and 02, French, `-DepMap wsl-deps.runtime-evidence.map`, 2026-10-11) passed 6 of 6, `exitReason: passed`, and its capture (settings page in French: no raw key, no accented fallback, nothing clipped) was opened. Before it, only one pass had run on the current DLL (SHA256 starts 47556223324698BC: pen rule a042c76, then the grey default tick of 018c117): the initial pass of 2026-10-10, 30 of 51 passed, 1 red (scenario 02 trade: the step looked for the muffalo among spawned pawns, but a trader carries it unspawned; `Driver.PawnNamed` now also searches carried pawns, steps DLL rebuilt, replay alone owed), 20 skipped because it ran without `-DepMap wsl-deps.runtime-evidence.map` (ScreenshotMode and KeyedClick not staged): pass 1 of TESTING.md is to redo with that map. The @requires conditions are RIMMSQOL (features 03, 05, 06, 07), ScreenshotMode (02, 09, 10, 16, 03), FilmTicks (15), KeyedClick (22) and ScreenshotStudio (16); their last runs predate this DLL (feature 03 on 2026-09-30, restart chain and FilmTicks on 2026-09-24, KeyedClick on 2026-09-28, Workshop pictures on 2026-09-24/25). Two passes at least (without optional mods, with RIMMSQOL) and one pass per language."
  - "fixed 2026-10-17 in 5775be9 (owner: the grey default tick on the settings sliders reads as odd, sliders stay vanilla): `PercentRow` back to `Listing.SliderLabeled`, 35 of 35 tests pass, DLL C105BF9A830D66C7. Code review 8.m reopened by this Source change and closed the same day: diff 3655b90..5775be9 read whole, it only reverts 018c117 (and its docs line), so `code_review_sha` is 5775be9. The DLL changed: scenario 15 (settings page, EN) is owed as a small ticket on it, with `-DepMap wsl-deps.runtime-evidence.map`; every Pickle result of before proves nothing about C105BF9A830D66C7."
  - "waiting 2026-10-17 (playTests 8.c, 8.f, 8.h, 8.i), seven small tickets on 6329f8e, DLL C105BF9A830D66C7, none started: scenario 15 (20261017-163821-363-252d), health input alone (20261017-171859-722-90ac, the one red of the 2026-10-14 pass, step fix 018cd.. since), pass 3 RIMMSQOL (...171901-838-b938), pass 4 restart chain (...171903-726-188b), pass 6 FilmTicks (...171905-919-e79d), pass 2 French (...171907-896-bb85), settings restart chain (...171909-638-5204). Pass 7 (Workshop pictures) is for shootGallery. The 2026-10-14 pass read exitReason in-progress, 51 scenarios: partial, proves nothing about this DLL."
  - "unverified (playTests 8.k): manual scenarios not yet validated, see manual_scenarios and docs/MANUAL-REVIEW.md: slider caps of scenario 15 read by Claude in the capture of 2026-10-14 (validated 2026-10-17), the reset confirmation window accepted by the owner on 2026-10-17 (vanilla message box size, also accepted 2026-09-27); the two bar pictures of scenario 4 read at a glance, validated by Claude 2026-10-17 (grazer bar about four fifths, kibble bar about a quarter); left: the Workshop pictures (gallery, belong to shootGallery), no more manual validation owed to her."
  - "unverified (playTests 8.h, 8.i): settings and translated UI replayed in English and French on this DLL, raw keys, fallback text, clipping, Player.log; the reworded `Tip.Halted` and the seven French corrections of 2026-10-02 have been read in game in neither language."
  - "fixed 2026-10-14 in 3655b90 (playTests 8.m, code review of the first commit..5e43747, the 809 lines of Source/ read whole, no tag exists): `Patch_ShouldHaveNeed` now keeps the vanilla answer (`__result = __result && ...`, the developmental stage filter holds again) and the two production patches cap `fullness` and `eggProgress` at 1. The code changed, so the DLL is `D2E97D352AE24E64` and every Pickle result of before (the pass of 2026-10-13: 17 passed, 8 skipped, `exitReason: watchdog-timeout`, on the old DLL) proves nothing about it: pass 1 is redone on this DLL."
  - "verified 2026-10-10 (3.b): `dotnet build Source/ContentedLivestock.csproj` (with restore: `--no-restore` fails with MSB3644 here) rebuilt a DLL byte for byte identical to the shipped one, SHA256 47556223324698BC; since 3655b90 the shipped DLL is D2E97D352AE24E64 (rebuilt the same way, 0 errors)."
  - "unverified: Tests/Pickle/Check-Steps.ps1 cannot run here (Pickle's CucumberExpressions.dll is not in the Windows Workshop folder; Pickle runs in the WSL). Run it where Pickle's assemblies exist before shootGallery."
  - "unverified (owner): `Art/ModIcon-source.png` changed on 2026-10-04 and was newer than its derivatives. Regenerated 2026-10-10: `Mod/About/ModIcon.png` (128 x 128, contained on transparency as Render-Preview.cjs does, 35.9 KB, above the 20 to 30 KB band of AUDIT.md 2.b), `Art/ModIcon.ico` (six sizes), then `node ../scripts/Render-Preview.cjs` for `Mod/About/Preview.png`, `Art/Gallery/0-preview.png` and `Art/Preview.ico`. 2.c, legibility at 32 px, is for the owner to judge. Accepted by the owner on 2026-10-10 (the Preview with the new badge). On 2026-10-12 the echo became `Art/echo-source.png` (cow line art from her, 1536 x 1024, opened on a light background: clean strokes, real alpha), `Art/Preview.config.json` points at it (`echo.height` 133 for its 3:2 ratio, `flipX` kept), the Preview was rendered again and opened at full size and at 268 px: the cow sits beside the title without touching it and the title stays legible. `Art/Gallery/0-preview.png` is a byte copy. Sent as the GitHub social preview the same day: the repository `og:image` hashes to the recorded `social_preview_sha256`."
  - "prepared, not released (PUBLICATION.md): section 1 holds the full Steam description in BBCode, the dependency and content-box answers and three thanks drafts under 1000 characters. Publication goes through the CI (workflow generated 2026-09-24, 48 of 48 script tests passed, version 1.0.0). CHANGELOG.md keeps `## Unreleased` until the dry-run commit. Needs the tested gate, a presentation picture to redo (the cow with its tip: a stray tooltip, scene fixed, rerun owed), the owner's review of PUBLICATION.md and CHANGELOG.md for the 1.0 line, and a yes for the tag and the GitHub release. Not before shootGallery."
  - "unverified: `tested_on` stays empty until a green in-game pass records the game and integration versions."
session:      72f45cb8-7e45-4dea-bfa8-11aee1b7b75b
updated:      2026-10-10, audit against the AUDIT.md of 2026-10-10: done becomes playTests[1.0.0], _tools/ moved to scripts/, journal moved to docs/runs/, icon derivatives and Preview regenerated, FRENCH_REVIEW.md regenerated by the shared script
echo_review_sha: 52dc06db37ac2d4bdb7f82062f87fa71d9d8c9c2
social_preview_sha256: c2b2072ac4411e541d4030d81425085cee2b5b92a6c0c243ca5bb5ec875254cb
code_review_sha: 5775be9648fbb9af076c1412151b09046c88b7c3
protocols_read_sha: 78bf85cc96d564b99ea1a0e122ba9beb10d77268
---
# Contented Livestock: status

Dated journal of earlier audits (2026-09-12 to 2026-10-02) verbatim in
[docs/runs/status-journal-until-2026-10-10.md](docs/runs/status-journal-until-2026-10-10.md). This file keep current state only.

## Workflow audit: 2026-10-10

**Old state `done`, state retained `playTests[1.0.0]`** (table of AUDIT.md section 16 give `done` as `playTests`;
target version 1.0.0, content of `## Unreleased` in `CHANGELOG.md`). Revision audited:
`5fbc56736e3477a3f5a8b1600e3a7427749ff80d`. Working tree at audit start: three modified files under `Art/`
(`ModIcon-source.png`, `ModIcon.ico`, `Preview.ico`), left by owner. This audit's own edits listed below.

Checked directly, not from this file:

- **Transitions 1 to 7 hold.** `Mod/` carry `About.xml`, `ModIcon.png`, `Preview.png`, `PublishedFileId.txt`, DLL; no
  `.ico`, no `.dds`, no `desktop.ini` tracked. Old `stage` field removed (retired 2026-10-09).
- **Tests (7.b, 7.c).** `scripts/Run-Functional-Tests.ps1`: 35 of 35 passed 2026-10-10, before and after move
  of `_tools/` to `scripts/` (XML parse, key parity, parameters in EN and FR included).
- **Scenarios (7.a).** 18 manual scenarios in `scripts/TEST_SCENARIOS.md` (name AUDIT.md 7.a give).
- **Pickle suites (7.d).** `Tests/Pickle/` carry 24 scenarios, written; `TESTING.md` declare passes.
- **Translations (7.g).** `translation_fr: complete` rest on Virginie's review of 2026-10-02 (revision `dadebc2`, 7
  corrections applied). No agreement with pawn's gender in texts, so no `{PAWN_gender}` switch apply.
  U+2014 (em dash, rule of 2026-10-10): none in `About.xml` or Steam description (`Check-Status.ps1` warn there, say 0). Older files still carry some (README, ATTRIBUTION, FRENCH_REVIEW, `Mod/Languages/{English,French}/Keyed`, comments in `Source/`): rule is for text written from now on; two French and three English player-facing strings are text change needing Virginie's review, so left (recommendation below). Earlier version of this line said none, from `grep -P` that failed silently. Mod has no counted noun
  phrase, so no `.One` or `.Many` family needed.
- **Mod root.** No `.XXX` or `_XXX` entry left except `.git`, `.gitignore`, `.github`: `_tools/` now `scripts/`
  (history kept with `git mv`) and `.build/` renamed `build/` (owner rule 2026-10-10, PUBLISHING.md) and emptied. Build intermediates go to `build/`, ignored; props, .gitignore and
  scratch of `scripts/Settings-Tests.ps1` follow. Redirect
  `_tools/preview.html` (target `Art/preview.html` not exist) removed. `scripts/results/` kept: dated 2026-09-13 records cited by journal.
- **French review file.** `FRENCH_REVIEW.md` regenerated by shared `../scripts/Make-FrenchReview.ps1` (title with mod name, repository type `original`, revision `742a881`); French texts unchanged. Mod's own
  `scripts/Generate-FrenchReview.ps1` removed.
- **Art (2.b).** ModIcon source newer than derivatives: regenerated, see `remaining`.

Why not `shootGallery`: nothing of playTests ran on current DLL (see `remaining`). Audit not launch game; passes go through Ticket Manager.

Next transition, strictly (AUDIT.md section 8): one initial Pickle ticket play all scenarios, then each red
scenario alone; conditional scenarios on their passes; in-game settings and EN and FR interface; remaining manual validations; code review (8.m); `tested_on`.

Recommendations, not blockers: replace em dashes of player-facing strings in `Mod/Languages/*/Keyed/ContentedLivestock.xml` at next text change, with her review; bring `ModIcon.png` under 30 KB if owner want band respected (was 32.5 KB before, also above). Scenario file is `scripts/TEST_SCENARIOS.md` since 2026-10-11 (AUDIT.md 7.a name, asked by Audit workflow session).

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
resolve to nonempty EN and FR text (35-test suite). **French review line:** reviewer Virginie, 2026-10-02, French files
as of revision `dadebc2`, 7 corrections requested and applied, no dynamic gender agreement needed, `translation_fr:
complete`. `Tip.Halted` rewording of 2026-09-25 in both languages; in-game reading part of playTests.

## Dependencies and integrations (audit 2026-10-02, revalidated for the declared state on 2026-10-10)

Required: `brrainz.harmony`. Optional integration: RIMMSQOL (reveal hidden shortcut), exercised by
`avec-rimmsqol` pass. Pickle and companions development only. Mod add no animal, patch no other mod, so
four animal integrations of `ANIMALS.md` not apply. No DLC dependency.

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