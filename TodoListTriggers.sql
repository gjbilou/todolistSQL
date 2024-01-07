CREATE OR REPLACE TRIGGER updateScoreArchive
AFTER INSERT ON TACHEFINI
FOR EACH ROW
DECLARE
	scoreChange NUMBER;
	userHasProgrammeScore NUMBER;
	cursor c1 is
		SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache;

BEGIN
	IF :NEW.status = 0 THEN
		FOR userRecord IN c1 LOOP
			SELECT COUNT(*) INTO userHasProgrammeScore FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;

			IF userHasProgrammeScore > 0 THEN
				SELECT scoreToSub INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
			ELSE
				scoreChange := 5;
			END IF;

			-- Mettre à jour le score
			UPDATE SCORE SET score = score - scoreChange WHERE idUtilisateur = userRecord.idUtilisateur;
		END LOOP;
	END IF;
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER updateScoreCompletion
AFTER UPDATE OF status ON TACHENCOURS
FOR EACH ROW
WHEN (NEW.status = 1)
DECLARE
	scoreChange NUMBER;
	userHasProgrammeScore NUMBER;
	cursor c1 is
		SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache;
BEGIN
	UPDATE TACHENCOURS SET dateAccomplissement = SYSDATE WHERE idTache = :NEW.idTache;

	FOR userRecord IN c1 LOOP
		SELECT COUNT(*) INTO userHasProgrammeScore FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;

		IF userHasProgrammeScore > 0 THEN
			SELECT scoreToAdd INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
		ELSE
			scoreChange := 5;
		END IF;

		UPDATE SCORE SET score = score + scoreChange WHERE idUtilisateur = userRecord.idUtilisateur;
	END LOOP;
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER initUser
FOR INSERT ON utilisateur
COMPOUND TRIGGER

	BEFORE EACH ROW IS
	BEGIN
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
		INSERT INTO SCORE (idUtilisateur, score, niveau)
		VALUES (:NEW.idUtilisateur, 0, 1);
	END AFTER EACH ROW;

END makeLogin;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER prodPeriodicite
AFTER INSERT ON PERIODICITE
FOR EACH ROW
DECLARE
	nextDate_v DATE;
BEGIN
	nextDate_v := :NEW.dateDebut + :NEW.periode;

	WHILE nextDate_v <= :NEW.dateFin LOOP
		INSERT INTO TACHENCOURS (intitule, dateEcheance, lienExterne, categorie, status, idCreateur, idListe)
		SELECT intitule, nextDate_v, lienExterne, categorie, status, idCreateur, idListe
		FROM TACHENCOURS
		WHERE idTache = :NEW.idTache;

		nextDate_v := nextDate_v + :NEW.periode;
	END LOOP;
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER updateLevel
AFTER UPDATE OF score ON SCORE
FOR EACH ROW
DECLARE
	nextLevel NUMBER;
BEGIN
	nextLevel := 100 * POWER(2, :NEW.niveau - 1);

	IF :NEW.score >= nextLevelThreshold THEN
		UPDATE SCORE SET niveau = niveau + 1 WHERE idUtilisateur = :NEW.idUtilisateur;
	END IF;
END;
/
