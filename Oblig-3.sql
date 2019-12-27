-- OPPGAVE 1 --
SELECT filmcharacter , COUNT(filmcharacter)
  FROM filmcharacter
  GROUP BY filmcharacter
  HAVING COUNT(*) > 2000
  ORDER BY COUNT(*) DESC;
 
 -- OPPGAVE 2 --
 
 -- 2a--
SELECT  f.title , f.prodyear
FROM film f 
 INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
 INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director' ;

-- 2b--
SELECT  f.title , f.prodyear
FROM film f NATURAL JOIN filmparticipation fp NATURAL JOIN person p  
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director' ;

--2c--
SELECT  f.title , f.prodyear
FROM film f , filmparticipation fp , person p  
WHERE p.personid = fp.personid 
AND fp.filmid = f.filmid
AND p.firstname = 'Stanley' 
AND p.lastname = 'Kubrick' 
AND fp.parttype = 'director';


-- OPPGAVE 3 --
SELECT  p.personid , P.firstname || ' ' || P.lastname AS fullname,f.title ,  fchar.filmcharacter, fco.country
FROM  filmparticipation fp 
  INNER JOIN person p ON (p.personid = fp.personid)
  INNER JOIN filmcharacter fchar ON (fp.partid = fchar.partid)
  INNER JOIN filmcountry fco ON (fp.filmid = fco.filmid)
  INNER JOIN film f ON (fp.filmid = f.filmid)
WHERE p.firstname = 'Ingrid' AND fchar.filmcharacter = 'Ingrid';

-- OPPGAVE 4 --
SELECT f.filmid , f.title , COUNT(fg.genre) as genre
FROM film f LEFT JOIN filmgenre fg ON (f.filmid = fg.filmid )
WHERE title LIKE '%Antoine %'
GROUP BY f.filmid , f.title; 

-- OPPGAVE 5 --
SELECT f.title, fp.parttype , COUNT(fp.parttype) AS antalldeltakere
FROM filmparticipation fp
NATURAL JOIN film f 
NATURAL JOIN filmitem fi
WHERE f.title LIKE '%Lord of the Rings%' AND fi.filmtype LIKE 'C'
GROUP BY (f.title , fp.parttype);

--OPPGAVE 6 --
SELECT f.title, f.prodyear
FROM film f 
WHERE prodyear = (
  SELECT MIN(prodyear)
  FROM film
);

--OPPGAVE 7 --
SELECT f.title, f.prodyear
FROM film f, filmgenre fg1, filmgenre fg2
WHERE f.filmid = fg1.filmid AND fg1.filmid = fg2.filmid 
AND fg1.genre = 'Film-Noir' AND fg2.genre = 'Comedy';

--OPPGAVE 8 -- 
SELECT f.title, f.prodyear
FROM film f 
WHERE prodyear = (
  SELECT MIN(prodyear)
  FROM film
)

UNION ALL 

SELECT f.title, f.prodyear
FROM film f, filmgenre fg1, filmgenre fg2
WHERE f.filmid = fg1.filmid AND fg1.filmid = fg2.filmid 
AND fg1.genre = 'Film-Noir' AND fg2.genre = 'Comedy';

--OPPGAVE 9 --
SELECT  f.title , f.prodyear
FROM film f 
 INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
 INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director' 

INTERSECT 

SELECT  f.title , f.prodyear
FROM film f 
 INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
 INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'cast' ;

-- OPPGAVE 10 --
SELECT s.maintitle , fr.votes
FROM filmrating fr 
  INNER JOIN series s ON (fr.filmid = s.seriesid)
WHERE fr.votes > 1000 AND fr.rank = (
  SELECT MAX(fr.rank)
  FROM filmrating fr WHERE fr.votes > 1000)
GROUP BY (s.maintitle,fr.votes);

-- OPPGAVE 11 --
SELECT DISTINCT fc.country , COUNT(*)
FROM filmcountry fc
GROUP BY fc.country
HAVING COUNT(*) -1;

-- OPPGAVE 12 --
WITH uniqueRoles AS(
SELECT * 
FROM (
  SELECT filmcharacter, COUNT(*)
  FROM filmcharacter
  GROUP BY filmcharacter
  HAVING COUNT(*) = 1
) AS uchar , filmcharacter AS fchar
WHERE uchar.filmcharacter = fchar.filmcharacter
)
SELECT firstname ||''|| lastname AS name, COUNT(*) AS numOfUniqueRoles
FROM person 
NATURAL JOIN filmparticipation
NATURAL JOIN uniqueRoles
GROUP BY name
HAVING COUNT(*) > 199
ORDER BY numOfUniqueRoles;

--OPPGAVE 13 --
SELECT (firstname ||' '|| lastname) as name
FROM film
NATURAL JOIN filmrating
NATURAL JOIN filmparticipation
NATURAL JOIN person
WHERE parttype LIKE 'director' AND votes > 60000
GROUP BY name

EXCEPT

SELECT (firstname || ' ' || lastname) as name
FROM film
NATURAL JOIN filmparticipation
NATURAL JOIN person
NATURAL JOIN filmrating 
WHERE parttype LIKE 'director' AND votes > 60000 AND rank < 8
GROUP BY name;
