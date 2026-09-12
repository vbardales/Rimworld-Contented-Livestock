---
mod:          Contented Livestock
packageId:    nelim.contentedlivestock
repo:         Rimworld-Contented-Livestock
visibility:   public
detached:     yes
stage:        done
licence:      original
license_spdx: MIT
licence_at:   an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the `LICENSE` is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic is Stardew Valley's, credited in ATTRIBUTION.md and reused from none of its lines.
dependencies: none
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: never seen running in game. Cut down a great deal on 2026-09-11 by
    `_tools/Run-Functional-Tests.ps1`, originally 17 out-of-game tests (21 after this audit), which found and had fixed a
    `FieldAccessException` thrown on every animal's first tick — the whole production half
    was inert behind a clean startup. What remains is the 15 scenarios of
    `_tools/FUNCTIONAL-SCENARIOS.md`, none played, starting with the zeroth: until it passes,
    the other fourteen prove nothing.
  - unverified: 5 of the original 17 tests are about `Assembly-CSharp` itself and could not be seen to
    fail; the other 12 were, one mutation at a time. The file says which.
session:      01a09726-7616-7ad2-bc3c-d94a8e24da95
updated:      2026-09-12, maintained by Codex in this standalone repository
---

# Contented Livestock — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The fields above were read off the disk on 2026-09-12, then taken over by the session that holds
this mod. The four a sweep cannot read:

- **`stage`** — `done`. The mod is complete, detached, its showcase is made and its tests are
  written. What is missing is a run in a game, which `tested_on` and `remaining` say, and which is
  not a build stage.
- **`tested_on`** — empty. Never launched, by standing instruction: the session prepares, she
  plays.
- **`dependencies`** — `none`. The mod needs nothing but RimWorld itself: no `modDependencies` at
  all, a `loadAfter` holding the six `Ludeon.RimWorld*` packages and nothing else, and an assembly
  that references only Assembly-CSharp, the Unity modules and HarmonyLib. The other values of the field are `declared` when every mod needed is named in the
  About, and `to check` when a non-vanilla `loadAfter` hints at one that is not. An undeclared
  dependency is not cosmetic: on 2026-09-11 Reequilibrage animaux took 47 vanilla animals down with
  it, Muffalo included, because the class it injects belongs to a mod that was neither declared nor
  loaded.
- **`remaining`** — two lines, both true on 2026-09-12. A third one said the showcase was engraved
  in black, from before that day's rule on the coloured veil; it was re-engraved the same day and
  the line is gone. The veil is `#242838`, the frozen ground beyond the fence, and the worst
  contrast behind the text measures 7.8:1 against a 4.5:1 floor.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` owing nothing
to anyone — not a name, not an idea traceable to one mod, not a value derived from its assets.

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

**MIT**, texte identique dans `LICENSE` et `Mod/LICENSE` ; copyright 2026 nelim.
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
