## Sélection du mot et des langues
### Le mot : Douceur
Après beaucoup de déliberation, on a décidé de choisir le mot "douceur".
 Un outil qui nous a aidés avec la décision finale est :
- Le Centre National de Ressources Textuelles et Lexicales
    - https://www.cnrtl.fr/definition/douceur
    - C'est un outil crée par les laboratoires français, il est riche en informations sur la langue française !

On a choisi "douceur" vu qu'on a eu un aperçu de sa richesse de sens. On a constaté que cela devrait être un mot qui aurait plein de contextes différents, surtout dans nos quatre langues.

### Les langues :
Pour les langues, on voulait inclure celles qu'on parle et rassembler des contextes les plus variés possibles où notre mot apparaît.
- Le français
- L'espagnol
- L'anglais
- Le chinois


## Corpus - Langue2 : l'espagnol

### Stratégie des URLs
Je souhite prendre en compte la diversité des contextes où l'espagnol est utilisé.

#### Utilisation d'un VPN :
- Me mettre à la place d'une personne résidant dans un pays où l'espagnol est la langue principale, afin d'accéder à des résultats spécifiques à cette région.
#### Collecte géographique et culturelle
- Identifier et sélectionner des exemples d'utilisation du mot "douceur" dans différents pays hispanophones, en visant d'avoir plus de diversité où le mot apparaît.
- Étant limitée à 50 URLs, j’ai fait de mon mieux pour choisir des sources variées et représentatives.

### Modifications au script bash
- stderr >&2
    - Au début, j'avais simplement mis un echo avec l'erreur, mais après quelques tests, je me suis aperçue qu'il s'affichait dans le HTML du tableau.
- Optimisation de mon script :
    - j'ai déplacé stdout_b après la déclaration conditionnelle if, car je veux lancer le processus de récupération des données de la page seulement si elle a un code HTTP 200.

- L'encodage pour quelqeues sites sont en minuscule.
    - J'ai ajouté `| tr '[:lower:]' '[:upper:]'` pour regler le problème.

### Défi avec des URLs (solutions à venir)
- Quelques autres sites font partie des URLs non traitées, notamment Reddit et Medium. Je me demande pourquoi, bien que j'aie peut-être une idée à ce sujet. De toute façon, je sais quels types de contextes je cherche, donc je vais les rechercher sur d'autres sites.

- Un site en particulier montre qu'il n'a que deux mots. Après avoir examiné son code, j'ai remarqué qu'il contient bien des informations textuelles, mais elles ne sont pas détectées.
- J'ai un site qui est traité, mais le script n'arrive pas à récupérer son encodage, alors qu'il réussit pour tous les autres sites. Il me faudra inspecter le cas de cette URL dans le terminal, notamment l'emplacement de l'encodage dans l'entête, afin de voir si l'encodage est organisé différemment de ce que l'on attend.

## Corpus - Langue 3 : Anglais

### Stratégie et collecte d'URL
Inclusion de sites de pays anglophones variés (e.g., États-Unis, Royaume-Uni, Canada).
Focus sur des textes littéraires et des blogs pour observer des nuances dans l'usage du mot. Un nombre important d'usages informels qui se distinguent. Ces usages reflètent souvent des expressions culturelles, des phrases idiomatiques et un langage décontracté.

## Scripts développés
-main.sh
Ce script est l'épine dorsale du projet. Il traite chaque URL, extrait des informations et remplit le tableau HTML. Les principales étapes sont les suivantes :

Validation de l'URL qui ne tient pas compte des URL inaccessibles avec enregistrement des messages d'erreur. Le téléchargement HTML permet d'enregistrer les pages dans les aspirations. Extraction de texte, qui déverse le texte nettoyé dans dumps-text. L'analyse des mots-clés, qui compte les occurrences et extrait le contexte vers les contextes et la population des tableaux, met à jour les tableaux/ avec les données traitées.

-get_concordance.sh
Ce script génère des concordances au format HTML. Il divise le texte en trois colonnes (contexte gauche,mot-clé,contexte droit)

-make_pals_corpus.sh
Ce script convertit les fichiers texte traités dans un format adapté à l'analyse textométrique PALS. 

## Étapes suivantes
-Récupération de données:
Utilisation de curl pour récupérer des pages HTML.
-Prétraitement du texte:
Extraction du texte brut à l'aide de lynx.
Nettoyage des caractères inutiles avec sed.
-Analyse des mots-clés:
Comptage des occurrences de mots-clés à l'aide de grep.
Extraction du contexte avec les lignes environnantes.
-Concordances:
Transformation du texte en concordance à l'aide de sed.
-Préparation PALS:
Création de fichiers compatibles avec l'EPLA en vue d'une analyse ultérieure.
-Génération de nuages de mots:
Utilisation de wordcloud_cli pour générer des nuages de mots à partir de fichiers contextuels.
Sauvegarde des images dans le dossier nuages.

## Analyse et Résultats

Visualisation : Nuages de Mots
Pour chaque langue, un nuage de mots a été généré avec wordcloud_cli pour identifier les termes et concepts les plus associés au mot "douceur".

## Défis
-Problèmes d'encodage : Certaines URL ne comportaient pas d'encodage de caractères dans les en-têtes. Nous avons résolu ce problème en extrayant l'encodage des balises <meta> ou en convertissant en UTF-8 à l'aide d'iconv.
-Fichiers de contexte vides : Nous avons identifié et traité les cas où les URL n'avaient pas de contenu pertinent.
-Duplication de fichiers : Nous avons veillé à ce que les scripts effacent les fichiers de sortie existants avant d'ajouter de nouvelles données.
