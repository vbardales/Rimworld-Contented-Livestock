---
mod:        Contented Livestock
packageId:  nelim.contentedlivestock
repo:       Rimworld-Contented-Livestock
visibility: public
detached:   yes
stage:      done
licence:    original
licence_at: an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the `LICENSE` is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic is Stardew Valley's, credited in ATTRIBUTION.md and reused from none of its lines.
showcase:   complete
tested_on:
workshop:
remaining:
  - unverified: never seen running in game. Cut down a great deal on 2026-09-11 by
    `_tools/Run-Functional-Tests.ps1`, 16 out-of-game tests, which found and had fixed a
    `FieldAccessException` thrown on every animal's first tick — the whole production half
    was inert behind a clean startup. What remains is the 15 scenarios of
    `_tools/FUNCTIONAL-SCENARIOS.md`, none played, starting with the zeroth: until it passes,
    the other fourteen prove nothing.
  - unverified: 5 of the 16 tests are about `Assembly-CSharp` itself and could not be seen to
    fail; the other 11 were, one mutation at a time. The file says which.
session:    local_d801c303-9176-464c-a49a-66893a87ae7b
updated:    2026-09-12, held by the mod's own session
---

# Contented Livestock — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The fields above were read off the disk on 2026-09-12, then taken over by the session that holds
this mod. The three a sweep cannot read:

- **`stage`** — `done`. The mod is complete, detached, its showcase is made and its tests are
  written. What is missing is a run in a game, which `tested_on` and `remaining` say, and which is
  not a build stage.
- **`tested_on`** — empty. Never launched, by standing instruction: the session prepares, she
  plays.
- **`remaining`** — two lines, both true on 2026-09-12. A third one said the showcase was engraved
  in black, from before that day's rule on the coloured veil; it was re-engraved the same day and
  the line is gone. The veil is `#242838`, the frozen ground beyond the fence, and the worst
  contrast behind the text measures 7.8:1 against a 4.5:1 floor.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` nothing reused.

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
