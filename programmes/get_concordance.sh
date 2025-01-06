#!/usr/bin/env bash
# CE SCRIPT EST APPELÉ PAR main.sh
# il prend un entre le mot recherché et le base ce qui est passé dans le script main.sh
# dans la partie CONCORDANCE GENERATION

## DEFINITION D'ARGUMENT D'ENTREE ##
if [[ $# -ne 2 ]]
then
    echo "Il manque exactement deux arguments"
    echo "Utilisation : get_concordance.sh <mot_a_rechercher> <base>"
    exit 1
fi

## DEFINITION DES VARIABLES GLOBALES ##
mot_a_rechercher=$1
base=$2

echo "<!DOCTYPE html>
<html>
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css\">
</head>
<body>
    <div class=\"table-container\">
      <table class=\"table is-bordered is-hoverable is-striped is-fullwidth\">
         <tr>
            <th>Contexte gauche</th>
            <th>Cible</th>
            <th>Contexte droit</th>
         </tr>"

## TACHE POUR FAIRE LA CONCORDANCE SELON LA LANGUE ##
while read -r line
do
    # FRANÇAIS
    if [[ "$base" == "lang1" ]]
    then
        gauche=""
        milieu=""
        droit=""
    fi

    # ESPAGNOL
    if [[ "$base" == "lang2" ]]
    then
        gauche=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher}s?)(.*)/\1/I")
        milieu=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher}s?)(.*)/\2/I")
        droit=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher}s?)(.*)/\3/I")
    fi

    # ANGLAIS
    if [[ "$base" == "lang3" ]]
    then
        gauche=""
        milieu=""
        droit=""
    fi

    # CHINOIS
    if [[ "$base" == "lang4" ]]
    then
        gauche=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher})(.*)/\1/")
        milieu=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher})(.*)/\2/")
        droit=$(echo "$line" | sed -E "s/(.*)(${mot_a_rechercher})(.*)/\3/")
    fi

    echo "                <tr>
                    <td>$gauche</td>
                    <td>$milieu</td>
                    <td>$droit</td>
                </tr>"
done

echo "      </table>
   </div>
</body>
</html>"
