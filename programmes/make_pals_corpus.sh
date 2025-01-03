#!/usr/bin/env bash

# pour utiliser ce script pour avoir le format de PALS pour les fichiers DUMP
# suit ce format ./make_pals_corpus.sh <dossier> <base>
# taper dans la ligne de commande par exemple ./make_pals_corpus.sh "../dumps-text" "lang2"

# pour utiliser ce script pour avoir le format de PALS pour les fichiers CONTEXTES
# taper dans la ligne de commande par exemple ./make_pals_corpus.sh "../contextes" "lang2"
# faire attention d'enlever la ligne de sortie pour la sortie de contextes dans le code et
# commenter la ligne pour la sortie des fichiers dumps-text

# CHECK ARGUMENTS
if [[ $# -ne 2 ]]
then
    echo "Il manque exactement deux arguments"
    echo "Utilisation : make_pals_corpus.sh <nom_de_dossier> <nom_de_base>" # ex: <dumps-text> <lang2>
    # taper dans la ligne de commande par ex ./make_pals_corpus.sh "../dumps-text" "lang2" mais pour votre langue
    exit 1
fi

## DEFINITION DE VARIABLES GLOBALES ##
# Arguments d'entrée
dossier=$1
base=$2

# Définition des fichiers pertinents à la tâche
fichiers=$(find "$dossier" -maxdepth 1 -type f -name "${base}-*.txt")
contenu_counter=0

# Chemins de sortie
sortie_pals_dumps="../pals/dumps-text-$base.txt"   # ex: dumps-text-lang2.txt
#sortie_pals_contextes="../pals/contextes-$base.txt" # ex: contextes-text-lang2.txt

## EXECUTION DE LA TÂCHE ##
for fichier in $fichiers
do
    ((contenu_counter++))

    while read -r line
    do
        # FRANÇAIS
        # if [[ "$base" == "lang1" ]]
        # then
        #     # Logic for lang1
        # fi

        # ESPAGNOL
        if [[ "$base" == "lang2" ]]
        then
            if [[ -z "$line" ]]
            then
                continue
            fi

            format_pals=$(echo "$line" | grep -o -E "\w+|[[:punct:]]")
            echo "$format_pals" >> "$sortie_pals_dumps"
        fi

        # ANGLAIS
        # if [[ "$base" == "lang3" ]]
        # then
        #     # Logic for lang3
        # fi

        # CHINOIS
        # if [[ "$base" == "lang4" ]]
        # then
        #     # Logic for lang4
        # fi

    done < "$fichier"
done
