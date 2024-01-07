
set serveroutput on;

create or replace procedure nbPoints 
is

	cursor c1 is
		select * 
		from programmescore 
		join taches 
		on taches.idCreateur = programmescore.idCreateur
		where programmescore.idCreateur != 1 
		and taches.idCreateur != 1 
		and (TO_CHAR(taches.dateEcheance, 'IW') = TO_CHAR(SYSDATE, 'IW'));

	totalPositif number(10) := 0;
	totalNegatif number(10) := 0;


begin
	for c1_rec in c1 loop
		if c1_rec.status = 1 
		then 
			totalPositif := totalPositif + c1_rec.scoreToAdd;

		elsif c1_rec.dateEcheance < SYSDATE and c1_rec.status = 0
		then 
			totalNegatif := totalNegatif - c1_rec.scoreToSub;

		end if;
	end loop;
	dbms_output.put_line('Total Positif : ' || totalPositif);
	dbms_output.put_line('Total Negatif : ' || totalNegatif);


end nbPoints;

begin 
	nbPoints;
end;
/



create or replace procedure archiveTasks
is
	pragma autonomous_transaction;
	cursor c1 is
		select * 
		from tachesencours
		where dateEcheance < SYSDATE 
		or status = 1;
begin
	for c1_rec in c1 loop
		insert into tachefini values (c1_rec.idTache, c1_rec.intitule, c1_rec.dateEcheance, c1_rec.lienExterne, c1_rec.categorie, c1_rec.status, c1_rec.idCreateur, c1_rec.idListe);

		delete from tachesencours
		where idTache = c1_rec.idTache;
	end loop;

	commit;
end archiveTasks;

declare
	processId number;
	
begin
	dbms_job.submit(
		JOB => processId,
		WHAT => 'archiveTasks;',
		NEXT_DATE => SYSDATE,
		INTERVAL => NEXT_DAY(TRUNC(SYSDATE), 'MONDAY') + (8/24)
	);
	commit;
	DBMS_OUTPUT.PUT_LINE('Le numéro du travail '||processId);
end;
