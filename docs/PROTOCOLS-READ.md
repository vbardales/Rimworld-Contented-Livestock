# Protocols read

What this session did not need to read, with the trigger that makes it worth reading, so that it does not reread
documents that moved without concerning the current state (`WELCOME.md`, point 5). The versions read are in
`protocols_read_sha` of `STATUS.md`. Last pass: **2026-10-10**, for the audit that put the mod at `playTests[1.0.0]`.

Read in full on 2026-10-10: `AGENTS.md`, `AUDIT.md`, `PICKLE.md`, `TRANSLATIONS.md`, `MOD_SETTINGS.md`,
`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`, `Rimworld-Ticket-Dispatcher/README.md` (registration part).

Not read on 2026-10-10, and why:

| File | Useful? | Trigger |
| --- | --- | --- |
| `PUBLISHING.md` | later | before `writeDocs` and the dry-run: description, thanks, gallery, CI sections |
| `STYLE_RIMWORLD.md` | no | only if an icon, a Preview or the echo is asked for (the owner generates the sources) |
| `WORKSHOP_COMMENTS.md` | no | only when the thanks drafts of `PUBLICATION.md` are posted (`followUp`) |
| `scripts/SEARCHING.md` | no | searching the mod corpus; this mod is original |
| `PickleTools/README.md`, `Headless/README.md`, `docs/steps.md` | partly | before writing a new step or a new pass map |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | when submitting | options and exit codes of `Submit-PickleRun.ps1` |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | later | before the dry-run |
| `GALLERY.md`, `GALLERY-PROPS.md` | later | at `shootGallery` (the cow with its tip picture) |
| `PUBLISHING-CI.md`, `ANIMALS.md`, `TOOLING-PITFALLS.md` | no | CI before publishing; no animal added; no multi-session commit here |
