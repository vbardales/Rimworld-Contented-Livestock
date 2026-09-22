# Pickle runs — 2026-09-22

All launches used `scripts/Run-PickleWsl.ps1`, the shared lock, WSL RimWorld and Xvfb.
Windows RimWorld was neither launched nor closed. The tested repository revision was `7716d99`
plus no source or test changes. RimWorld reported all staged mods loaded in every pass.

| Pass | Language/filter | Result |
| --- | --- | --- |
| `runtime-evidence` | English, whole companion | `exitReason: passed`; 6 passed, 0 failed, 3 RIMMSQOL scenarios skipped by requirement |
| `runtime-evidence` | French, whole companion | `exitReason: passed`; 6 passed, 0 failed, 3 RIMMSQOL scenarios skipped by requirement |
| `avec-rimmsqol` | English, `03-rimmsqol.feature` | `exitReason: passed`; 3 passed, 0 failed, 0 skipped |

The shared report directory is overwritten and the five-entry archive rotated while other queued
mods run. The English and French launcher results above were read directly at completion; their
two captures were copied here before rotation. The complete RIMMSQOL `summary.json`, `summary.md`,
JUnit report and Player.log are preserved beside this file.

## Human capture review

- `settings-english.png`: all eleven controls visible; headings, guidance, percentages, reset and
  close buttons readable; no raw key, clipping, overlap or unexpected fallback seen.
- `settings-french.png`: the corresponding French page is complete and readable, including accents
  and the longer scope paragraph; no raw key, clean-English literal, clipping or broken parameter seen.
- `settings-rimmsqol.png`: the revealed shortcut opened Contented Livestock's own settings page;
  its content matches the primary English page and is fully visible.

The RIMMSQOL scenarios also asserted its own list entry, initial hidden state, bar visibility,
settings-file visible/hidden states and final forget cleanup. They do not establish persistence
across a separate process restart. Animal husbandry, production, save/reload and option effects
remain in `_tools/FUNCTIONAL-SCENARIOS.md` and are not claimed by these runs.
