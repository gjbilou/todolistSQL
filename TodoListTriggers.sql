CREATE OR REPLACE TRIGGER UpdateUserScore
AFTER INSERT ON TACHEFINI
FOR EACH ROW
DECLARE
	scoreChange NUMBER;
	userHasProgrammeScore NUMBER;
	cursor c1 is
		SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache;

BEGIN
	IF :NEW.status = 0 THEN
		-- Pour chaque utilisateur associé à la tâche
		FOR userRecord IN c1 LOOP
			-- Vérifier si l'utilisateur a un programme score
			SELECT COUNT(*) INTO userHasProgrammeScore FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;

			IF userHasProgrammeScore > 0 THEN
				-- Récupérer le score à soustraire
				SELECT scoreToSub INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
			ELSE
				-- Utiliser la valeur par défaut
				scoreChange := 5;
			END IF;

			-- Mettre à jour le score
			UPDATE SCORE SET score = score - scoreChange WHERE idUtilisateur = userRecord.idUtilisateur;
		END LOOP;
	END IF;
END;
/

-------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER UpdateScoreAfterTaskCompletion
AFTER UPDATE OF status ON TACHENCOURS
FOR EACH ROW
WHEN (NEW.status = 1)
DECLARE
    scoreChange NUMBER;
    userHasProgrammeScore NUMBER;
    cursor c1 is
        SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache;
BEGIN
    -- Mise à jour de la date d'accomplissement de la tâche
    UPDATE TACHENCOURS SET dateAccomplissement = SYSDATE WHERE idTache = :NEW.idTache;

    -- Pour chaque utilisateur associé à la tâche
    FOR userRecord IN c1 LOOP
        -- Vérifier si l'utilisateur a un programme score
        SELECT COUNT(*) INTO userHasProgrammeScore FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;

        IF userHasProgrammeScore > 0 THEN
            -- Récupérer le score à ajouter
            SELECT scoreToAdd INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
        ELSE
            -- Utiliser la valeur par défaut
            scoreChange := 5;
        END IF;

        -- Mettre à jour le score de l'utilisateur
        UPDATE SCORE SET score = score + scoreChange WHERE idUtilisateur = userRecord.idUtilisateur;
    END LOOP;
END;
/


--------------------------------------------------------------------------------------

-- i need a trigger that will create the login for users from their first name and last name and add record in score table
CREATE OR REPLACE TRIGGER makeLogin
FOR INSERT ON utilisateur
COMPOUND TRIGGER

    BEFORE EACH ROW IS
    BEGIN
        -- Génération du login pour chaque nouvel utilisateur
        DECLARE
            nomToUse VARCHAR2(7);
        BEGIN
            IF LENGTH(:NEW.nom) > 7 THEN
                nomToUse := SUBSTR(:NEW.nom, 1, 7);
            ELSE
                nomToUse := :NEW.nom;
            END IF;
            :NEW.login := LOWER(SUBSTR(:NEW.prenom, 1, 1) || nomToUse);
        END;
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        -- Insertion dans la table SCORE après chaque insertion dans UTILISATEUR
        INSERT INTO SCORE (idUtilisateur, score, niveau)
        VALUES (:NEW.idUtilisateur, 0, 1);
    END AFTER EACH ROW;

END makeLogin;
/

-------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER ClonePeriodicTasks
AFTER INSERT ON PERIODICITE
FOR EACH ROW
DECLARE
    nextDate_v DATE;
BEGIN
    -- Initialiser la prochaine date de la tâche périodique
    nextDate_v := :NEW.dateDebut + :NEW.periode;

    -- Continuer à cloner la tâche jusqu'à la date de fin
    WHILE nextDate_v <= :NEW.dateFin LOOP
        -- Insertion d'une nouvelle tâche dans TACHENCOURS basée sur la tâche référencée
        INSERT INTO TACHENCOURS (intitule, dateEcheance, lienExterne, categorie, status, idCreateur, idListe)
        SELECT intitule, nextDate_v, lienExterne, categorie, status, idCreateur, idListe
        FROM TACHENCOURS
        WHERE idTache = :NEW.idTache;

        -- Calculer la prochaine date en fonction de la périodicité
        nextDate_v := nextDate_v + :NEW.periode;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER UpdateLevel
AFTER UPDATE OF score ON SCORE
FOR EACH ROW
DECLARE
    nextLevel NUMBER;
BEGIN
    -- Calculer le seuil pour le niveau suivant
    nextLevel := 100 * POWER(2, :NEW.niveau - 1);

    -- Vérifier si le score mis à jour atteint ou dépasse le seuil
    IF :NEW.score >= nextLevelThreshold THEN
        -- Mettre à jour le niveau
        UPDATE SCORE SET niveau = niveau + 1 WHERE idUtilisateur = :NEW.idUtilisateur;
    END IF;
END;
/

