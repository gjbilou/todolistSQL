

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


