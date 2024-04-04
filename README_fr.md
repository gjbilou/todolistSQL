
# Projet TodoList

## Aperçu du Projet

Le projet TodoList est une application basée sur SQL visant à gérer et organiser des tâches à l'aide d'une base de données Oracle. Il est conçu pour démontrer une compréhension complète des systèmes de gestion de bases de données relationnelles (SGBDR) à travers la mise en œuvre de la création de tables, la manipulation de données, les contraintes d'intégrité, les déclencheurs et les procédures stockées. Ce projet fournit un exemple pratique de conception et de fonctionnalité de base de données.

## Objectif du Projet

L'objectif principal de ce projet est de créer une application de liste de tâches fonctionnelle qui utilise divers scripts SQL et procédures PL/SQL pour gérer les tâches efficacement. Il sert d'exemple de comment structurer une base de données, insérer et manipuler des données, et utiliser des fonctionnalités avancées de la base de données comme les déclencheurs et les procédures stockées pour automatiser les tâches au sein de la base de données.

## Prérequis

Avant de configurer le projet TodoList, vous devez avoir installé et configuré Oracle Database sur votre système. Ce projet est développé spécifiquement pour les environnements Oracle Database, nécessitant une familiarité avec la syntaxe et les fonctionnalités SQL d'Oracle, nous permettant d'utiliser PL/SQL.

## Instructions de Configuration

### Compilation de la Base de Données

Après avoir vérifié qu'Oracle Database est installé sur votre système, suivez ces étapes pour configurer le projet TodoList :

#### 1. Création de la Base de Données

Commencez par exécuter le script `MasterTodoList.sql` pour créer la structure principale de la base de données. Ce script initialise les tables nécessaires et les relations pour l'application de liste de tâches.

#### 2. Configuration des Tables

Exécutez le script `TodoListCreationTable.sql` pour créer toutes les tables requises selon le schéma du projet.

#### 3. Insertion des Données Exemplaires

Utilisez le script `TodoListInsertion.sql` pour peupler les tables avec des données exemples, essentielles à des fins de démonstration et de test.

#### 4. Mise en Œuvre des Déclencheurs et Procédures

Appliquez les scripts `TodoListTriggers.sql` et `TodoListProcedures.sql` pour incorporer des comportements automatisés et des procédures stockées dans votre base de données.

#### 5. Tests

Exécutez le `scriptTest.sql` pour tester la fonctionnalité de la base de données et vous assurer que tout est correctement configuré.

### Exécution du Projet

Avec la configuration d'Oracle Database et l'exécution des scripts initiaux, vous pouvez commencer à explorer l'application de liste de tâches. Utilisez `TodoListRequest.sql` pour les opérations courantes de la base de données telles que l'interrogation de tâches spécifiques.

## Ressources Supplémentaires

- Pour une explication détaillée de la conception et de la fonctionnalité du projet, référez-vous au `RapportPrt2.pdf`.
- Les dossiers `Modèle logique relationnel` et `contrainteIntergrite` contiennent une documentation précieuse sur le modèle logique de la base de données et les contraintes d'intégrité, respectivement.
