# Config Vim

Touche leader : **Espace**

Config pensée pour le **C** (norminette) et le **Python** (flake8 / mypy), pour Fedora (WSL ou natif).

## Installation (Fedora)

### 1. Installer Vim, ripgrep et pip

```bash
sudo dnf install vim-enhanced ripgrep python3-pip
```

Vérifier la version de Vim (9.1 ou plus pour le fuzzy find) :

```bash
vim --version | head -n 1
```

### 2. Installer la config

Depuis le dossier qui contient le fichier `vimrc` :

```bash
cp vimrc ~/.vimrc
```

Si tu avais déjà un `~/.vimrc` à garder, sauvegarde-le avant :

```bash
cp ~/.vimrc ~/.vimrc.bak
```

Vérifier que c'est la bonne version (doit afficher 1 ou plus) :

```bash
grep -c python_highlight_all ~/.vimrc
```

Le dossier `~/.vim/undodir` est créé automatiquement au premier lancement de Vim.

### 3. Installer flake8 et mypy

```bash
sudo dnf install python3-flake8 python3-mypy
```

Si ces paquets ne sont pas disponibles, passe par pip :

```bash
python3 -m pip install --user flake8 mypy
```

Si pip refuse (erreur `externally-managed-environment`), utilise un venv :

```bash
python3 -m venv ~/.venv
~/.venv/bin/pip install flake8 mypy
```

Avec le venv, active-le avant d'utiliser flake8 ou mypy :

```bash
source ~/.venv/bin/activate
```

### 4. Vérifier que tout marche

```bash
python3 -m flake8 --version
python3 -m mypy --version
rg --version
```

Ouvrir un fichier Python :

```bash
vim test.py
```

Dans Vim :

```vim
:echo g:python_highlight_all
```
```vim
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')
```

- La première commande doit afficher `1`.
- La seconde affiche le nom du groupe de coloration sous le curseur. Utile si une couleur ne s'applique pas : ajoute alors une ligne `highlight NomDuGroupe guifg=#xxxxxx ctermfg=NNN` dans la section Python du `~/.vimrc`.

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

## Python

Actif automatiquement dans les fichiers `.py` :

- Indentation de 4 espaces, sans tabulations.
- Coloration façon VSCode dark : mots-clés, appels de fonctions, builtins, décorateurs, `self` / `cls`, attributs (`self.x`), nombres, chaînes, commentaires.
- Les espaces en fin de ligne et les erreurs d'indentation sont surlignés en rouge.

flake8 et mypy se lancent dans le terminal :

```bash
python3 -m flake8 fichier.py
python3 -m mypy fichier.py
```

## Commandes

- `:find motif` : recherche floue de fichiers sur 4 niveaux de dossiers maximum (ignore `.git`, `node_modules`, `venv`, `*.o`, `*.pyc`).
- `:grep motif` : cherche un mot dans tous les fichiers du projet et ouvre la liste des résultats.
- `:copen` / `:cclose` : ouvre / ferme la liste des résultats (quickfix).
- `:cnext` / `:cprev` : va au résultat suivant / précédent.
- `:cc 3` : va directement au résultat n°3 de la liste.

Dans la liste des résultats, `Entrée` sur une ligne saute à l'endroit concerné.

## Notes

- `H` et `L` remplacent les commandes natives « haut / bas de l'écran », rarement utilisées.
- Les numéros 10 et plus s'affichent dans la barre mais n'ont pas de raccourci : utilise `Espace + b`.
- Le fuzzy find demande Vim 9.1 ou plus récent (sinon `:find` classique).
- `Espace + i` utilise l'indentation automatique de Vim. En Python, relis le résultat avant de sauvegarder : les lignes de continuation (arguments sur plusieurs lignes) peuvent être réalignées différemment de ce que flake8 attend.
- Vim ne colore pas les variables « simples » (`x = 3`) comme VSCode : il faudrait un client LSP pour ça.
- Si les couleurs ne changent pas après une modification, ferme et rouvre le fichier (`:e`).
