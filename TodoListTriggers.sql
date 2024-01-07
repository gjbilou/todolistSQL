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
	cursor c1 is
		SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache;
BEGIN
	-- Pour chaque utilisateur associé à la tâche
	FOR userRecord IN c1 LOOP
	-- Récupérer le score à ajouter
		SELECT scoreToAdd INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
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
