--  1.
SELECT 
    L.idListe,
    COUNT(TC.idTache) AS NombreDeTaches
FROM 
    LISTE L
JOIN 
    UTILISATEUR U ON L.idCreateur = U.idUtilisateur
JOIN 
    TACHENCOURS TC ON L.idListe = TC.idListe
WHERE 
    U.adresse LIKE '%France%'
GROUP BY 
    L.idListe
HAVING 
    COUNT(TC.idTache) >= 5;
    
--  2.


--  3.
SELECT 
    U.login, 
    U.nom, 
    U.prenom, 
    U.adresse, 
    COUNT(TC.idTache) AS NombreTachesTotal,
    COUNT(P.idTache) AS NombreTachesPeriodiques
FROM 
    UTILISATEUR U
LEFT JOIN 
    TACHENCOURS TC ON U.idUtilisateur = TC.idCreateur
LEFT JOIN 
    PERIODICITE P ON TC.idTache = P.idTache
GROUP BY 
    U.login, U.nom, U.prenom, U.adresse;


--  4.
SELECT 
    T.idTache, 
    T.intitule,
    COUNT(D.idTacheDependante) AS NombreDependances
FROM 
    TACHENCOURS T
LEFT JOIN 
    DEPENDANCETACHE D ON T.idTache = D.idTacheDependante
GROUP BY 
    T.idTache, T.intitule;
    


--  5.
SELECT
    TU.idUtilisateur,
    SUM(CASE 
            WHEN PS.idCreateur IS NULL THEN 5 
            ELSE PS.scoreToAdd 
        END) AS TotalPointsGagnes
FROM
    TACHENCOURS TC
JOIN
    TACHEUTILISATEUR TU ON TC.idTache = TU.idTache
LEFT JOIN
    PROGRAMMESCORE PS ON TU.idUtilisateur = PS.idCreateur
WHERE
    TC.status = 1 AND 
    TC.dateAccomplissement >= TRUNC(SYSDATE, 'IW') AND
    TC.dateAccomplissement < TRUNC(SYSDATE, 'IW') + 7
GROUP BY
    TU.idUtilisateur
ORDER BY
    TotalPointsGagnes DESC
FETCH FIRST 10 ROWS ONLY;
