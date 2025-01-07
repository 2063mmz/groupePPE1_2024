#!/usr/bin/env bash
# NOTE
# Pour utiliser ce script allez dans le répertoire "programmes"
# Ensuite, tapez dans la ligne de commande :
# Par exemple, ./main.sh lang2.txt lang2
# Faire attention à ce que le script soit exécutable.

# VERIFICATION POUR L'OS
## C'est pour gérér le système d'exploitation macos qui ne gère pas tout comme linux sur la ligne 95-97
MAC="Darwin"

# RENDRE DES SCRIPTS EXTERIEURE EXECUTABLE
chmod +x ./get_concordance.sh

## DEFINTION D'ARGUMENT D'ENTREE
if [[ $# -ne 2 ]]
then
    echo "Il manque exactement deux arguments"
    echo "Utilisation : main.sh <nom_fichier_URL> <base>"
    exit 1
fi

fichier_urls=$1
base=$2

## DEFINTION DES VARIABLES GLOBALES ET DES CHEMINS DE SORTIE

# FRANÇAIS lang1
if [[ "$base" == "lang1" ]]
then
    mot_a_rechercher=""
    mot_pattern=""
    exec > "../tableaux/$base.html"
fi

# ESPAGNOL lang2
if [[ "$base" == "lang2" ]]
then
    mot_a_rechercher="suave"
    mot_pattern="\b($mot_a_rechercher|${mot_a_rechercher}s)\b" # match "suave" or "suaves" with word boundaries
    exec > "../tableaux/$base.html"
fi

# ANGLAIS lang3
if [[ "$base" == "lang3" ]]
then
    mot_a_rechercher="soft|sweet"
    mot_pattern="\b(soft[a-z]*|sweet[a-z]*)\b" # match "soft" "sweet" and their variations ("softness" ,  "sweetly")
    exec > "../tableaux/$base.html"
fi

# CHINOIS lang4
if [[ "$base" == "lang4" ]]
then
    mot_a_rechercher="柔"
    mot_pattern="柔"
    exec > "../tableaux/$base.html"
fi


## DEFINITION DE LA PAGE HTML ET AUTOMMATISATION DE CREATION ET ORGANISATION D'INFORMATION TEXTUELLE
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
            <th>Numero</th>
            <th>URL</th>
            <th>Code HTTP</th>
            <th>Encodage</th>
            <th>Aspiration</th>
            <th>Dump</th>
            <th>Occurrence</th>
            <th>Contexte</th>
            <th>Concordance</th>
         </tr>"

url_numero=0
while read -r line
do
    ((url_numero++))

    echo "Traitement de $line" >&2

    code_http=$(curl -s -I -L -w "%{http_code}" -o /dev/null $line) # extracts the http code
    if [[ "$code_http" -eq 200 ]]
    then

        if [[ "$(uname)" == "$MAC" ]]
        then
            encodage=$(curl -s -I -L "$line" | grep -i "charset=" | cut -d'=' -f2 | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        else
            encodage=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -P -o "charset=\S+" | cut -d"=" -f2 | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        fi

        aspiration="../aspirations/$base-$url_numero.html"
        contenu_html=$(curl -s -L "$line")

        # DANS LE CAS OÙ L'ENCODAGE N'EST PAS PRESENT DANS L'APPEL HTTP
        # ON CHERCHE DANS LA BALISE META DANS LE CONTENU OÙ L'INFO HTML DE LA PAGE EST STOCKÉ
        if [[ -z "$encodage" ]]
        then
            encodage=$(grep -i "<meta.*charset" "$contenu_html" | sed -E 's/.*charset="?([^";>]*)[";>].*/\1/' | tr '[:lower:]' '[:upper:]')
        fi

        # DANS LE CAS OÙ CE N'EST PAS DE l'UTF-8, ON LE CONVERTIT EN UTF-8
        if [[ "$encodage" != "UTF-8" ]]
        then
            echo "$contenu_html" | iconv -f "$encodage" -t UTF-8 > "$aspiration"
            echo "✓ Aspiration sauvegardée pour ligne $url_numero (Encodage converti de $encodage à UTF-8)" >&2
            encodage="UTF-8"
        else
            echo "$contenu_html" > "$aspiration"
            echo "✓ Aspiration sauvegardée pour ligne $url_numero (Encodage: UTF-8)" >&2
        fi

        # DUMP TEXT CONTENT
        dump_text="../dumps-text/$base-$url_numero.txt"
        if [[ "$base" == "lang4" ]]
        then
            contenu_dump=$(lynx -dump -nolist -assume_charset=GB18030 -display_charset=UTF-8 "$aspiration")
        else
            contenu_dump=$(lynx -dump -nolist -assume_charset=UTF-8 -display_charset=UTF-8 "$aspiration")
        fi

        # CLEAN DUMP TEXT
        # DEFINITION DU INFO TEXTUELLE QU'ON VEUT SUPRIMMER
        iframe="/IFRAME:/d"
        button="/(BUTTON)/d"
        mot_entre_brackets="/\[.*\]/d"
        links="/http/d"
        navigation="s/^[[:space:]]*//; /^(\*|\+) ([^ ]+ ){0,2}[^ ]*$/d"

        cleaned_contenu_dump=$(echo "$contenu_dump" | sed -E -e "$iframe" -e "$button" -e "$mot_entre_brackets" -e "$links" -e "$navigation")
        echo "$cleaned_contenu_dump" > "$dump_text"
        echo "✓ Dump text créé pour ligne $url_numero" >&2

        # OCCURRENCES
        occurrences=$(grep -o -i -E "$mot_pattern" <<< "$cleaned_contenu_dump" | wc -l)

        # CONTEXT EXTRACTION
        contexte="../contextes/$base-$url_numero.txt"
        contenu_contexte=$(echo "$cleaned_contenu_dump" | grep -i -E "$mot_pattern")
        echo "$contenu_contexte" > "$contexte"
        echo "✓ Contexte extrait pour ligne $url_numero ($occurrences occurrences trouvées)" >&2

        # CONCORDANCE GENERATION
        concordance="../concordances/$base-$url_numero.html"
        contenu_concordance=$(echo "$contenu_contexte" | ./get_concordance.sh "$mot_a_rechercher" "$base")
        echo "$contenu_concordance" > "$concordance"
        echo "✓ Concordance générée pour ligne $url_numero" >&2

        echo "                <tr>
                    <td>$url_numero</td>
                    <td><a href=\"$line\" target=\"_blank\">$line</a></td>
                    <td>$code_http</td>
                    <td>$encodage</td>
                    <td><a href=\"$aspiration\">html</a></td>
                    <td><a href=\"$dump_text\">dump-text</a></td>
                    <td>$occurrences</td>
                    <td><a href=\"$contexte\">contexte</a></td>
                    <td><a href=\"$concordance\">concordance</a></td>
                </tr>"
        echo "✓ Traitement complet pour ligne $url_numero: $line" >&2

    # SI L'URL NE RETOURNE PAS UN CODE HTTP 200, IGNORER ET AJOUTER UNE LIGNE AVEC 'INDISPONIBLE'
    else
        echo "✗ Échec du traitement pour ligne $url_numero: $line" >&2

        echo "                 <tr>
                    <td>$url_numero</td>
                    <td>$line</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                    <td>Indisponible</td>
                </tr>"
    fi
done <"../URLs/$fichier_urls"

echo "    </table>
   </div>
</body>
</html>"
