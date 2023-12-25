

-- Remplissage de la table UTILISATEUR
INSERT INTO UTILISATEUR (nom, prenom, adresse, motDePasse, dateNaissance) VALUES ('ahmad', 'ahmad', 'Maroc', 'Passw0rd', TO_DATE('01-JAN-1991', 'DD-MON-YYYY'));
INSERT INTO UTILISATEUR (nom, prenom, adresse, motDePasse, dateNaissance) VALUES ('ilyass', 'ilyass', 'France', 'Passw0rd', TO_DATE('01-JAN-1992', 'DD-MON-YYYY'));
INSERT INTO UTILISATEUR (nom, prenom, adresse, motDePasse, dateNaissance) VALUES ('Jean', 'Pean', 'France', 'Passw0rd', TO_DATE('01-JAN-1993', 'DD-MON-YYYY'));
INSERT INTO UTILISATEUR (nom, prenom, adresse, motDePasse, dateNaissance) VALUES ('Fo', 'Po', 'Chine', 'Passw0rd', TO_DATE('01-JAN-1994', 'DD-MON-YYYY'));
INSERT INTO UTILISATEUR (nom, prenom, adresse, motDePasse, dateNaissance) VALUES ('Trump', 'John', 'USA', 'Passw0rd', TO_DATE('01-JAN-1995', 'DD-MON-YYYY'));

-- Remplissage de la table PROJET
INSERT INTO PROJET (nomProjet, DescriptionProjet, idCreateur) VALUES ('Projet Alpha', 'Description du Projet Alpha', 1);
INSERT INTO PROJET (nomProjet, DescriptionProjet, idCreateur) VALUES ('Projet Omega', 'Description du Projet Omega', 2);
INSERT INTO PROJET (nomProjet, DescriptionProjet, idCreateur) VALUES ('Projet Beta', 'Description du Projet Beta', 2);
INSERT INTO PROJET (nomProjet, DescriptionProjet, idCreateur) VALUES ('Projet Pi', 'Description du Projet Pi', 4);
INSERT INTO PROJET (nomProjet, DescriptionProjet, idCreateur) VALUES ('Projet Meta', 'Description du Projet Meta', 5);

-- Remplissage de la table TACHE
INSERT INTO TACHE (intitulé, description, dateEcheance, categorie, status, idCreateur, idProjet) VALUES ('Tache 1', 'Description de la tache 1', SYSDATE + 7, 'Categorie1', 0, 1, 1);
INSERT INTO TACHE (intitulé, description, dateEcheance, categorie, status, idCreateur, idProjet) VALUES ('Tache 2', 'Description de la tache 1', SYSDATE + 30, 'Categorie1', 0, 1, 2);
INSERT INTO TACHE (intitulé, description, dateEcheance, categorie, status, idCreateur, idProjet) VALUES ('Tache 3', 'Description de la tache 1', SYSDATE + 90, 'Categorie1', 0, 1, 2);
INSERT INTO TACHE (intitulé, description, dateEcheance, categorie, status, idCreateur, idProjet) VALUES ('Tache 4', 'Description de la tache 1', SYSDATE + 7, 'Categorie1', 0, 1, 3);
INSERT INTO TACHE (intitulé, description, dateEcheance, categorie, status, idCreateur, idProjet) VALUES ('Tache 5', 'Description de la tache 1', SYSDATE + 365, 'Categorie1', 0, 1, 2);


-- Remplissage de la table TACHETODO
INSERT INTO TACHETODO (idTache, priorite) VALUES (1, 7);
INSERT INTO TACHETODO (idTache, priorite) VALUES (2, 9);
INSERT INTO TACHETODO (idTache, priorite) VALUES (3, 2);
INSERT INTO TACHETODO (idTache, priorite) VALUES (4, 3);

-- Remplissage de la table TACHEPERIODIQUE
INSERT INTO TACHEPERIODIQUE (idTache, dateDebut, dateFin, periodicite) VALUES (5, TO_DATE('01-JAN-2023', 'DD-MON-YYYY'), TO_DATE('01-JAN-2024', 'DD-MON-YYYY'), 7);

-- Remplissage de la table TACHEUTILISATEUR
INSERT INTO TACHEUTILISATEUR (idTache, idUtilisateur) VALUES (1, 1);
INSERT INTO TACHEUTILISATEUR (idTache, idUtilisateur) VALUES (2, 4);
INSERT INTO TACHEUTILISATEUR (idTache, idUtilisateur) VALUES (5, 5);

--Exemple de creation de liste tache
--Pour un projet de nom "Projet Omega"
CREATE VIEW ListTacheP AS 
SELECT p.idProjet, p.nomProjet, t.idTache, t.intitulé, t.description, t.dateEcheance,t.lienExterne, t.categorie, t.status, p.idCreateur
FROM PROJET p
JOIN TACHE t ON p.idProjet = t.idProjet
WHERE p.nomProjet='Projet Omega'
ORDER BY t.dateEcheance;

