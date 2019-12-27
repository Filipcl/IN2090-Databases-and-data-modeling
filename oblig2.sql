-- Obligatorisk Oppgave 2 
-- Filipcl

-- Oppgave 2: 

-- 2A --
select *  from timelistelinje where timelistenr = 3;

-- 2B --

select COUNT(*) AS  antallTimelister  from timeliste;

-- 2C --

select *  from timeliste where status != 'utbetalt';

-- 2D --

select COUNT(*) AS antall , COUNT(pause) AS antallmedpause from timelistelinje;

-- 2E --

select * from timelistelinje where pause IS NULL;

-- Oppgave 3: 
 
-- 3A --
select sum(varighet)/60 as ikkeUtbetalt
from timeliste as t 
inner join Varighet 
on t.timelistenr = Varighet.timelistenr 
where t.status != 'utbetalt';

-- 3B --
select distinct t.timelistenr, t.beskrivelse 
from timeliste as t 
inner join timelistelinje as tl 
using (timelistenr) 
where tl.beskrivelse like '%test%' or tl.beskrivelse like '%Test%';

-- 3C --
select sum(varighet)/60*200 as betalteTimer 
from timeliste as t 
inner join Varighet 
on t.timelistenr = Varighet.timelistenr 
where t.status = 'utbetalt';

/*
-- Oppgave 4: 

-- Grunnen til at spørringene er forskjellige er fordi Inner join spørringen slår sammen de to tabellene hvor timelistenr er ekvivalente, 
og natural joinen slår sammen der kolonnene med identiske navn har identisk innhold. 
I dette tilfellet er det kun et tilfelle hvor timelisetnr og beskrivelse har identisk innhold i begge tabellene. 

-- Spørringene er ekvivalente fordi, spørringen joiner tabellen timeliste og viewet Varighet på timelistenr. 
Natural join legger sammen kolonner med samme navn og gir derfor likt svar.
