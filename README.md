# Miaou

Application test realisée en **5h35**  (+1h20 améliorations)

## Fonctions de l'application

- Affichage de la liste des races des chats récupérées depuis un API
- Informations sur la race selectionnée
- Fonction de recherche d'une race
- Support du mode hors-ligne (images et données)
- Carroussel d'images dans la fiche de la race seléctionnée
- Zoom sur les images

## Technologies Utilisées

- CoreData pour la gestion de la persistance des données
- WebService pour les appels API
- Network pour la détection de la connectivité réseau
- SwiftUI pour l'interface graphique

**Version de Swift** : 5.8
**Librairies externes** :  -


---

# Consignes

## Objectif

Une application qui présente à l'utilisateur des photos de chiens ou de chats (au choix) par espèces en lui permettant de naviguer à l'intérieur de ces catégories.

## Temps de realisation

Plusieurs heures mais pas plusieurs jours.

## Spécifications

  * Code en Swift 5.
  * Utiliser les APIs https://docs.thecatapi.com 🐈 ou https://dog.ceo/dog-api/ 🐕.
  * La première ouverture peut nécessiter internet pour charger une première fois les données nécessaires.
  * Un cache de données devra permettre une utilisation hors ligne de l'application après cette première ouverture (au moins sur les données consultées).
  * Pas de contrainte sur le niveau d'OS à supporter.
  * Tu as le droit d'utiliser toute librairie externe qui te semblera utile et adaptée.
  * Pas besoin de commenter le code si il est suffisamment explicite.
  * Bonus : trouver une espèce par une recherche (full-text, case insensitive, autocompletion)
