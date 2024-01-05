create table UTILISATEUR(
idUtilisateur number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
nom varchar2(20) not null,
prenom varchar2(20) not null,
adresse varchar2(30) not null,
login varchar2(10) invisible unique, -- login serait créé automatiquement et remis à l'utilisateur pour assurer l'unicité
motDePasse varchar2(10) CONSTRAINT checkMDP CHECK(REGEXP_LIKE(motDePasse,'^[A-Za-z0-9_]+$')) not null,
dateNaissance date not null,
dateInscription date invisible default SYSDATE
);


create table SCORE(
idUtilisateur number(6) PRIMARY KEY,
score number(20) DEFAULT 0,
niveau NUMBER(10) DEFAULT 1,
FOREIGN KEY(idUtilisateur) REFERENCES UTILISATEUR ,
constraint posValues CHECK (SCORE>=0 AND NIVEAU>0)
);

create table PROJET(
idProjet number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
nomProjet varchar2(20) not null,
DescriptionProjet CLOB
);

create table LISTE(
idListe number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
idCreateur number(6),
idProjet number(6),
FOREIGN KEY (idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL,
FOREIGN KEY (idProjet) REFERENCES PROJET ON DELETE CASCADE
);

create table TACHENCOURS(
idTache number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
intitule varchar2(2048) not null,
dateEcheance date, -- IF NULL => PERIODIQUE .ECHEANCE IN TABLE PERIODICITE
lienExterne varchar2(2048),
categorie varchar2(256), 
status number(2) DEFAULT 0 CHECK(STATUS IN (0,1)), --1 if done -- 0 if not
idCreateur number(6),
idListe number(6),
FOREIGN KEY(idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL,
FOREIGN KEY(idListe) REFERENCES LISTE ON DELETE SET NULL
);
create index categorieTache on TACHENCOURS (categorie);

create table TACHEFINI(
idTache number(6) PRIMARY KEY,
intitule varchar2(2048) not null,
dateEcheance date,
lienExterne varchar2(2048),
categorie varchar2(256), 
status number(2) DEFAULT 0 CHECK(STATUS IN (0,1)), --1 if done -- 0 if not
idCreateur number(6),
idListe number(6),
FOREIGN KEY(idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL,
FOREIGN KEY(idListe) REFERENCES LISTE ON delete set NULL
);


create view TACHES AS 
SELECT * FROM TACHENCOURS   
UNION
SELECT * FROM TACHEFINI;


create table PERIODICITE(
idTache number(6) PRIMARY KEY,
dateDebut date,
dateFin date,
periode interval day to second,
FOREIGN KEY(idTache) REFERENCES TACHENCOURS
);



create table PROGRAMMESCORE(
idProgramme number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
idCreateur number(6) UNIQUE, -- UNIQUE POUR EVITER LES DOUBLONS PARCE QU'ON VA PAS POUVOIR IDENTIFIER QUELLE PROGRAMME EST CE QUE L'UTILISATEUR EN QUESTION EST EN TRAIN D'UTILISER AU MOMENT T.
scoreToAdd number(6),
scoreToSub number(6),
FOREIGN KEY (idCreateur) REFERENCES UTILISATEUR ON DELETE CASCADE, 
CONSTRAINT diffScore CHECK (ABS(scoreToAdd-scoreToSub) <= 5)
);

create table DEPENDANCETACHE(
idTache number(6),
idTacheDependante number(6) ,
PRIMARY KEY(idTache,idTacheDependante),
FOREIGN KEY(idTache) REFERENCES TACHENCOURS,
FOREIGN KEY(idTacheDependante) REFERENCES TACHENCOURS,
CONSTRAINT dependanceCyclique1 CHECK (idTache !=idTacheDependante)
);

create table TACHEUTILISATEUR(
idTache number(6),
idUtilisateur number(6),
PRIMARY KEY(idTache,idUtilisateur),
FOREIGN KEY(idTache) REFERENCES TACHENCOURS,
FOREIGN KEY(idUtilisateur) REFERENCES UTILISATEUR
);
