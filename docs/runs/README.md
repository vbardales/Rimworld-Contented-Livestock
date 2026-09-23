# Runs

One text file per day of testing, written by hand from the run reports. It is the only record of
a run that lives in git.

The evidence itself - Pickle reports, `Player.log`, screenshots, films - stays **on disk**, under
`Tests/Pickle/evidence/` and `Tests/Manual/evidence/`, and is ignored by git. It was 134 MB by the
second day, most of it PNGs and WebMs that never diff, and a single run once added an 80 MB HTML
report. Everything from 2026-09-22 and the first run of 2026-09-23 is still in the history, because
it was committed before this rule; nothing after that goes in.

What a summary here must carry, since the media are not beside it:

- the set (`setName`), the revision tested, `exitReason`, and discovered / passed / failed / skipped
- for a failure, the cause as read from the report, not the assumed one
- what a person actually opened and saw in the captures and films, and what they did not show
- where the media are on disk, so the next reader can find them

A summary without those is a claim, not a record. The evidence directory is not backed up: if the
machine is lost, these files and the history are what remains.

## What to keep, and how

The disk is shared by every mod, and evidence of a superseded build proves nothing about the current
one. So a run's evidence is cut down as soon as a newer one replaces it.

**Keep, for the revision now in the repository:**

- the four text files of the latest run of each set: `summary.json`, `summary.md`, `junit.xml`,
  `Player.log`
- one capture per asserted state, not one per step. Two features that photograph the same state keep
  one. A capture that shows no assertion (loading, a dialog in the way) goes
- a film only where the assertion depends on time, motion or a transition, and only the last one
- an older report only when it is the sole proof of a check the latest run did not repeat. Today:
  the RIMMSQOL reports and restart chain, the French settings capture, and scenario 10 attempt 02
  (that scenario needs FilmTicks, which the `runtime-evidence` set does not stage)

**Delete:** the whole-run `report.html` (about 80 MB) and `messages.ndjson` (about 9 MB), review
contact sheets derived from a film, earlier runs of the same set, failed attempts once their cause is
written in the daily summary, and anything about a revision the latest run replaced.

**Minify what stays.** Captures are kept as JPEG at `-q:v 3`, not PNG: about 250 KB instead of 3 MB,
and the small text in a need tip is still legible (checked on a live-tip capture at native size).
Review a capture at full size **before** converting it, then convert:

```bash
ffmpeg -i capture.png -q:v 3 capture.jpg && rm capture.png
```

A capture is evidence of what was seen, not of pixels, so lossy is fine here. It is not fine for
anything that will be measured or diffed later.

**Before deleting a report, check that no `STATUS.md` field points at it**, and repoint the field
first. Then add its line to the daily summary in this folder; that text is the history.
