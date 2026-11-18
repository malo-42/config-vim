# Config Vim

Touche leader : **Espace**

## Fichiers et fenêtres

| Touche | Action |
|---|---|
| `Espace + w` | Sauvegarde le fichier actuel |
| `Espace + q` | Quitte la fenêtre ou Vim |
| `Espace + h` | Efface la surbrillance de la recherche |
| `Espace + i` | Réindente tout le fichier et remet le curseur exactement où il était |
| `Espace + e` | Ouvre / ferme l'explorateur Netrw en arborescence à gauche |
| `Espace + f` | Lance `:find` avec recherche floue (fuzzy) dans le projet |
| `Espace + g` | Lance `:grep` avec ripgrep et ouvre la liste des résultats (quickfix) |
| `Ctrl + h` | Va dans la fenêtre de gauche (marche aussi depuis Netrw) |
| `Ctrl + j` | Va dans la fenêtre du bas |
| `Ctrl + k` | Va dans la fenêtre du haut |
| `Ctrl + l` | Va dans la fenêtre de droite (marche aussi depuis Netrw) |
| `Ctrl + d` | Descend d'un demi-écran et centre le curseur |
| `Ctrl + u` | Monte d'un demi-écran et centre le curseur |
| `J` (mode visuel) | Déplace les lignes sélectionnées vers le bas et réindente |
| `K` (mode visuel) | Déplace les lignes sélectionnées vers le haut et réindente |

## Buffers (les « onglets » de la barre du haut)

Chaque onglet affiche son numéro (`1:main.c  2:utils.c +`). Le `+` indique un fichier modifié non sauvegardé.

| Touche | Action |
|---|---|
| `H` / `L` | Buffer précédent / suivant (gauche / droite) |
| `[b` / `]b` | Pareil que `H` / `L` |
| `Espace + 1` à `9` | Va directement au buffer portant ce numéro |
| `Espace + Espace` | Alterne avec le dernier buffer utilisé |
| `Espace + b` | Choisir un buffer par son nom (tape quelques lettres puis `Tab`) |
| `Espace + x` | Ferme le buffer actuel (refuse s'il n'est pas sauvegardé) |
| `Espace + X` | Ferme tous les buffers sauf l'actuel (garde ceux non sauvegardés) |

## Commandes

- `:find motif` : recherche floue de fichiers sur 4 niveaux de dossiers maximum (ignore `.git`, `node_modules`, `venv`, `*.o`, `*.pyc`).
- `:grep motif` : cherche un mot dans tous les fichiers du projet et ouvre la liste des résultats.

## Notes

- `H` et `L` remplacent les commandes natives « haut / bas de l'écran », rarement utilisées.
- Les numéros 10 et plus s'affichent dans la barre mais n'ont pas de raccourci : utilise `Espace + b`.
- Le fuzzy find demande Vim 9.1 ou plus récent (sinon `:find` classique).
- Pour installer : copier le fichier `vimrc` vers `~/.vimrc`.
