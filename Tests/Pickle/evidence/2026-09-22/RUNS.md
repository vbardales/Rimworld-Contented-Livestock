# Pickle runs — 2026-09-22

All launches used `scripts/Run-PickleWsl.ps1`, the shared lock, WSL RimWorld and Xvfb.
Windows RimWorld was neither launched nor closed. The tested repository revision was `7716d99`
plus no source or test changes. RimWorld reported all staged mods loaded in every pass.

| Pass | Language/filter | Result |
| --- | --- | --- |
| `runtime-evidence` | English, whole companion | `exitReason: passed`; 6 passed, 0 failed, 3 RIMMSQOL scenarios skipped by requirement |
| `runtime-evidence` | French, whole companion | `exitReason: passed`; 6 passed, 0 failed, 3 RIMMSQOL scenarios skipped by requirement |
| `avec-rimmsqol` | English, `03-rimmsqol.feature` | `exitReason: passed`; 3 passed, 0 failed, 0 skipped |
| `runtime-evidence` | English, `04-animal-eligibility.feature` | `exitReason: passed`; 4 passed, 0 failed, 0 skipped |
| `avec-rimmsqol` | English, restart chain `05` -> `06` -> `07` | three fresh `exitReason: passed` reports; 1 passed, 0 failed, 0 skipped in each process |

The shared report directory is overwritten and the five-entry archive rotated while other queued
mods run. The English and French launcher results above were read directly at completion; their
two captures were copied here before rotation. The complete RIMMSQOL `summary.json`, `summary.md`,
JUnit report and Player.log are preserved beside this file. The later gameplay report is in
`gameplay/`; all three restart-chain reports are preserved separately in `restart/`.

## Human capture review

- `settings-english.png`: all eleven controls visible; headings, guidance, percentages, reset and
  close buttons readable; no raw key, clipping, overlap or unexpected fallback seen.
- `settings-french.png`: the corresponding French page is complete and readable, including accents
  and the longer scope paragraph; no raw key, clean-English literal, clipping or broken parameter seen.
- `settings-rimmsqol.png`: the revealed shortcut opened Contented Livestock's own settings page;
  its content matches the primary English page and is fully visible.

The RIMMSQOL scenarios also asserted its own list entry, initial hidden state, bar visibility,
settings-file visible/hidden states and final forget cleanup. The three-process chain established
that both revealed and hidden choices are reloaded after a restart before final cleanup. The
animal pass established live producer eligibility, producers-only refresh, faction transitions,
the 50% starting level, and representative 0%, 83% and 140% rate factors. The remainder of the
production, save/reload and option matrix stays documented in `_tools/FUNCTIONAL-SCENARIOS.md`.
