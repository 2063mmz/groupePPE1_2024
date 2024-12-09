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