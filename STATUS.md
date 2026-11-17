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
pickle_scenarios: 51 defined; on the current DLL only the initial pass of 2026-10-10 (no optional mods, English, `-DepMap` omitted by mistake): 30 passed, 1 failed (scenario 02 trade, fixed, then green in replay 3 on 77ba6ef, 1 of 1, both captures opened), 20 skipped for missing companions (docs/runs/2026-10-10.md); older results: scenario 10 corrected rerun passed 1/1 (2026-09-24), feature 03 avec-rimmsqol 4 of 4 (2026-09-30, older DLL), 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented; 4 completed with reviewed media (0, 1, 6, 13); rule of 2026-09-25 (owner): she validates only what Claude cannot, so Claude's own verdict counts for what it can read. Validated by Claude on 2026-09-25 from opened captures: 3, 7, 9, 10, 11 (cow and sheep), 12, 16, and 4 and 15 for their machine-readable content; left for her eye: the reset confirmation window and slider caps of 15, and the four Workshop pictures (1 accepted, 4 sent); rerun done since: 5, 11 (hen), 15 (keyed clicks); 8 validated 2026-09-28 (growth staged: Desert tile); 14 out of scope. Table in docs/MANUAL-REVIEW.md
manual_visual_evidence: none kept on disk (2026-10-18, owner rule: Tests/Pickle/Evidence/ holds minified proofs only, under 2 MB; runs land in Tests/Pickle/Inbox/). History is one line per run in docs/runs/. Nothing of this is in git.
remaining:
  - "9.a RESULT 58a4 2026-11-17: green 2 of 2, captures 4 and 5 read, folder deleted. Scene 4 (capture 5) good: no carpet, three cows clear of the pane, Nelim mid-step by the torch, Thistle bar about 60 percent. Scene 3 (capture 4) acceptable: no carpet, Buttercup whole and full bar, Nelim two cells off, but Buttercup is a front-facing blob at 108 px a cell, not a real close-up. Open: rope line in capture 3 (scene 2), em dash in settings text, score-gallery and subtitles (9.b onward). Before: 9.a ticket 20261117-185835-232-58a4 filed 2026-11-17 (tree 6f1bd3f, scenes 3 and 4, evidence Tests/Pickle/Inbox/studio-16m) after 48b4 (green 3 of 3, captures read, folder deleted): green carpet gone in 3, a strip of it remains top and bottom in 4 (bared area smaller than the carpet): scene 4 now root size 6; scene 3 cow hidden under the Needs pane: now `I frame the area centred on (184, 153) at root size 5`; levels fine now (Thistle 60 percent in 4, 30 in 2). Still open: rope line from Nelim to a cow in capture 3 (scene 2, in both 621c and 48b4, cause unknown, ask NPT if it stays), em dash in settings text. Before: 9.a ticket 20261117-184028-206-48b4 filed 2026-11-17 (tree 4dea761, scenes 2 to 4 of 16-publication-shots, `-DepMap wsl-deps.studio.map`, evidence Tests/Pickle/Inbox/studio-16l): scenes 3 and 4 now bare the clearing floor (cause of the green carpet, BareFloor only ran in the sanctuary framing step), scene 3 close-up at root size 5 (was 9, 60 px a cell), contentment reset after the waits in 2 to 4 (bars drifted). Open: the rope line of capture 3 (hypothesis: Nelim roped a cow), em dash in the settings text. Check captures 2 to 4. Before: 9.a RESULT 621c 2026-11-17: green 5 of 5 (exit 0, passed), 6 captures read by the session, folder deleted. Nelim now in frame in 1, 2, 3, 4, 5 (the 12-tick walk works), settings scene ran. Weak: shot 4 (Buttercup close-up, 15h) is NOT close: wide frame, cow tiny at left under the Needs pane, green overlay over half the map, Heatstroke alert; shot 5 (18h) same green overlay, Thistle bar about 45 percent not 60; shot 3 shows a stray brown line between Nelim and a cow; UI 200 Needs pane big, other cows cut by it in 1 (Thistle) and 2. Settings capture (6) fine, but the text still has an em dash (`eggs — and below`). Not rated by score-gallery yet. Before: 9.a ticket 20261117-172515-972-621c filed 2026-11-17 (tree a7f52c6, `-Filter 16-publication-shots -DepMap wsl-deps.studio.map`, evidence Tests/Pickle/Inbox/studio-16k), replaces 3fee (exit 5, summary `in-progress`, only 3 of 5 scenarios ran: scenes 1 to 3 passed, scene 4 and the settings scene never ran, teardown stall, infrastructure not a mod fault; 4 captures read: cows now right and in view (three cows in 1, two in 2), but Nelim absent in 1, 2 and 4 because `sends the colonist` lands on a random cell within 8 cells, and in 4 Buttercup sat behind the info pane). Fix a7f52c6: Nelim `stands at` her cell then a 12-tick one-cell forced walk in all four scenes. Check the settings scene and scene 4 ran. Before: 9.a ticket 20261117-150814-215-3fee filed 2026-11-17 (tree 07d4fa6, `-Filter 16-publication-shots -DepMap wsl-deps.studio.map`, evidence Tests/Pickle/Inbox/studio-16j), replaces be9e (red 2 of 5: a cow stood on the decor cell of scenes 1 and 2; the 3 passed captures showed cows and Nelim wandered off during the two game hours, scene 3 in a wheat field, scene 4 at root size 18 too wide). Fix 07d4fa6: cows spawn after the decor, `the animal stands at (x, z) facing` after the waits, Nelim sent after the waits, scene 4 root size 9. Camera frame: root size 5 sees 17.8 cells wide, the Needs pane hides the left 23 percent. Before: 9.a ticket 20261117-145705-659-be9e filed 2026-11-17 (tree 877d1cc, `-Filter 16-publication-shots -DepMap wsl-deps.studio.map`, evidence Tests/Pickle/Inbox/studio-16i), replaces 0335. Cause of the red framing of 0335: `selects animal ... for visual evidence` (AnimalSteps.cs) jumped the camera onto the cow after the frame step. Fix 877d1cc: new step `..., camera kept` in the four story scenes, scene 2 cows and Nelim moved to x 192 to 199, @requires camerazoom and interfacescale added, steps DLL rebuilt. At RUN_DONE: open every capture one at a time (Nelim in frame, three cows in 1, the clearing, no Learning helper problem to judge), 268 px check, score-gallery. Old 0335 evidence folder deleted. Before: 9.a result of 0335 (2026-11-17, RUN_DONE green 5 of 5, exit 0, captures 1 to 4 opened, 5 and 6 not yet): all four story captures RED for the gallery. Nelim is not in any frame (the Nelim seen at the top is the colonist bar portrait), only one cow visible in each (1: Daisy, others hidden or off frame; 2 and 3: forest, not the clearing; 4: a fenced field of flowers, wrong place, Heatstroke alert, cow tiny). Learning helper visible in all. Bars readable but the framing does not match the shotlist (the camera frame steps did not land on the clearing at UI 200). Machine green proves nothing about framing. Evidence Tests/Pickle/Inbox/studio-16h kept until the verdict and the refile. Next: read 5 and 6, find why the frame lands off the clearing (camera/frame steps at UI scale 200), fix feature 16, refile. Before: 9.a ticket 20261117-133203-440-0335 filed 2026-11-17 (tree 58a97cc, evidence Tests/Pickle/Inbox/studio-16h, `-Filter 16-publication-shots -DepMap wsl-deps.studio.map`), replaces a775 (red 4 of 5: `the point (1800, 1000) is outside the screen, which is 960 by 540 in GUI space`, the pointer parking step used screen pixels, now (700, 20) in 58a97cc; settings scene passed; folder read and deleted). Same read plan as below. Before: a775 filed 2026-11-17 (tree 045ce47), replaces 6f28 (red 4 of 5: undefined step `the interface scale is {int} percent`, the studio map did not stage nelim.pickletools.interfacescale; map fixed in 045ce47; settings scene passed, folder deleted). Same plan as 6f28: `-Filter 16-publication-shots -DepMap wsl-deps.studio.map`: four story scenes plus the settings scene, five story captures plus one window. At RUN_DONE: read summary.json and junit.xml, open every capture one at a time, reduce each to 268 px (ffmpeg scale=268:-1) and check the bar stripe (criterion j), run score-gallery on the captures, REDO and delete the ones under 4 on any note, then subtitles (PUBLICATION.md Gallery subtitles, Art/Gallery-clean + Add-Subtitle.ps1). Captures go to Art/Gallery-clean under final names; Art/Gallery holds only 0-preview until then. Delete the Inbox folder after reading."
  - "CI regenerated 2026-11-17 (stamp d20db370c66b, `.github` + `Tests/Test-Mod.ps1` committed, Test-Mod 6 of 6 ok). Steam tags are now the default of each publish, `--tags` removed: the existing dry-run is void, redo it WITHOUT `--tags` before any publish (it shows the tag set beside the page tags). A real publish needs `STEAM_REFRESH_TOKEN` on `steam-production` (Virginie manages secrets, never ask CI/CD)."
  - "audit replay 2026-11-17, second pass after the 7.d fix (ledger .replays/ContentedLivestock-20261117.tsv, 82 rows, Check-Replay OK, 68 done, 8 n/a, 6 open): first open 9.0 bis, stage writeShotlist[1.0.0]. Fixed in place by the session: the two @requires tags on feature 16 (7.d, Check-Steps clean), the 041b line in Docs/runs/2026-11-13.md (8.l). Open: 9.0 bis done 2026-11-17 (plan 5.0 on the four story scenes); 9.a to 9.f gallery not done for the new plan. Ticket 4da5 (studio-16e, 2026-11-16) green 2 of 2, unrated, capture 1 weak (cow small at bottom right, Nelim tiny at the top edge); its Inbox folder stays until read. Seen, not ledgered: 6.g record, the 2026-11-13 ChatGPT review pages (9da5d6d, 70abe4a) and the French texts after it (be98635, 23148b5) are not written in Translation audit."
  - "8.f DONE 2026-11-14: efda green 3 of 3 (exit 0), captures read: shot 1 cow hidden behind the tip and shot 3 cow at the map edge; framing fixed in feature 16 (offsets, cows at x 185, Nelim sent away in scene 2), ticket 47fb green 2 of 2, captures 1 to 3 read, cow and bar visible, no void; settings capture (4) read in efda, fine; evidence folders deleted; feature 16 edit uncommitted. Still open: 8.n. History: 8.f ticket efda filed 2026-11-14 (efda replaces e9e8, which failed 3 of 3: Miel is not in the save, the cow has no alternate coats; feature 16 now sends Nelim and drops the coat steps; evidence Tests/Pickle/Inbox/studio-16c; first filed e9e8 at the same settings) (evidence Tests/Pickle/Inbox/studio-16b, `-DepMap wsl-deps.studio.map`, the 3 scenarios of 16-publication-shots, label with the commit sha): waiting. Why: first run 3e09 failed 3 of 3 at `the save "nelim-zen-meadow-studio" is loaded`, that fixture was deleted on 2026-10-08 (PickleTools/Docs/FIXTURES.md). Owner chose to rewrite now: feature 16 loads Nelims-tribe-decor-mods-z3, frames `bare-clearing` (Nelim's Sanctuary: I frame the sanctuary), cows and decor around (195, 152); the studio map is the Sanctuary map plus ScreenshotMode and SanctuaryBacklot. Check-Steps clean. After RUN_DONE: read summary.json and junit.xml, open the 3 captures (shot placement unverified), delete the folder, then 8.n. PiI ecosystem: no translation of the original found, nothing to integrate (TM rule 2026-11-14); DLC names rule: no DLC name in the French text, nothing to change. Earlier: 8.d capture 041b DONE green 2026-11-13 (exit 0, passed 1 of 1, exitReason passed), capture opened and read: French primary settings page, all strings translated, no overflow, sliders, five checks, reset and close buttons readable. Folder Tests/Pickle/Inbox/capture-fr-settings deleted after reading. Still open: 8.f (belongs to shootGallery 9.a), 8.n. Earlier: 8.d capture ticket filed 2026-11-13: 20261113-230147-328-041b, `-Filter '02-settings-and-language::primary settings page' -Language French`, runtime-evidence map, evidence Tests/Pickle/Inbox/capture-fr-settings. Open the capture before deleting the folder. 8.f (studio map pass, feature 16) not filed: gallery captures belong to shootGallery.
  - "audit replay 2026-11-13 rerun after the 7.d fix (ledger .replays/ContentedLivestock-20261113.tsv, 72 rows, Check-Replay OK, 60 done, 7 n/a, 3 open, 2 ?): first open 8.d, stage playTests[1.0.0]. Open: 8.d captures `@review` opened and looked at (none of the 2026-11-13 runs was opened, folders deleted unread: file one small ticket with a capture, open it before deleting); 8.f the studio map pass of feature 16 never ran on this DLL (three publication shots, belongs to shootGallery 9.a, needs a ticket); 8.n waits for these. 7.d fixed 2026-11-13 (three @requires on feature 16, ClickDiagnostics line in wsl-deps.studio.map, Check-Steps clean). 8.l done 2026-11-13 (Docs/runs/2026-11-13.md). 8.m done 2026-11-13: diff 867d8b7..HEAD read by an Opus sub-agent (Mod/Languages text, Mod/About/Preview.png, Tests/Pickle), Source and DLL unchanged, no defect, code_review_sha set to HEAD (revue du diff : textes et images seuls). Fixed in place by the replay: .gitattributes (1.f), workshop_required_items n/a not released yet (4.g)."
  - "French text changed 2026-11-13 (e2fb285, text only, DLL unchanged): `Settings.ConfirmReset` and `Nelim_ContentedLivestockSettings.description` now cite `Contented Livestock (Bétail épanoui)` (title decided by Virginie 2026-11-13, Audit registry, Docs/review-names.md). Not read in game. RIMMSQOL in `Settings.Scope`: name decision pending with Virginie (my proposal: keep as is). Ticket 94ca stages the tree at its run, so it carries this text."
  - "done 2026-11-06: Preview redone on the new config format (layout panel top-left, icon bottom-right, accepted by the owner, commit c1ea64f), uploaded as the GitHub social preview via Chrome, og:image hash equals social_preview_sha256."
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
updated:      2026-11-17, shotlist rewritten, plan 5.0 on every scene, stage shootGallery[1.0.0]
echo_review_sha: c1ea64fc52a95f0771d2842a1073cc3c64eb0338
social_preview_sha256: 73254f46f75d151ad84884a4b5120e65e60fd426a0a83967771e7b5385d96f52
code_review_sha: e26a51c0ea2e7f175b8180173155252f199c275a
protocols_read_sha: 1e7080d0742c4f6411f38c8350606baa18950ad9
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

Places read: 2026-11-15 Tribe read: 2026-11-17 (VTW-BODYTYPES.md opened: Nelim is Female, VTW, temporary go for SaB, no effect on our outfit or shots) Steps read: 2026-11-17 (NPT since 2026-11-15: one step, Beauty2 mouth vertical offset DY, b6dec3e: not used, cows and Nelim keep the default mouth)

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
