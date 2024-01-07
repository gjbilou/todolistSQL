--verifie le trigger updatescoreCompletion : voir tableau de score (dateAccomplissment aussi)
update tachencours 
set status=1
where idTache>5 and idTache<20;