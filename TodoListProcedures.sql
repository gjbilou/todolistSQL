
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
