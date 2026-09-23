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
