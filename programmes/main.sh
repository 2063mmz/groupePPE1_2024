#!/usr/bin/env bash
# NOTES
# pour utiliser ce script
# aller dans le repertoire programmes
# ensuite taper dans la ligne de commande :
# par exemple, ./main.sh "../URLs/lang2.txt" "lang2"
# faire attention que le script est executable

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
    mot_a_rechercher=""
    mot_pattern=""
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

count=0
while read -r line
do
    ((count++))

    echo "Traitement de $line" >&2

    # entete=$(curl -s -I -L "$line") # HTTP Header Request -> gets the server response. Server response is stored in this variable.
    # code_http=$(echo "$entete" | head -n 1 | cut -d' ' -f2) # extracts the http code
    code_http=$(curl -s -I -L -w "%{http_code}" -o /dev/null $line) # extracts the http code
    # if [[ "200" == "$code_http" ]]
    if [[ "$code_http" -eq 200 ]]
    then
        # encodage=$(echo "$entete" | grep -i "charset=" | cut -d'=' -f2 | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -P -o "charset=\S+" | cut -d"=" -f2 | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        aspiration="../aspirations/$base-$count.html"
        contenu_html=$(curl -s -L "$line")
        echo "$contenu_html" > "$aspiration"
        echo "✓ Aspiration sauvegardée pour ligne $count" >&2

        # DANS LE CAS OÙ L'ENCODAGE N'EST PAS PRESENT DANS L'APPEL HTTP
        # ON CHERCHE DANS LA BALISE META DANS LE FICHIER QUI CONTIENT L'INFO HTML DE LA PAGE
        if [[ -z "$encodage" ]]
        then
            encodage=$(grep -i "<meta.*charset" "$aspiration" | sed -E 's/.*charset="?([^";>]*)[";>].*/\1/' | tr '[:lower:]' '[:upper:]')
        fi

        # DANS LE CAS OÙ IL N'EST PAS ENCORE PRESENT ON CONTINUE À TRAITER LA SUIVANTE URL.
        if [[ -z "$encodage" ]]
        then
            echo "Encodage non trouvé pour $line. Continuation..." >&2
            ((count--))
            continue
        elif [[ "$encodage" != "UTF-8" ]]
        then
            echo "$contenu_html" | iconv -f "$encodage" -t UTF-8 > "$aspiration"
            echo "✓ Aspiration sauvegardée pour ligne $count (Encodage converti de $encodage à UTF-8)" >&2
            encodage="UTF-8"
        else
            echo "$contenu_html" > "$aspiration"
            echo "✓ Aspiration sauvegardée pour ligne $count (Encodage: UTF-8)" >&2
        fi

        # DUMP TEXT CONTENT
        dump_text="../dumps-text/$base-$count.txt"
        if [[ "$base" == "lang4" ]]
        then
            contenu_dump=$(lynx -dump -nolist -assume_charset=GB18030 -display_charset=UTF-8 "$aspiration")
        else
            contenu_dump=$(lynx -dump -nolist -assume_charset=UTF-8 -display_charset=UTF-8 "$aspiration")
        fi

        # CLEAN DUMP TEXT
        # DEFINITION DU INFO TEXTUELLE QU'ON VEUT SUPRIMMER
        iframe="/^IFRAME/d"
        button="/(BUTTON)/d"
        mot_entre_brackets="/\[.*\]/d"
        links="/^http/d"
        navigation="s/^[[:space:]]*//; /^(\*|\+) ([^ ]+ ){0,2}[^ ]*$/d"

        cleaned_contenu_dump=$(echo "$contenu_dump" | sed -E -e "$iframe" -e "$button" -e "$mot_entre_brackets" -e "$links" -e "$navigation")
        echo "$cleaned_contenu_dump" > "$dump_text"
        echo "✓ Dump text créé pour ligne $count" >&2


        # OCCURRENCES
        # occurrences=$(echo "$cleaned_contenu_dump" | grep -o -i -E "$mot_pattern" | wc -l)
        occurrences=$(grep -o -i -E "$mot_pattern" <<< "$cleaned_contenu_dump" | wc -l)

        # CONTEXT EXTRACTION
        contexte="../contextes/$base-$count.txt"
        contenu_contexte=$(echo "$cleaned_contenu_dump" | grep -i -E "$mot_pattern")
        echo "$contenu_contexte" > "$contexte"
        echo "✓ Contexte extrait pour ligne $count ($occurrences occurrences trouvées)" >&2

        # CONCORDANCE GENERATION
        concordance="../concordances/$base-$count.html"
        contenu_concordance=$(echo "$contenu_contexte" | ./get_concordance.sh "$mot_a_rechercher" "$base")
        echo "$contenu_concordance" > "$concordance"
        echo "✓ Concordance générée pour ligne $count" >&2

        echo "                <tr>
                    <td>$count</td>
                    <td><a href=\"$line\" target=\"_blank\">$line</a></td>
                    <td>$code_http</td>
                    <td>$encodage</td>
                    <td><a href=\"$aspiration\">html</a></td>
                    <td><a href=\"$dump_text\">dump-text</a></td>
                    <td>$occurrences</td>
                    <td><a href=\"$contexte\">contexte</a></td>
                    <td><a href=\"$concordance\">concordance</a></td>
                </tr>"
        echo "✓ Traitement complet pour ligne $count: $line" >&2
    else
        echo "✗ Échec du traitement pour ligne $count: $line" >&2

        echo "                 <tr>
                    <td>$count</td>
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
done <"$fichier_urls"

echo "    </table>
   </div>
</body>
</html>"