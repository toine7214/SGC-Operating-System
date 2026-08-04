   _____  _____   _____    ___   _____
  / ____|/ ____| / ____|  / _ \ / ____|
 | (___ | |  __ | |      | | | | (___
  \___ \| | |_ || |      | | | |\___ \
  ____) | |__| || |____  | |_| |____) |
 |_____/ \_____(_)_____|  \___/|_____/

         Stargate Operating System
		v0.2.1
		
> Un système d'exploitation modulaire pour les Portes des Étoiles sous ComputerCraft.

SGC Operating System (SGC OS) est un système d'exploitation modulaire développé pour **ComputerCraft: Tweaked** et **SGJourney**.

Il fournit une interface graphique complète permettant de contrôler une Porte des Étoiles directement depuis un ordinateur ComputerCraft.

Version actuelle : **v0.2.1 Stable**

---

## Fonctionnalités

### Composeur

- Composition d'une adresse Stargate
- Animation de composition
- Affichage de la progression
- Annulation de la composition
- Déconnexion de la porte

### Carnet d'adresses

- Consultation des destinations
- Ajout de nouvelles destinations
- Suppression de destinations
- Composition directe depuis le carnet

### Contrôle de l'Iris

- Ouverture
- Fermeture
- Arrêt du mouvement
- Affichage de l'état en temps réel

### Diagnostic

Informations complètes sur la porte :

- Génération
- Variante
- Point d'origine
- Niveau d'énergie
- État de connexion
- État de l'Iris

### Paramètres

Informations système :

- Version
- Interface Stargate
- Informations matérielles

---

## Architecture

```
startup.lua

sgc/
├── bootstrap.lua
├── sgc.lua
├── apps/
├── lib/
└── data/
```

Le système est entièrement modulaire.

Les applications chargent leurs bibliothèques via :

```lua
SGC.load("lib.gate")
```

---

## Compatibilité

Développé pour :

- ComputerCraft: Tweaked
- SGJourney

Version testée :

- Minecraft 1.20.1

---

## Installation

Copier :

```
startup.lua
```

ainsi que le dossier :

```
sgc/
```

à la racine de l'ordinateur ComputerCraft.

Redémarrer ensuite l'ordinateur.

Le système démarre automatiquement.

---

## Feuille de route

### Version 0.3

Fonctionnalités prévues :

- Modification des adresses
- Historique des connexions
- Configuration persistante
- Détection automatique des périphériques
- Support des moniteurs externes
- Amélioration de l'interface utilisateur

---

## Développement

Projet créé par :

**toine7214**

Développé avec l'assistance de **ChatGPT (OpenAI)**.

---

## Licence

Distribué sous licence MIT.

Voir le fichier **LICENSE** pour plus d'informations.