Touche leader : Espace

Espace + w : sauvegarde le fichier actuel

Espace + q : quitte la fenêtre ou Vim

Espace + h : efface la surbrillance de la recherche en cours

Espace + i : réindente tout le fichier et remet le curseur à sa position initiale

Espace + x : ferme le buffer actuel

Espace + e : ouvre l'explorateur de fichiers Netrw en arborescence à gauche

Espace + f : lance la commande :find avec recherche floue (fuzzy) dans le projet

Espace + g : lance la commande :grep avec ripgrep pour chercher du texte dans le projet


]b : passe au buffer suivant

[b : passe au buffer précédent


Ctrl + h : va dans la fenêtre de gauche

Ctrl + j : va dans la fenêtre du bas

Ctrl + k : va dans la fenêtre du haut

Ctrl + l : va dans la fenêtre de droite


Ctrl + d : descend d'un demi-écran et centre le curseur au milieu

Ctrl + u : monte d'un demi-écran et centre le curseur au milieu


J (en mode visuel) : déplace les lignes sélectionnées vers le bas et réindente

K (en mode visuel) : déplace les lignes sélectionnées vers le haut et réindente


:find motif : recherche floue de fichiers (jusqu'à 4 sous-dossiers, ignore .git, node_modules, venv, *.o, *.pyc)

:grep motif : cherche un mot dans tous les fichiers du projet et ouvre la liste des résultats (quickfix)
