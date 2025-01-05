#!/usr/bin/env bash

# CHECK ARGUMENTS
if [[ $# -ne 2 ]]
then
    echo "Il manque exactement deux arguments"
    echo "Utilisation : make_itrameur_corpus.sh <nom_de_dossier> <nom_de_base>" # ex: <contextes> <lang2>
    exit 1
fi

## DEFINITION DE VARIABLES GLOBALES ##
dossier=$1
base=$2

# Language mapping with if statements
if [[ "$base" == "lang1" ]]
then
    lang="fr"
fi
if [[ "$base" == "lang2" ]]
then
    lang="es"
fi
if [[ "$base" == "lang3" ]]
then
    lang="en"
fi
if [[ "$base" == "lang4" ]]
then
    lang="zh"
fi

# File path handling with if statements
if [[ "$dossier" == "dumps-text" ]]
then
    fichiers=$(find "../$dossier" -maxdepth 1 -type f -name "${base}-*.txt")
    sortie_itrameur="../itrameur/dumps-text-$base.txt"
fi
if [[ "$dossier" == "contextes" ]]
then
    fichiers=$(find "../$dossier" -maxdepth 1 -type f -name "${base}-*.txt")
    sortie_itrameur="../itrameur/contextes-$base.txt"
fi

echo "<lang=\"$lang\">" > "$sortie_itrameur"

contenu_counter=0
for fichier in $fichiers
do
    ((contenu_counter++))

    contenu=$(cat "$fichier" | sed 's/&/\&amp;/g' | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g')

    {
        echo "<page=\"$lang-$contenu_counter\">"
        echo "<text>"
        echo "$contenu"
        echo "</text>"
        echo "</page>§"
    } >> "$sortie_itrameur"
done

# Close language tag
echo "</lang>" >> "$sortie_itrameur"