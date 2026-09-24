---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Contented Livestock
packageId:    nelim.contentedlivestock
repo:         Rimworld-Contented-Livestock
visibility:   public
detached:     yes
stage:        done
settings_audit: complete
dependencies_audit: complete
audit_revision: 4531a66dfc7b4b731c6b4de562bdd7c0486b4185
audit_date: 2026-09-22
licence:      original
license_spdx: MIT
licence_at:   an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the `LICENSE` is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic is Stardew Valley's, credited in ATTRIBUTION.md and reused from none of its lines.
dependencies: "brrainz.harmony (required); RIMMSQOL optional, Pickle integration and restart persistence passed"
showcase:     complete
tested_on:
workshop:     "3806136625 (0.1.0; visibility and subscription test unverified)"
automated_tests: 35 passed (2026-09-22)
pickle_scenarios: 24 defined; scenario 10 corrected rerun passed 1/1 after a failed baseline-timing attempt, 6 intended skips in minimal passes (2026-09-22)
manual_scenarios: 18 documented, 4 completed (scenarios 0, 1, 6 and 13; 2026-09-22)
manual_visual_evidence: current media = 22 minified JPEG captures of the 2026-09-23 run on d9be961 (1 of 22 opened; what to keep and how: docs/runs/README.md) plus 3 Workshop-page pictures of 2026-09-24 (all opened; Tests/Pickle/evidence/2026-09-24/publication-shots) plus scenario 10 attempt-02; the 2026-09-22 media for scenarios 0, 1, 2, 6, 13 were deleted as superseded, see docs/runs/2026-09-22.md
remaining:
  - "prepared 2026-09-23, not released: PUBLICATION.md holds the release notes, the corrected description tail (the Steam page has SOURCE CODE before IF I GO QUIET and no licence line), the dependency and content-box answers, and three thanks drafts under 1000 characters. Blocked on the tested gate, on one presentation picture still to redo (the cow with its tip: a stray tooltip, scene fixed, rerun owed) and on a yes for the tag and GitHub release. Two Pickle passes are submitted to TicketDispatcher, avec-rimmsqol and runtime-film, not yet run."
  - "verified (done -> tested), no @wip: the fifteen feature files declare no @wip scenario, so nothing is parked waiting to be repaired or deleted. Checked 2026-09-23."
  - "unverified (done -> tested), conditional scenarios: of the three @requires conditions, only ScreenshotMode has run against the current revision. The six RIMMSQOL scenarios passed again on 2026-09-24 under set avec-rimmsqol, 6 of 6 over four launches (feature 03 and the restart chain 05, 06, 07), on HEAD 10001d1 with Mod/ unchanged since 4531a66 and after the scenario-isolation fix (Tests/Pickle/evidence/2026-09-24/avec-rimmsqol, text files and one capture opened); this condition is met. The one FilmTicks scenario has NO preserved report from a set that stages FilmTicks: the report that shows it passing is labelled set=runtime-evidence, and under that same map today it skips. A set name is not proof that the scenario ran with its condition present."
  - "fixed 2026-09-23, undeclared condition: features 09 and 10 use the ScreenshotMode companion's own steps without declaring it, and now carry @requires:nelim.pickletools.screenshotmode like feature 02, so they skip rather than fail where it is absent. An earlier version of this line named features 04, 11, 12, 13 and 14, which only use Pickle's ordinary screenshot step and needed nothing."
  - "unverified (done -> tested), manual tests: 4 of the 18 scenarios in _tools/FUNCTIONAL-SCENARIOS.md are complete with reviewed media (0, 1, 6, 13) and one is partial (2). The gate requires none left to validate: each remaining scenario is either played and green, or listed as not applicable with its reason."
  - "unverified (done -> tested): Execute remaining scenarios 2-5, 7-12 and 14-17 in _tools/FUNCTIONAL-SCENARIOS.md; retain Player.log plus screenshots for stable assertions and videos for timed, transitional or restart behavior, covering a new colony and an existing save."
  - "partially verified (done -> tested): Pickle passed live producer eligibility, producers-only refresh, faction changes, initial level and representative rate factors; the remaining option effects and production cases stay in scenarios 0-17."
  - "verified at 2026-09-22 revisions, media since deleted (done -> tested): scenarios 0, 1, 6 and 13 each passed a targeted Pickle run with reviewed captures and films, and scenario 2 passed its two live SetFaction transitions (a real trade-dialog sale remains unverified). Text record in docs/runs/2026-09-22.md. The media were deleted on 2026-09-23 under the AGENTS.md evidence rule because a newer whole-companion pass replaced them; that pass, on revision d9be961, passed 17 of 24 with 0 failed and covers these scenarios as assertions, with no films."
  - "scenario 10 (halt and resume): the corrected 2026-09-22 run passed 1/1 - 3.3% milk fullness held at 10-14% Contentment over a game hour, then 9.1% after restoration. Its media are the only ones kept for it, in Tests/Manual/evidence/2026-09-22/scenario-10-halt-resume/attempt-02, because the 2026-09-23 set skips it (it needs FilmTicks). A mid-scenario tick-film is still required for manual completion."
  - "partially verified (done -> tested): Pickle passed initial hidden state plus RIMMSQOL reveal, open, hide, forget and visible/hidden persistence across separate processes; broader shared-value editing remains in the manual matrix."
  - "Record tested_on with the game/integration versions and results only after successful game validation."
session:      01a09726-7616-7ad2-bc3c-d94a8e24da95
updated:      2026-09-23, tested-gate checks applied by the mod's own session
---

# Contented Livestock — status

## Workflow audit — 2026-09-22

**`preTest` → `done`.** The independently validated earlier gates remain recorded:
the standalone repository has an `origin` tracking `origin/main`; the shipped icon and
preview decode to 128 × 128 and 896 × 504 respectively; the preview is 681,815 bytes
and was directly inspected; settings, EN/FR resources, DefInjected paths and declared
Harmony dependency pass their static contracts. The current shipped DLL SHA256 is
`E69349C34F01E7E3BFF556F1286649F90665B3B5D0F1C5CBE2D35C2551B309B8`.

`dotnet build Source/ContentedLivestock.csproj --no-restore` succeeded with zero
warnings/errors when given access to the local Windows SDK. `_tools/Run-Functional-Tests.ps1`
passed **35/35** against that DLL, and `../scripts/Check-DefInjected.ps1 -TransMod ./Mod`
checked four keys with zero errors. The first sandboxed build could not read the local
Microsoft SDK directory; that was an environment restriction, not a source failure.

`Tests/Pickle/` now supplies a development-only companion with seven features and sixteen
scenarios. Its documented pass matrix covers minimal English and French passes, live animal
eligibility/rate checks, optional RIMMSQOL integration and a three-process persistence chain.
The suite deliberately leaves normalization, scalar Scribe, XML and static localization to
the existing 35-test harness; its in-game scope includes startup, live loaded defaults, the
real settings dialog, active-language resources, native MainButtons behavior, representative
animal state/rate changes and RIMMSQOL reveal/open/hide/forget behavior.
`_tools/FUNCTIONAL-SCENARIOS.md` retains the broader 18-scenario animal-production matrix.

`dotnet build Tests/Pickle/Source/ContentedLivestock.PickleSteps.csproj -c Release`
succeeded with zero warnings/errors. `Tests/Pickle/Check-Steps.ps1` compiled all nineteen local
Cucumber expressions with Pickle's own engine, found no duplicate or unused local pattern,
and inventoried 106 feature step lines. The delivered step DLL SHA256 is
`5846FE0A416289B516AEA4EE11F0EC52107F662408D9FA9C25C4069157B27CD3`.

The three documented WSL/Xvfb passes were subsequently executed through the shared launcher:
minimal English **6 passed / 0 failed / 3 intended integration skips**, minimal French
**6 passed / 0 failed / 3 intended integration skips**, and RIMMSQOL **3 passed / 0 failed /
0 skipped**; every report ended with `exitReason: passed`. All three `@review` captures were
opened. English and French settings pages show all controls without raw keys, fallback text,
clipping or overlap; the RIMMSQOL-opened page is the same Contented Livestock dialog.
The later gameplay pass completed **4 passed / 0 failed / 0 skipped**. A chained RIMMSQOL
run then completed three separate processes at **1 passed / 0 failed / 0 skipped** each,
proving that reveal and hide choices survive restart and that the final process removes the
choice. Preserved complete summaries, JUnit reports and Player logs are under
`Tests/Pickle/evidence/2026-09-22/`. These results validate the covered UI, animal and
integration paths, but do not execute the full 18-scenario manual production/save matrix,
so the overall stage remains `done` rather than `tested`.

The remote URL and its configured upstream were inspected locally; live `git ls-remote`
could not connect to GitHub from this environment, so current remote reachability and
visibility are unverified. `Mod/About/PublishedFileId.txt` records Workshop item
`3806136625` for 0.1.0 and is tracked by commit `4531a66`; visibility and subscription
testing remain unverified and therefore establish neither `prepublished` nor `published`.

Strictly necessary next transition: execute the remaining applicable cases in
`_tools/FUNCTIONAL-SCENARIOS.md`, including new/existing-save production and full persistence,
then record the game version and final results in `tested_on`.

## Current corrections and validation — 2026-09-13

**`preOptions -> options -> l10n -> preTest -> done` passed under the supplied
workflow; `tested` remains unverified.** Stage names are literal workflow names.
The user authorized implementation after the audit. The earlier audit and historical
results are preserved below; their missing-shortcut/dependency findings are now resolved.

Base revision: `600129c878e335a9bbb2148b1e235d21eb442ce1`, plus the local implementation,
metadata, EN/FR resources, tests and documentation changes listed by `git status`.
No commit, push, Workshop publication, image generation or game-profile modification
was performed. The DLL in `Mod/Assemblies` was rebuilt and is the tested artifact.

**Evidence:** `_tools/results/2026-09-13-settings-tests.txt`,
`_tools/results/2026-09-13-definjected.txt` and
`_tools/results/2026-09-13-settings-manifest.json`. The manifest records the base
revision and SHA256 values of the relevant sources, shipped files and test scripts.
Shipped DLL SHA256:
`E69349C34F01E7E3BFF556F1286649F90665B3B5D0F1C5CBE2D35C2551B309B8`.

### Settings audit — complete for the technical gate

- The same eleven useful settings remain available through native Mod options.
  `Nelim_ContentedLivestockSettings` now provides a MainButtonDef with
  `buttonVisible=false`, `validWithoutMap=true` and a custom worker that opens
  `RimWorld.Dialog_ModSettings(ContentedLivestockMod.Instance)`. No extra settings
  instance, alternative persistence system or compulsory customization mod exists.
- The worker inherits native Visible, including the standard visibility field;
  nothing resets that field at runtime. The actual Def and worker were instantiated,
  the shared field was toggled, and the compiled inheritance/call contracts were
  checked. The native Visible getter initializes ModsConfig and requires Unity,
  so on-screen hidden/revealed behavior is explicitly deferred to scenario 17.
- `Normalize()` enforces the existing slider ranges for loaded settings as well as
  UI values: floor 0–50%, plateau 30–90% and at least five points above the floor,
  minimum 0–100%, maximum 100–200%, speed 25–400%. Nonfinite values use defaults.
  Default values, normalization idempotence, bounds and crossed thresholds passed.
- Runtime rate/target/speed calculations now share the directly tested production
  methods. Tests exercise canonical curve points and **81 parameter combinations**
  sampled across 101 levels, all **32 input-toggle combinations**, target clamps,
  rising/falling speeds and no overshoot. Existing reset tests cover all fields.
- On native settings close, WriteSettings normalizes values, refreshes living
  animals' needs and invalidates environmental caches, then calls native persistence.
  This fixes producers-only previously waiting for a needs refresh. Disabled cached
  factors are also suppressed in the tooltip and target. Compiled call paths were
  checked; live animal changes are covered by scenarios 3 and 16, still unexecuted.
- Real ScribeSaver/ScribeLoader and the shipped ExposeData passed **scalar** XML
  save/load tests for all eleven nondefault values, omitted defaults, older partial
  files and invalid numeric ranges/NaN/infinity. No fake Scribe implementation was
  substituted. Unity's FinalizeLoading profiler cannot run in this .NET process;
  these settings have no cross-references or post-load actions, so that phase is
  excluded from the scalar test and retained in the game persistence scenario.
- Real producer-comp detection passed for milk, wool and eggs. Full animal
  eligibility calls require RaceProperties.Animal -> ModsConfig/DefOf initialization;
  they are source/IL-reviewed here and assigned to the in-game eligibility scenario.
  Minimal game-object fixtures do not claim to simulate a world or a map.
- EN/FR guidance now explains global scope, saving on close, gradual contentment
  and the optional shortcut. Invalid/empty **text** input is not applicable because
  numeric controls are sliders. Game opening, logs, layout and restart checks are
  reserved for `tested`, as explicitly allowed by the user's workflow override.

### Dependencies and integrations

- About.xml now declares `brrainz.harmony` as the sole required mod, including
  installation links and loadAfter. Runtime binaries are not duplicated in Mod/.
  README and both ATTRIBUTION copies identify the dependency and its author.
- Verified installed Harmony package 2009463077: mod version **2.4.2.0**, LoadFolders
  selects `Current` for RimWorld 1.6, actual 0Harmony assembly **2.4.1.0**. The NuGet
  build reference is assembly **2.4.2.0**. That number difference alone is not a
  failure: tests load the installed runtime, instantiate its Harmony class, resolve
  PatchAll and compiled attributes, and pass the patch signature/access contracts.
  No NuGet runtime fallback remains in the runner. Other Harmony versions and
  in-game patch startup are not being claimed as tested.
- RIMMSQOL source `SettingsInit.cs` was inspected: it enumerates MainButtonDefs and
  reads/writes buttonVisible. Installed 1.6 DLL file version: **1.0.9591.34971**;
  SHA256 `1152B0C198D34D4BB346FC74A4C4B72856F21ADA71FF376C5E4FF5F00FC81BD1`.
  This is a source-contract review, **not** a successful interactive integration test.
  Neither RIMMSQOL nor any other customization tool was exercised in game.
- No LoadFolders, version folders or conditional patches were introduced. Existing
  optional Ludeon loadAfter entries do not become compulsory DLC requirements.

### Translation, build and final readiness

- `dotnet build Source/ContentedLivestock.csproj --no-restore`: succeeded with
  **zero warnings/errors**, writing the DLL identified above.
- `powershell -NoProfile -ExecutionPolicy Bypass -File
  _tools/Run-Functional-Tests.ps1`: **35/35 passed** on that DLL, including the
  fourteen new settings/dependency/localization checks in `Settings-Tests.ps1`.
- All **36 owned Keyed entries per language** are nonempty, unique, match the
  compiled inventory and have compatible format parameters. Read the new scope
  paragraph and shortcut label/description in both languages. NeedDef and
  MainButtonDef English source fields provide native EN coverage; all four owned
  Def fields are covered by French DefInjected resources.
- `powershell -NoProfile -ExecutionPolicy Bypass -File
  ../scripts/Check-DefInjected.ps1 -TransMod ./Mod`: **11,588 Defs indexed, four keys,
  zero errors**, no unresolved target. Shipped XML parsing and MainButtonDef field
  types/worker resolution also pass in the standalone suite.
- `_tools/FUNCTIONAL-SCENARIOS.md` now documents **18 scenarios**, numbered 0–17,
  with setup/actions/expected results, including clean configuration, boundaries,
  each option's effect, shortcut reveal/hide/shared settings, EN/FR, new game and
  existing save. No game scenario has been executed in this session.
- Earlier image, naming, standalone repository and provenance checks remain valid;
  the affected attribution copy was synchronized. No independent image validation
  was invalidated by these changes. Historical mutation results were not replayed
  and the new tests were not mutation-certified; neither is an additional gate.

The strictly necessary next transition is **done -> tested**: execute the documented
game scenarios and fix/retest any observed failure. This status does not certify game
UI, RIMMSQOL interaction, final load initialization or a live production session.

## Historical workflow audit — 2026-09-13 (superseded above)

**Previous stage: `done`; justified cumulative stage: `preOptions`.** The stage uses
the literal workflow name, not a letter code: Preview and its overlay are complete;
the next transition is `preOptions -> options`. `done` means ready for final game
validation and `tested` means that validation has passed. Neither is currently justified.

This audit follows the supplied workflow and reads `../PUBLISHING.md`,
`../STYLE_RIMWORLD.md`, `../MOD_SETTINGS.md` and `../TRANSLATIONS.md`.
The supplied interpretation takes precedence: game interaction is required for
`tested`, not for the initial settings gate. Historical results below remain history;
their former stage and dependency conclusions do not override this audit.

### Scope and revision

- Standalone repository: `C:\Users\nelim\Documents\rimworld\ContentedLivestock`;
  distributed content: its `Mod/` directory. `git rev-parse --show-toplevel
  --git-common-dir` confirms this root and its own `.git` directory.
- Audit started on `54ab23275a96602b74e69346e5c67c62509d571d`, with existing local
  changes in `CHANGELOG.md`, `Mod/Assemblies/ContentedLivestock.dll`, both Keyed
  files, `STATUS.md`, `Source/ContentedLivestockMod.cs`,
  `Source/Runtime/Need_Contentment.cs` and `_tools/FUNCTIONAL-SCENARIOS.md`.
  During the audit, HEAD advanced to
  `600129c878e335a9bbb2148b1e235d21eb442ce1` (translation validation, 01:47:32 +02:00).
  The working tree was then clean, before this status edit. This audit did not commit,
  push, publish, generate images or implement changes; those pre-existing changes
  were preserved. The final revision contains the audited source/resources.
- Shipped DLL SHA256 before and after the successful build:
  `41DEC02C2D4AF850E02669E831DFC7E990756636A212561904AA5050E78ED879`.
  The independent checks apply to these bytes, including the existing translation edits.
- Installed game used for reflection/XML checks: **1.6.4871 rev590**, from its
  `Version.txt`; Managed assemblies under the installed Steam RimWorld directory.
  No running-game session, save or Player.log was validated.

### Ordered transition results

| Transition | Result and evidence |
| --- | --- |
| dansMonoRepo -> horsMonoRepo | **Validated.** Independent Git repository and GitHub origin; `gh repo view ... --json name,visibility,url,defaultBranchRef` returned PUBLIC, the expected repository and main. `git ls-remote origin refs/heads/main` returned `54ab23275a96602b74e69346e5c67c62509d571d` at the time of the check, establishing pushed commits. No monorepo remote is required. English README, attribution, MIT licence and changelog exist. LICENSE and ATTRIBUTION copies in Mod/ are byte-identical to their root copies. Original provenance and public visibility are coherent with the recorded rights; no third-party licence was invented. packageId, display name, folder and repository name consistently identify this mod without needing literal equality. |
| horsMonoRepo -> ModIcon générée | **Validated for this gate.** Existing implementation builds successfully and reproduces the shipped DLL. Installed ModIcon is a decoded PNG, 128 x 128, 31,809 bytes, directly inspected. Settings and dependency deficiencies are assessed at their explicit later gates, rather than retroactively treating those gates as part of this build/image checkpoint. |
| ModIcon générée -> Preview générée | **Validated.** Installed PNG is 896 x 504, 681,815 bytes, below 1 MB; directly inspected at full size and with the existing 268 px thumbnail. High overhead camera, tiled ground, warm light pool, small back-facing colonist and readable composition; no concrete camera defect. No generation history or recorded game-screenshot comparison is required. |
| Preview générée -> preOptions | **Validated.** English title, summary and About description. Public original naming requires no continuation/private/unofficial suffix; the two title words contain no conjunction requiring reduction. `Art/preview-palette.json` and its consuming `Art/preview.html` use a distinct green accent and warm ochre secondary. Title and version are identifiable, the rule is visible and text is neither clipped nor overlapping. The unused secondary/tag is justified by the public original status. |
| preOptions -> options | **Defect and unverified checks.** Useful settings and primary access exist, but the mandatory optional MainButtons shortcut is absent. Existing technical tests pass but do not establish the whole settings contract; see Settings audit below. This is the first blocking transition. |
| options -> l10n | **Independent resource validation retained.** All 35 owned keys and both Def fields are covered in EN/FR, with matching parameters and valid injections. Existing `complete` translation fields describe this checked current inventory, not passage past the blocked settings gate or in-game validation. Re-audit any future shortcut text. |
| l10n -> preTest | **Defect.** Required runtime Harmony is neither bundled nor declared. The optional DLC loadAfter entries are not required dependencies; no LoadFolders, conditional XML patches or version-specific content complicate loading. No optional customization integration has been tested. |
| preTest -> done | **Independent checks partially established.** Existing automated/XML suite: 21/21 passed on the delivered DLL. Fifteen manual scenarios have shared setup, actions and expected results, plus an EN/FR pass. They do not yet include the missing shortcut's reveal/open/hide/shared-persistence scenario or a complete settings-boundary/defaults matrix. These must accompany the settings correction. Cumulative done remains blocked by earlier gates. |
| done -> tested | **Unverified.** Zero game scenarios executed by this audit; no EN/FR interface, game logs, new game, existing-save, interactive persistence or MainButtons integration result. No test failure in game is being inferred from this absence. |

### Settings audit

`settings_audit: partial`. Scope: all C# sources and shipped Defs, with special
attention to `ContentedLivestockMod`, `ContentedLivestockSettings`, `Contentment`,
`Need_Contentment`, the need-eligibility patches and the compiled test inventory.

There are **11 useful settings**: five numeric sliders and six toggles. Production
floor, plateau, minimum/maximum rate and adjustment speed control the production
curve or convergence speed. Five toggles control the five husbandry inputs;
producers-only controls which colony animals receive the need. They have gameplay
uses; adding placeholder settings or declaring settings inapplicable would be wrong.

- Primary access is implemented through `SettingsCategory()` and
  `DoSettingsWindowContents(Rect)` in the game's Mod API. The category and all
  controls are translated; there is scrolling and a confirmed reset action.
  Manual XML editing is not required. Actual opening/layout remains an in-game check.
- The UI exposes floor 0–50%, plateau 30–90%, minimum rate 0–100%, maximum rate
  100–200%, and speed 25–400%. Slider results are rounded/clamped and the plateau
  is kept at least five percentage points above the floor. Defaults in source are
  25%, 60%, 40%, 140%, 100%, with all six toggles true. These are observed source
  contracts, not claims that every boundary and combination was exercised.
- Settings use the global `ModSettings`/`GetSettings` mechanism, with eleven
  `Scribe_Values.Look` entries and reset defaults. Rate calculations read current
  settings; need adjustment happens on NeedInterval, and space/company are cached
  for roughly 2,500–2,699 ticks. The timing of producers-only application must be
  verified against the needs tracker. The UI does not explain global scope and
  these differing application times; document them as part of settings usability.
- **Observed tests:** default curve numbers and their ordering passed; reset
  restored every numeric/bool field; compiled Scribe string keys matched fields;
  neutral-rate paths were called and passed. The test named “curve ... monotonic”
  checks default numbers/order, not RateFactor across configured curves. The
  save-key test reads IL literals, not an actual serialization round-trip.
- **Unverified technical coverage:** all first-use/older-value defaults, actual
  option effects, numeric boundaries and interactions, and settings serialization
  round-trip. Run applicable tests or explicitly justify any engine-bound part
  deferred to game validation. Invalid/empty text input is not applicable to these
  sliders and checkboxes; no artificial text-input test is needed.
- **Defect:** exhaustive source/Mod file inventory and searches for `MainButton`,
  `MainTab`, `Dialog_ModSettings` and `WriteSettings` find no shortcut definition
  or implementation. There is consequently no revealable entry or alternate route
  to verify. Its absent definition is not a hidden-by-default implementation.
- **Integration coverage:** none. RIMMSQOL and other customization tools were not
  exercised. Their interactive reveal/open/edit/hide and visibility-persistence
  checks belong to `done -> tested`, per the supplied override. They must remain
  optional dependencies, with the primary route usable without them.

### Executed checks and limitations

- `dotnet build Source/ContentedLivestock.csproj --no-restore`: initial sandbox
  attempt could not access the local Microsoft SDKs directory; retry with the
  approved local access succeeded, zero warnings/errors. DLL hash unchanged.
  This was an environment restriction, not a compilation defect.
- `powershell -NoProfile -ExecutionPolicy Bypass -File
  _tools/Run-Functional-Tests.ps1`: **21 tests, all passing**. XML parsing,
  NeedDef field/type checks, DefOf references and injection checks are included.
  The unchanged DLL hash ties the test run to the successfully built artifact.
- Additional PowerShell source/resource checks: 35 distinct owned source keys,
  exactly 35 nonempty keys in each language, no duplicate/missing/unused keys,
  matching parameter indices and successful `String.Format` for every entry.
  Read both complete resources and traced PercentRow, AppendLine and GetTipString.
  The English NeedDef label/description provide native EN coverage; FR supplies
  both `Nelim_Contentment` injection paths. No redundant EN injection is needed.
- `powershell -NoProfile -ExecutionPolicy Bypass -File
  ../scripts/Check-DefInjected.ps1 -TransMod ./Mod`: 11,587 Defs indexed, two
  keys checked, zero errors, no unverified target reported. A later unrelated
  `git -c core.excludesFile=NUL status` in the same shell batch failed because
  Git cannot use NUL as an exclude file; that batch exit is not an XML test failure.
- PNG decoding established actual dimensions, format and byte counts. Direct
  visual inspection establishes the current Preview result. Existing font/contrast
  evidence in `Art/preview-qa.json` is retained as historical evidence, not described
  as a new renderer/contrast run; no images were rewritten.
- **Dependency evidence:** the shipped assembly reference list includes
  `0Harmony, Version=2.4.2.0`; constructor and patches use HarmonyLib directly.
  `Source/ContentedLivestock.csproj` excludes Lib.Harmony runtime assets.
  Neither `Mod/Assemblies` nor the game's Managed folder contains 0Harmony.dll.
  About.xml has no modDependencies and its loadAfter contains only Ludeon IDs.
  The test runner explicitly resolves Harmony from `.nuget/packages/lib.harmony`.
  Passing those tests therefore does not validate standalone dependency loading.
  Declare the supported Harmony runtime provider and ordering, and verify the
  supported version contract; revise the inaccurate “no dependencies” attribution.
- No tests were invented to fill gates. Historical mutation results were not
  replayed; their absence is not an extra blocking requirement.

### Next transition and secondary observations

To pass **preOptions -> options**, implement the optional, initially invisible
MainButtons shortcut to the same settings, clarify scope/application timing, and
complete the applicable technical settings checks above. Rebuild and revalidate
only affected tests/resources. No in-game result is required for that transition.

Harmony metadata/runtime provision is a separate **mandatory later blocker** for
`l10n -> preTest`; it is not the reason for choosing preOptions instead of options.

Non-blocking observations for the supplied gate definitions: the icon is visually
busy (mascot plus several animal faces and a pen), beyond the one-mascot/one-or-two
objects style recommendation; simplifying it could help its 32 px rendering, which
was not separately inspected. Its required PNG format and dimensions pass. The
GitHub link in About.xml works and is present, but its wording and placement differ
from PUBLISHING.md's recommended final “Source code on GitHub” line. Neither point
is promoted into an additional blocking criterion for the supplied transitions.

## Historical status snapshot — 2026-09-13 (superseded above)

Maintenu par Codex pour ce dépôt local autonome. Ce fichier reste à la racine,
hors de `Mod/`, et n'est pas livré au Workshop.

- **Développement : terminé** (`stage: done`), validation en jeu encore attendue.
- **Visibilité : public ; licence : original ; licence juridique : MIT.**
  Provenance et justification détaillées ci-dessous.
- **Tests automatisés : 21/21 réussis**, XML compris, sur la DLL recompilée le 2026-09-13.
- **Traductions : inventaire et ressources EN/FR complets** ; affichage en jeu non vérifié.
- **Tests manuels : 15 scénarios prêts, aucun résultat en jeu enregistré.**
  `tested_on` reste vide ; le scénario 0 est le premier contrôle à effectuer.
- **Preview : terminée et vérifiée**, accent vert pâture, version 1.6.
  Composition, palette et preuves de vérification conservées dans `Art/`.
- **GitHub : audit poussé dans `e986f22`, Preview poussée dans `c147b65` sur main.**
- **Workshop : aucune publication effectuée dans cette session**, aucun identifiant
  renseigné dans ce statut.
- **Dépendances déclarées : aucune** dans About.xml ; `loadAfter` ne contient que
  les packages Ludeon. Les références de compilation sont détaillées dans le projet.

`licence: original` classe la provenance de ce mod ; `license_spdx: MIT` nomme
sa licence juridique. La validation automatisée ne remplace pas les essais en jeu.
## Translation audit — 2026-09-13

Applied the translation gate from the shared `../PUBLISHING.md` and `../TRANSLATIONS.md`.
Audited working-tree changes based on `54ab232`: all C# under `Source/`, the shipped DLL,
`Mod/Defs/NeedDefs/Needs_Contentment.xml`, both Keyed files and the French NeedDef injection.
The published tree has no LoadFolders, version folders, optional integrations, XML patches,
grammar resources or other generated player-facing text.

- Inventory: 28 settings keys (category, introduction, headings, five slider labels and
  tooltips, five factor toggles and tooltips, producer toggle and tooltip, reset button and
  confirmation); seven need-tooltip keys (rate, halted state, five factor lines); two Def
  fields (`Nelim_Contentment.label` and `.description`). Traced `PercentRow`, `AppendLine`
  and `GetTipString`, including conditional display. Other runtime code and Harmony patches
  add no text. English Def values supply the native fallback; French injects both fields.
- Fixed the hardcoded settings category with `ContentedLivestock.Settings.Category`.
  Both languages deliberately retain the proper name "Contented Livestock". Each factor
  line now owns its punctuation and `{0}` value in the language resource, resolved as a
  complete line rather than concatenated with a translated label.
- PowerShell source/resource comparison: 35 distinct source keys, 35 nonempty entries per
  language, no duplicate, missing or unused keys; matching parameter indices and successful
  `String.Format` checks. Reviewed all English/French text for meaning, terminology, XML,
  accents and formatting. No custom rich-text tags or grammar tokens are present.
- `dotnet build Source/ContentedLivestock.csproj --no-restore`: succeeded with zero warnings
  and errors; shipped `Mod/Assemblies/ContentedLivestock.dll` rebuilt.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  21/21 passed against the rebuilt DLL and installed game, including compiled key inventory,
  XML and DefInjected checks.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1
  -TransMod ./Mod`: 11,587 Defs indexed, two injection keys checked, zero errors and no
  unverified targets reported.
- No explicit game/dependency translation keys are reused. The base need tooltip and
  standard confirmation buttons are rendered by the game's own UI; they are included in
  the pending language pass. Internal identifiers, serialization keys, numeric signs and
  format strings are data; About metadata, licences and repository documentation are outside
  the in-game gate. No engine limitation prevents translating owned text.
- All three fields are `complete` for readiness for `preTest`; historical `stage: done`
  is preserved. Neither language has been tested in game. The language pass is documented
  in `_tools/FUNCTIONAL-SCENARIOS.md` and tracked as `unverified` in `remaining`.
  Reset affected translation fields to `unchecked` after relevant source/resource changes
  until this audit is repeated.

## What this mod taught the repository, and it outlives the mod

Two things, kept here because they serve whoever comes next:

- **A mod built against `Krafs.Rimworld.Ref` can be entirely dead with nothing in any log to say
  so.** The game's non-public fields arrive public in the reference assembly, so the code
  compiles; the access is only legal at runtime under
  `IgnoresAccessChecksTo("Assembly-CSharp")`, which `Krafs.Publicizer` applies through the
  generated AssemblyInfo — switched off here by `GenerateAssemblyInfo=false`. Worth checking on
  any mod in the repository that turns that property off and writes a non-public field. The fix is
  `Source/AccessChecks.cs`.
- **The test that catches it does not read metadata, it performs the access.** Both comps
  construct outside the game, and the mod's own `Prefix` is called on one for real. A verdict
  raised by the CLR beats a verdict read off an attribute.

## A note for the next sweep

This file has been rewritten twice by automated passes, and the second one translated the fields
but dropped the closing `---` of the front matter along with `session` and `updated`. An
unterminated front matter is not a parse error anywhere, it just quietly turns the whole card into
prose. Worth a check after any bulk edit: three keys, one fence, `grep -c '^---$'` should return 2.

## Audit et prise en charge — 2026-09-12

Codex prend en charge ce seul dépôt et maintient ce STATUS.md à chaque changement
significatif, en distinguant les vérifications exécutées des validations restant à faire.

- Nom du mod : **Contented Livestock** ; auteur déclaré : **Nelim**.
- Dossier : `C:\Users\nelim\Documents\rimworld\ContentedLivestock`.
- packageId : `nelim.contentedlivestock`.
- Remote origin (fetch et push) : https://github.com/vbardales/Rimworld-Contented-Livestock.git
- Dépôt local autonome : `git rev-parse --show-toplevel` renvoie ce dossier ;
  son propre répertoire `.git` est aussi le git-common-dir. Ce dossier n'est pas
  un sous-dossier versionné par le monorepo ni un worktree de celui-ci.
- Visibilité : **public**, vérifiée le 2026-09-12 via l'API GitHub (`private: false`).
- Titre : aucun suffixe de reprise nécessaire. Selon ATTRIBUTION.md, c'est une
  création originale, pas une continuation ou une redistribution d'un autre mod.
- GitHub : lien présent dans `<url>` et désormais aussi dans `<description>` de
  `Mod/About/About.xml`, avec un lien BBCode vers les sources et les tickets.

### Licence et justification

**MIT**, texte identique dans `LICENSE` et `Mod/LICENSE` ; copyright 2026 Nelim.
Le champ historique `licence: original` décrit la provenance, pas le nom de la licence.
Selon ATTRIBUTION.md, aucun code, def, texture ou son d'un autre mod n'est repris.
L'inspiration de Stardew Valley est créditée à ConcernedApe, sans reprise déclarée
de ses fichiers. MIT correspond à l'intention déjà exprimée de permettre les
modifications et continuations, avec conservation de la notice de copyright et
de permission. Aucune nouvelle licence ni restriction n'est ajoutée par cet audit.
Cette justification repose sur la provenance documentée dans le dépôt.

### Vérifications réalisées et limites

- **21 tests automatisés réussis** le 2026-09-12 avec
  `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`.
  Exécution sur la DLL livrée et les assemblies du jeu installé ; ce résultat
  n'est pas une nouvelle compilation ni une validation en jeu.
- Couverture : cibles et signatures Harmony, accès aux membres non publics,
  contrat de production vanilla, neutralité sans besoin, paramètres par défaut,
  réinitialisation et clés de sauvegarde, liens DefOf et traductions EN/FR.
- XML : lecture de tous les XML livrés, champs du NeedDef vérifiés contre le jeu,
  types scalaires, classe du besoin, références DefOf, cibles DefInjected,
  clés de traduction et métadonnées GitHub. Aucun outil du monorepo n'est requis.
- Les 4 contrôles ajoutés aujourd'hui passent ; ils n'ont pas encore été soumis
  à des mutations. Les 12 mutations mentionnées dans le script sont historiques,
  et n'ont pas été rejouées pendant cet audit.
- **15 scénarios fonctionnels manuels présents**, numérotés 0 à 14 dans
  `_tools/FUNCTIONAL-SCENARIOS.md` : chargement, éligibilité, apprivoisement/vente,
  paramètres, cinq facteurs, vitesse de production, arrêt sans perte, récolte,
  ponte et sauvegarde/chargement, ajout/retrait du mod.
- **Validation en jeu toujours en attente** : aucun scénario manuel exécuté ici.
  Le chargeur XML du jeu, l'interface, les facteurs en situation et la production
  réelle doivent encore être validés. `tested_on` reste vide à cette fin.

## Surcouche Preview recomposée — 2026-09-12

- Illustration conservée, sans génération ni remplacement : `Art/Preview-source.png`
  reste l'original et sa copie identique `Art/Preview.png` est la source canonique
  sans texte. Aucune ancienne source n'a été écrasée.
- Image livrée : `Mod/About/Preview.png`, 896 × 504, 681 815 octets (< 900 Ko).
- Composition HTML/CSS et paramètres : `Art/preview.html` ; couleurs uniquement
  dans `Art/preview-palette.json`. `_tools/preview.html` redirige vers cette composition.
- Reproduction : `Art/render-preview.cjs`, avec Node, Playwright, Sharp et Chrome.
  Le script sert localement le dépôt, attend `document.fonts.ready` et le chargement
  de l'image, capture à la taille finale, puis mesure le fond sans les textes.
- Palette : voile issu du sol ardoise froid au-delà de la clôture ; accent vif
  vert issu de la pâture, dont la saturation et la clarté sont renforcées. Cette zone
  significative représente l'alimentation des animaux et se distingue de l'ambiance
  chaude dominante, contrairement au précédent accent orangé. Encre secondaire ocre dorée éclaircie, issue de la famille
  chaude dominante du sol, du bois et de la paille, et non d'une moyenne des pixels.
  Elle reste définie mais inutilisée : aucun tag pour ce mod public et original.
- Titre et résumé strictement conservés, même encre principale. Titre 46 px/600,
  deux lignes ; résumé 21 px/400, largeur 430 px. Bloc à (50, 54), filet 58 × 3,
  espacements 20 et 16 px. Ombres conformes au voile sombre de la charte.
- Voile elliptique localisé (900 × 430), opacité .90 au départ, .75 à 75 %, puis
  nulle à 100 % : maintien du contraste sans assombrir toute la scène.
- Badge triangulaire 80 × 80 ; centre des chiffres (869, 27), rotation 45°,
  26 px/700. Version 1.6 extraite des supportedVersions de l'About.xml livré.
- Police réellement employée vérifiée via Chrome DevTools : Segoe UI Semibold
  pour le titre, Segoe UI Regular pour le résumé, Segoe UI Bold pour la version.
  Aucun repli ; attente effective de document.fonts.ready avant capture.
- Contrastes sur le rendu sans texte : minimum sur TOUS les pixels des rectangles
  du titre et du résumé, donc contrôle plus large que les quatre coins ou glyphes.
  Titre 11,73:1 ; résumé 5,45:1 ; chiffres du badge 9,18:1 sur son fond opaque.
  Tag non applicable. Rapport reproductible : `Art/preview-qa.json` ; fond mesuré :
  `Art/preview-background.png`.
- Inspection visuelle effectuée à 896 × 504 et sur `Art/preview-268.png` : titre et
  version identifiables, filet visible, aucun chevauchement ni texte coupé.
- Recomposition commitée et poussée sur origin/main à la demande de l'utilisateur :
  `c147b65`. Aucune publication Workshop effectuée.

Le titre ne comporte ni préfixe/suffixe ni mot de liaison à réduire : les deux mots
« Contented Livestock » restent à 100 %, en encre principale identique au résumé.
La séparation du vert de l'accent et de l'ocre secondaire a été vérifiée visuellement
aux deux tailles de rendu. Les paramètres définitifs sont ceux des fichiers cités.
