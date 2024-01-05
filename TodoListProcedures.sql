
set serveroutput on;

--version basique de la premiere fonction
create or replace procedure nbPoints 
is

-- we need a cursor to loop through the select of programs and tasks
	cursor c1 is
		-- i need to select all users with a custom program
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
		-- we need to check if the task was finished on time or not on time (we won't check unterminated tasks : before the deadline)
		if c1_rec.dateEcheance > SYSDATE and c1_rec.status = 1 
		then 
			-- if the task was finished on time, we need to add the points to the totalPositif
			totalPositif := totalPositif + c1_rec.scoreToAdd;

		elsif c1_rec.dateEcheance < SYSDATE and c1_rec.status = 1 
		then 
			-- if the task was finished, but we checked it late, then we need to add the points to the totalPositif
			totalPositif := totalPositif + c1_rec.scoreToAdd;

		elsif c1_rec.dateEcheance < SYSDATE and c1_rec.status = 0
		then 
			-- if the task was not finished on time, we need to add the points to the totalNegatif
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



-- i need a procedure that will verify each week if the tasks are done or not (and if they are done, move them to taskfinished and add score to user)
create or replace procedure archiveTasks
is
	pragma autonomous_transaction;
	cursor c1 is
		select * 
		from tachesencours
		where dateEcheance < SYSDATE 
		or status = 1;
begin
	-- i would like to loop through the cursor and move the tasks to taskfinished 
	for c1_rec in c1 loop
		-- i need to check if the task is done or not
		-- if the task is done, i need to move it to taskfinished
		insert into tachefini values (c1_rec.idTache, c1_rec.intitule, c1_rec.dateEcheance, c1_rec.lienExterne, c1_rec.categorie, c1_rec.status, c1_rec.idCreateur, c1_rec.idListe);

		-- i need to delete the task from tachesencours
		delete from tachesencours
		where idTache = c1_rec.idTache;
	end loop;

-- i just need to check the score (when will it be updated ?)
	commit;
end archiveTasks;

-- i need to automate this procedure to run every week
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
