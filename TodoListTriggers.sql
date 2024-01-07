CREATE OR REPLACE TRIGGER UpdateUserScore
AFTER INSERT ON TACHEFINI
FOR EACH ROW
DECLARE
    scoreChange NUMBER;
    userHasProgrammeScore NUMBER;
BEGIN
    IF :NEW.status = 0 THEN
        -- Pour chaque utilisateur associé à la tâche
        FOR userRecord IN (SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache) LOOP
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
BEGIN
    -- Pour chaque utilisateur associé à la tâche
    FOR userRecord IN (SELECT idUtilisateur FROM TACHEUTILISATEUR WHERE idTache = :NEW.idTache) LOOP
        -- Récupérer le score à ajouter
        DECLARE
            scoreChange NUMBER;
        BEGIN
            SELECT scoreToAdd INTO scoreChange FROM PROGRAMMESCORE WHERE idCreateur = userRecord.idUtilisateur;
            -- Mettre à jour le score de l'utilisateur
            UPDATE SCORE SET score = score + scoreChange WHERE idUtilisateur = userRecord.idUtilisateur;
        END;
    END LOOP;
END;
/


--------------------------------------------------------------------------------------



-- i need a trigger that will create the login for users from their first name and last name
create or replace trigger makeLogin
before insert on utilisateur
for each row 
declare
	nomToUse varchar2(7);
begin
	if length(:new.nom) > 7
	then
		nomToUse := substr(:new.nom, 1, 7);
	else
		nomToUse := :new.nom;
	end if;
	:new.login := lower(substr(:new.prenom, 1, 1) || nomToUse);
end;


