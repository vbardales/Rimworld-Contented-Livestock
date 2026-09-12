---
mod:        Contented Livestock
packageId:  nelim.contentedlivestock
depot:      Rimworld-Contented-Livestock
visibilite: public
detache:    oui
etape:      done
licence:    original
licence_ou: création originale, MIT sans réserve. Rien n'est repris d'un autre mod, ni code, ni def, ni texture, ni son ; le `LICENSE` est un MIT nu, sans section de périmètre, donc les images de la vitrine y entrent aussi. La mécanique est celle de Stardew Valley, créditée dans l'ATTRIBUTION et reprise d'aucune de ses lignes.
vitrine:    complete
teste_le:
workshop:   
reste:
  - non_verifie: jamais vu tourner en jeu. Beaucoup réduit le 2026-09-11 par
    `_tools/Run-Functional-Tests.ps1`, 16 tests hors jeu, qui ont trouvé et fait corriger un
    `FieldAccessException` levé au premier tick de chaque animal — toute la moitié production
    était inerte derrière un démarrage propre. Restent les 15 scénarios de
    `_tools/FUNCTIONAL-SCENARIOS.md`, aucun joué, à commencer par le zéro : tant qu'il ne passe
    pas, les quatorze autres ne prouvent rien.
  - non_verifie: 5 des 16 tests portent sur `Assembly-CSharp` lui-même et n'ont pas pu être vus
    rouges ; les 11 autres l'ont été, une mutation à la fois. Le fichier dit lesquels.
  - feature: la vitrine est gravée en noir, d'avant la consigne du 2026-09-12 sur le voile en
    couleur. Source pleine résolution sous `Art/`, page de gravure dans `_tools/preview.html` :
    la reprise est une couleur à prélever et une encre à recalculer.
session:    local_d801c303-9176-464c-a49a-66893a87ae7b
maj:        2026-09-12, session du mod
---

# Contented Livestock — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

Les champs ci-dessus ont ete deduits du disque le 2026-09-12, puis repris par la session qui tient
ce mod. Les trois que le releve automatique ne pouvait pas remplir :

- **`etape`** — `done`. Le mod est complet, detache, sa vitrine est faite et ses tests sont ecrits.
  Ce qui manque est un essai en jeu, que `teste_le` et `reste` disent, et qui n'est pas une etape
  de fabrication.
- **`teste_le`** — vide. Jamais lance, conformement a la consigne : la session prepare, elle joue.
- **`reste`** — trois lignes, toutes vraies au 2026-09-12.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.

## Ce que ce mod a appris au depot, et qui depasse ce mod

Deux choses, gardees ici parce qu'elles servent au prochain qui passe :

- **Un mod compile contre `Krafs.Rimworld.Ref` peut etre entierement mort sans qu'aucun journal ne
  le dise.** Les champs non publics du jeu arrivent publics dans l'assemblage de reference, donc
  le code compile ; l'acces n'est legal a l'execution qu'avec
  `IgnoresAccessChecksTo("Assembly-CSharp")`, que `Krafs.Publicizer` pose via l'AssemblyInfo
  genere — supprime ici par `GenerateAssemblyInfo=false`. A verifier sur tout mod du depot qui
  coupe cette propriete et ecrit un champ non public. Correctif dans `Source/AccessChecks.cs`.
- **Le test qui l'attrape ne lit pas les metadonnees, il tente l'acces.** Les deux comps
  s'instancient hors du jeu et le `Prefix` du mod est appele dessus pour de vrai. Un verdict rendu
  par le CLR vaut mieux qu'un verdict lu dans un attribut.
