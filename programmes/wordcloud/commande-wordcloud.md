**Voici les étapes (version Linux):**

D'abord, entre dans ton environnement virtuel.

Ensuite, installe les bibliothèques wordcloud et pillow (si vous ne les avez pas déjà installées) :  *pip install wordcloud pillow* 

Utilise la commande wordcloud\_cli pour générer le nuage de mots. (C'est simple. Bien sûr, on peux aussi utiliser un script Python pour générer le nuage, mais la commande est plus pratique. :))

**En même temps, il existe une méthode plus pratique, qui consiste à utiliser ce site** : *https://www.nuagesdemots.fr/*

**La commande standard pour utiliser wordcloud :**

*wordcloud\_cli --text ./pals/contextes-lang(1|2|3|4).txt --imagefile lang(1|2|3|4).png --background white --fontfile ./programmes/wordcloud/nom-du-font.ttf --colormap 'cividis'*

**wordcloud_cli** : C'est l'outil en ligne de commande utilisé pour générer un nuage de mots.

**--text** ./pals/contextes-lang(1|2|3|4).txt : Ce paramètre spécifie le chemin du fichier contenant le texte.

**--imagefile lang(1|2|3|4).png** : Le nom du fichier image de sortie.

**--background white** : Définit la couleur de fond du nuage de mots

**--fontfile ./word-cloud/JosefinSans-MediumItalic.ttf** : Le chemin du fichier de police à utiliser pour le nuage de mots. J'ai aussi téléchargé d'autres polices et les ai placées dans le dossier 'wordcloud', pour le chinois peut utiliser *NotoSerifSC*.

**--colormap 'cividis'** : Définit le schéma de couleurs du nuage de mots. Il existe d'autres couleurs que vous pouvez utiliser : viridis', 'plasma', 'inferno', 'magma', 'cividis', 'twilight', 'hsv', 'coolwarm', 'Spring', 'Summer', 'Autumn', 'Winter'...

