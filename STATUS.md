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
automated_tests: 33 of 33 passed plus Check-HarmonyContract 6 of 6 (2026-11-02, the 35 of before minus the two tests moved to that shared check; 35 of 35 rerun on 03da150 after the harness came back under Tests/Run-Functional-Tests.ps1, `-HarmonyPath` default now the 1.6 Assemblies folder; before, rerun 2026-10-17 after the French text corrections, on 1218fe6, `-HarmonyPath` the Workshop Harmony 1.6 Assemblies folder, DLL unchanged C105BF9A830D66C7; before, 2026-10-17 on 5775be9 against the shipped DLL C105BF9A830D66C7, after the removal of the slider default tick; before it, 2026-10-14 on 3655b90, DLL D2E97D352AE24E64); step expressions checked 2026-11-02 by the shared scripts/Check-Steps.ps1 (106 compile, see remaining)
pickle_scenarios: 51 defined; on the current DLL only the initial pass of 2026-10-10 (no optional mods, English, `-DepMap` omitted by mistake): 30 passed, 1 failed (scenario 02 trade, fixed, then green in replay 3 on 77ba6ef, 1 of 1, both captures opened), 20 skipped for missing companions (docs/runs/2026-10-10.md); older results: scenario 10 corrected rerun passed 1/1 (2026-09-24), feature 03 avec-rimmsqol 4 of 4 (2026-09-30, older DLL), 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented; 4 completed with reviewed media (0, 1, 6, 13); rule of 2026-09-25 (owner): she validates only what Claude cannot, so Claude's own verdict counts for what it can read. Validated by Claude on 2026-09-25 from opened captures: 3, 7, 9, 10, 11 (cow and sheep), 12, 16, and 4 and 15 for their machine-readable content; left for her eye: the reset confirmation window and slider caps of 15, and the four Workshop pictures (1 accepted, 4 sent); rerun done since: 5, 11 (hen), 15 (keyed clicks); 8 validated 2026-09-28 (growth staged: Desert tile); 14 out of scope. Table in docs/MANUAL-REVIEW.md
manual_visual_evidence: none kept on disk (2026-10-18, owner rule: Tests/Pickle/Evidence/ holds minified proofs only, under 2 MB; runs land in Tests/Pickle/Inbox/). History is one line per run in docs/runs/. Nothing of this is in git.
remaining:
  - "done 2026-11-06: Preview redone on the new config format (layout panel top-left, icon bottom-right, accepted by the owner, commit c1ea64f), uploaded as the GitHub social preview via Chrome, og:image hash equals social_preview_sha256."
  - "pass4-chain-8 result (2026-11-09, read, folder deleted): ticket f2f1 (hetzner lane, first chain on a server) exit 8 at launch 1, 46 s, `exitReason: infrastructure-error`, 0 scenarios. Player.log: `System.InvalidOperationException: pickle: filter '05' matched no scenarios` on a server Pickle whose suite list shows 27 features of this mod incl. `05-rimmsqol-restart-reveal.feature`. Filter `05` is the same string that matched on the local lane (3935, 05 passed 2026-11-06), so the server Pickle or its filter resolution is the suspect, not the mod. TM told, evidence stays with TM/Cloud decision. Refile only after Cloud answers (or with `-Filter 05-rimmsqol-restart-reveal.feature` if Cloud says the server needs a feature path)."
  - "superseded hold 2026-11-08: pass4-chain-7 (ac97) ended exit 8 on the local lane (`no scenario matched or watchdog`, 0 scenarios, RAM 0.9 to 1.6 GB free, 5 GB needed), folder deleted. Cloud: a `-Then` chain cannot run on azure or hetzner (Run-PickleWsl.ps1 refuses it, exit 1), Submit-PickleRun forces the local WSL path with no RAM gate. Splitting 05, 06, 07 is wrong (06 reads the marker of 05). Refile `-Filter 05 -Then '06','07' -NoBatch -DepMap wsl-deps.avec-rimmsqol.map` only when Virginie says RAM is free (about 5 GB), or after remote sequences exist (Cloud, only on her order)."
  - "pass4-chain-6 result (2026-11-08, read, folder deleted): ticket ee00 (runner wsl, lane local) ended exit 8 at launch 1, 46 s, `exitReason: infrastructure-error`, 0 scenarios; Player.log ends in the same Unity allocator dump (failed allocations) as 4b80. Cause RAM, not the mod, not the filter. TM then said refile myself, runner auto (local lane out of auto, goes to azure or hetzner), priority 3: pass4-chain-7 filed 2026-11-08, ticket 20261108-205946-082-ac97, same args as 4b80, evidence Tests/Pickle/Inbox/pass4-chain-7, tree 7503a6d. Wait for RUN_DONE."
  - "pass4-chain-5 result (2026-11-08, read, folder deleted): ticket 4b80 ended exit 8 at launch 1, 3 min, `exitReason: infrastructure-error`, 0 scenarios, Pickle itself exit 2; Player.log ends in Unity allocator dump (failed allocations), host free RAM 1 GB of 15.5 GB at 2026-11-08. Cause infra (RAM), not the filter, not the mod. Was HOLD, refiled as chain-6 on TM word: refile the chain (`-Filter 05 -Then '06','07' -NoBatch -DepMap wsl-deps.avec-rimmsqol.map`) only when free RAM is back (TM or Cloud say so). pass4-chain-4 (ca0d) also deleted. Before: pass4-chain-5 (2026-11-07): ticket 20261107-164851-890-4b80, `-Filter 05 -Then '06','07' -NoBatch -DepMap wsl-deps.avec-rimmsqol.map`, three launches. Why: ca0d (`-Filter 06 -Then 07`) failed at launch 1, `read reveal, hide and keep` found no kept-choices marker (06 reads what 05 writes, 05 must run first in the same run); my refile error, not a mod fault. Earlier: pass4-chain-3 (3935, 143 cured): 05 passed, 06 passed, 07 failed only by harness refusal (06,07 joined into one launch: comma inside one -Then string = OR, one launch). Refiled as -Filter 06 -Then 07: ticket 20261106-161848-057-ca0d, evidence Tests/Pickle/Inbox/pass4-chain-4 (to delete). Earlier: refiled 2026-11-06 after TM lifted hold (cause: remote lane watch loop killed local game between -Then sequences, fixed by Cloud): ticket 20261106-154358-516-3935, evidence Tests/Pickle/Inbox/pass4-chain-3, 05 then 06, 07 as -Then. Earlier: HOLD, ticket 6d6e (pass4-chain-2) ended exit 143 too (12.9 min, no report, log in Tests/Pickle/Inbox/pass4-chain-2/seq2); second 143 after 2bd5, infra (concurrent remote lanes, host RAM 271-421 MB free), TM sent it to Cloud. Do not refile until TM says a cause is found or RAM changes; if forced, one launch only. Ticket 6d6e: refiled 2026-11-06 (owner local_f83239cd, tree aa175d4, evidence Tests/Pickle/Inbox/pass4-chain-2) after 2bd5 ended exit 143 (game terminated, infra, no verdict). Original 2bd5 (owner local_72f45cb8): RIMMSQOL restart chain 05, 06, 07, one launch each, `-DepMap wsl-deps.avec-rimmsqol.map`, evidence Tests/Pickle/Inbox/pass4-chain. Why: pass 4 replay `bbcc` (Tests/Pickle/Inbox/pass4-replay, exit 1) failed `read hide and forget` only by harness refusal, 06 and 07 ran in one launch; not a mod fault. After RUN_DONE: read summary.json and junit.xml, then file the initial pass 1 on the current DLL (51 scenarios, `-DepMap wsl-deps.runtime-evidence.map`, once), then the small tickets for scenarios still red; scenario 15 in French passed 4 of 4 (`d634`, Tests/Pickle/Inbox/scenario15-french), digest and minify both; then 8.l tested_on, 8.d captures, 8.n."
  - "verified 2026-11-02 (playTests 8.m): diff 5775be9..867d8b7 of Mod/ and Source/ read whole, six lines of French text in Keyed/ContentedLivestock.xml and DefInjected/NeedDef/Needs_Contentment.xml, keys and {0} tokens unchanged, no Source change, no defect; code_review_sha is 867d8b7. Still owed for playTests: 8.c pass 4 replay in two launches and scenario 15 in French (8.h), 8.l tested_on."
  - "verified 2026-10-17 (owner, translation_fr): after five ChatGPT reviews of the day, applied on her word (c93dbe1 to 3aa4ac7, text only, DLL unchanged), she read and validated the changed French texts (`Nelim_Contentment.description`, `Tip.Halted`, `Settings.FeedTip`, `Settings.FloorTip`, `Settings.ConfirmReset`) and PUBLICATION.md section 6. `translation_fr` is complete again. Then, on her word, one search of the vanilla French pack (`Keyed/Alerts.xml`, `Keyed/Misc_Gameplay.xml`): the game says `animaux attachés` and `Attaché à cet endroit` (RopedToSpot), never `à corde`, so `Settings.SpaceTip` now says `On juge les animaux attachés sur leur enclos` (impersonal, her choice, `On juge les autres` for the rest) (commit after b60126d); she read and validated that line the same day (revision 77756c9), `translation_fr` is complete. Owed: scenario 15 replayed in French on this text, with the waiting tickets; `Tip.Halted` shows in the need tip, check where it reads."
  - "unverified (playTests 8.c, 8.f): pass 3 (feature 03 with RIMMSQOL, English, 2026-10-11) passed 4 of 4, capture not opened; scenario 02 (trade) passed 1 of 1 in replay 3 (2026-10-12, 77ba6ef) after three fixes of the step code, both captures opened: the dialog lists the muffalo at $420, and the bought muffalo shows its Contentment need (it still reads carried by the trader, its faction is the player); pass 2 (features 01 and 02, French, `-DepMap wsl-deps.runtime-evidence.map`, 2026-10-11) passed 6 of 6, `exitReason: passed`, and its capture (settings page in French: no raw key, no accented fallback, nothing clipped) was opened. Before it, only one pass had run on the current DLL (SHA256 starts 47556223324698BC: pen rule a042c76, then the grey default tick of 018c117): the initial pass of 2026-10-10, 30 of 51 passed, 1 red (scenario 02 trade: the step looked for the muffalo among spawned pawns, but a trader carries it unspawned; `Driver.PawnNamed` now also searches carried pawns, steps DLL rebuilt, replay alone owed), 20 skipped because it ran without `-DepMap wsl-deps.runtime-evidence.map` (ScreenshotMode and KeyedClick not staged): pass 1 of TESTING.md is to redo with that map. The @requires conditions are RIMMSQOL (features 03, 05, 06, 07), ScreenshotMode (02, 09, 10, 16, 03), FilmTicks (15), KeyedClick (22) and ScreenshotStudio (16); their last runs predate this DLL (feature 03 on 2026-09-30, restart chain and FilmTicks on 2026-09-24, KeyedClick on 2026-09-28, Workshop pictures on 2026-09-24/25). Two passes at least (without optional mods, with RIMMSQOL) and one pass per language."
  - "fixed 2026-10-17 in 5775be9 (owner: the grey default tick on the settings sliders reads as odd, sliders stay vanilla): `PercentRow` back to `Listing.SliderLabeled`, 35 of 35 tests pass, DLL C105BF9A830D66C7. Code review 8.m reopened by this Source change and closed the same day: diff 3655b90..5775be9 read whole, it only reverts 018c117 (and its docs line), so `code_review_sha` is 5775be9. The DLL changed: scenario 15 (settings page, EN) is owed as a small ticket on it, with `-DepMap wsl-deps.runtime-evidence.map`; every Pickle result of before proves nothing about C105BF9A830D66C7."
  - "results 2026-10-17 (playTests 8.c, 8.f, 8.h, 8.i), seven small tickets on 6329f8e, DLL C105BF9A830D66C7, read 2026-10-18 from summary.md and junit.xml, evidence folder deleted after: scenario 15 (252d) 4 of 4 passed; health input alone (90ac) 1 of 1 passed; pass 3 RIMMSQOL (b938) 4 of 4 passed; pass 4 restart chain (188b) seq1 1 of 1 passed, seq2 1 passed and 1 failed (`read hide and forget`: harness refusal, the two features ran in one launch, not a mod fault; replay as two launches, `-Filter <first> -Then <second>`); pass 6 FilmTicks (e79d) 1 of 1 passed; pass 2 French (bb85) 6 of 6 passed; settings restart chain (5204) 2 of 2 passed. Captures not opened. Owed: pass 4 replay, scenario 15 in French. Pass 7 (Workshop pictures) is for shootGallery. The 2026-10-14 pass read exitReason in-progress, 51 scenarios: partial, proves nothing about this DLL."
  - "unverified (playTests 8.k): manual scenarios not yet validated, see manual_scenarios and docs/MANUAL-REVIEW.md: slider caps of scenario 15 read by Claude in the capture of 2026-10-14 (validated 2026-10-17), the reset confirmation window accepted by the owner on 2026-10-17 (vanilla message box size, also accepted 2026-09-27); the two bar pictures of scenario 4 read at a glance, validated by Claude 2026-10-17 (grazer bar about four fifths, kibble bar about a quarter); left: the Workshop pictures (gallery, belong to shootGallery), no more manual validation owed to her."
  - "unverified (playTests 8.h, 8.i): settings and translated UI replayed in English and French on this DLL, raw keys, fallback text, clipping, Player.log; the reworded `Tip.Halted` and the seven French corrections of 2026-10-02 have been read in game in neither language."
  - "fixed 2026-10-14 in 3655b90 (playTests 8.m, code review of the first commit..5e43747, the 809 lines of Source/ read whole, no tag exists): `Patch_ShouldHaveNeed` now keeps the vanilla answer (`__result = __result && ...`, the developmental stage filter holds again) and the two production patches cap `fullness` and `eggProgress` at 1. The code changed, so the DLL is `D2E97D352AE24E64` and every Pickle result of before (the pass of 2026-10-13: 17 passed, 8 skipped, `exitReason: watchdog-timeout`, on the old DLL) proves nothing about it: pass 1 is redone on this DLL."
  - "verified 2026-10-10 (3.b): `dotnet build Source/ContentedLivestock.csproj` (with restore: `--no-restore` fails with MSB3644 here) rebuilt a DLL byte for byte identical to the shipped one, SHA256 47556223324698BC; since 3655b90 the shipped DLL is D2E97D352AE24E64 (rebuilt the same way, 0 errors)."
  - "checked 2026-11-02: the local Tests/Pickle/Check-Steps.ps1 copy is removed, the shared scripts/Check-Steps.ps1 runs here: 27 feature files parse, 106 patterns compile, 882 step lines resolve. One problem left: feature 16 (publication-shots) uses steps of PickleTools ClickDiagnostics, CoatSteps and StageDecor, has no @requires tag for them, and no wsl-deps.*.map stages nelim.pickletools.clickdiagnostics. Settle before shootGallery."
  - "unverified (owner): `Art/ModIcon-source.png` changed on 2026-10-04 and was newer than its derivatives. Regenerated 2026-10-10: `Mod/About/ModIcon.png` (128 x 128, contained on transparency as Render-Preview.cjs does, 35.9 KB, above the 20 to 30 KB band of AUDIT.md 2.b), `Art/ModIcon.ico` (six sizes), then `node ../scripts/Render-Preview.cjs` for `Mod/About/Preview.png`, `Art/Gallery/0-preview.png` and `Art/Preview.ico`. 2.c, legibility at 32 px, is for the owner to judge. Accepted by the owner on 2026-10-10 (the Preview with the new badge). On 2026-10-12 the echo became `Art/echo-source.png` (cow line art from her, 1536 x 1024, opened on a light background: clean strokes, real alpha), `Art/Preview.config.json` points at it (`echo.height` 133 for its 3:2 ratio, `flipX` kept), the Preview was rendered again and opened at full size and at 268 px: the cow sits beside the title without touching it and the title stays legible. `Art/Gallery/0-preview.png` is a byte copy. Sent as the GitHub social preview the same day: the repository `og:image` hashes to the recorded `social_preview_sha256`."
  - "prepared, not released (PUBLICATION.md): section 1 holds the full Steam description in BBCode, the dependency and content-box answers and three thanks drafts under 1000 characters. Publication goes through the CI (workflow generated 2026-09-24, 48 of 48 script tests passed, version 1.0.0). CHANGELOG.md keeps `## Unreleased` until the dry-run commit. Needs the tested gate, a presentation picture to redo (the cow with its tip: a stray tooltip, scene fixed, rerun owed), the owner's review of PUBLICATION.md and CHANGELOG.md for the 1.0 line, and a yes for the tag and the GitHub release. Not before shootGallery."
  - "unverified: `tested_on` stays empty until a green in-game pass records the game and integration versions."
session:      72f45cb8-7e45-4dea-bfa8-11aee1b7b75b
updated:      2026-10-10, audit against the AUDIT.md of 2026-10-10: done becomes playTests[1.0.0], _tools/ moved to scripts/, journal moved to docs/runs/, icon derivatives and Preview regenerated, FRENCH_REVIEW.md regenerated by the shared script
echo_review_sha: c1ea64fc52a95f0771d2842a1073cc3c64eb0338
social_preview_sha256: 73254f46f75d151ad84884a4b5120e65e60fd426a0a83967771e7b5385d96f52
code_review_sha: 867d8b730b30ab76f7013507aa39cd4a9cf81e15
protocols_read_sha: ae6bc8a0f43a31e22df7e41cc17c26a1a5300dac
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