#!/usr/bin/env bash

# CHECK ARGUMENTS
if [[ $# -ne 2 ]]
then
    echo "Il manque exactement deux arguments"
    echo "Utilisation : make_pals_corpus.sh <nom_de_dossier> <nom_de_base>" # ex: <dumps-text> <lang2>
    exit 1
fi

## DEFINITION DE VARIABLES GLOBALES ##
# Arguments d'entrée
dossier=$1
base=$2

# Définition des fichiers et la sortie
if [[ "$dossier" == "dumps-text" ]]
then
    fichiers=$(find "../$dossier" -maxdepth 1 -type f -name "${base}-*.txt")
    sortie_pals_dumps="../pals/dumps-text-$base.txt"
fi
if [[ "$dossier" == "contextes" ]]
then
    fichiers=$(find "../$dossier" -maxdepth 1 -type f -name "${base}-*.txt")
    sortie_pals_contextes="../pals/contextes-$base.txt"
fi

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
            echo "$format_pals" >> "$sortie_pals_contextes"
        fi

        # ANGLAIS
        if [[ "$base" == "lang3" ]]
        then
            if [[ -z "$line" ]]
            then
                continue
            fi
            format_pals=$(echo "$line" | grep -o -E "\w+|[[:punct:]]")
            echo "$format_pals" >> "$sortie_pals_contextes"
        fi

        # CHINOIS
        if [[ "$base" == "lang4" ]]
        then
            if [[ -z "$line" ]]
            then
                continue
            fi
        
            format_pals=$(echo "$line" | grep -o -P "[\p{Han}]|[[:punct:]]")
            echo "$format_pals" >> "$sortie_pals_dumps"
        fi

    done < "$fichier"
done
