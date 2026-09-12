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
automated_tests: 21 passed (2026-09-12)
manual_scenarios: 15 documented, 0 executed
remaining:
  - "Exécuter en jeu les scénarios 0 à 14 de _tools/FUNCTIONAL-SCENARIOS.md, en commençant par le chargement et les patches."
  - "Renseigner tested_on avec la version du jeu et les résultats après validation manuelle."
  - "Limite des tests : 5 contrats du jeu et 4 nouveaux contrôles XML/métadonnées non soumis à mutations ; 12 mutations historiques documentées, non rejouées pendant cet audit."
session:      01a09726-7616-7ad2-bc3c-d94a8e24da95
updated:      2026-09-13, maintained by Codex in this standalone repository
---

# Contented Livestock — status

## État actuel — 2026-09-13

Maintenu par Codex pour ce dépôt local autonome. Ce fichier reste à la racine,
hors de `Mod/`, et n'est pas livré au Workshop.

- **Développement : terminé** (`stage: done`), validation en jeu encore attendue.
- **Visibilité : public ; licence : original ; licence juridique : MIT.**
  Provenance et justification détaillées ci-dessous.
- **Tests automatisés : 21/21 réussis**, XML compris, lors de l'audit du 2026-09-12.
  Aucun nouveau lancement de tests pour cette actualisation documentaire.
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
