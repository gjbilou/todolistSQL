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
FOREIGN KEY(idUtilisateur) REFERENCES UTILISATEUR ON DELETE CASCADE,
constraint posValues CHECK (SCORE>=0 AND NIVEAU>0)
);

create table PROJET(
idProjet number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
nomProjet varchar2(20) not null,
DescriptionProjet CLOB,
idCreateur number(6),
FOREIGN KEY(idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL
);

create table TACHENCOURS(
idTache number(6) GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
intitule varchar2(256) not null,
dateEcheance date,
lienExterne varchar2(2048),
categorie varchar2(256), 
status number(2) DEFAULT 0 CHECK(STATUS IN (0,1)), --1 if done -- 0 if not
idCreateur number(6),
idProjet number(6),
FOREIGN KEY(idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL,
FOREIGN KEY(idProjet) REFERENCES PROJET ON DELETE CASCADE
);
create index categorieTache on TACHENCOURS (categorie);

create table TACHEFINI(
idTache number(6) PRIMARY KEY,
intitule varchar2(20) not null,
dateEcheance date,
lienExterne varchar2(20),
categorie varchar2(10), 
status number(2) DEFAULT 0 CHECK(STATUS IN (0,1)), --1 if done -- 0 if not
idCreateur number(6),
idProjet number(6),
FOREIGN KEY(idCreateur) REFERENCES UTILISATEUR ON DELETE SET NULL,
FOREIGN KEY(idProjet) REFERENCES PROJET ON DELETE CASCADE
);

create view TACHES AS 
SELECT * FROM TACHENCOURS   
UNION
SELECT * FROM TACHEFINI;

create table TACHEPERIODIQUE(
idTache number(6) PRIMARY KEY,
dateDebut date,
dateFin date,
periodicite interval day to second,
FOREIGN KEY(idTache) REFERENCES TACHENCOURS ON DELETE CASCADE
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



