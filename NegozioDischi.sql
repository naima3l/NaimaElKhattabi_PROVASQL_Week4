--PARTE TEORICA--
---1. B
---2. L’associazione “molti a molti” tra 2 tabelle si traduce con una nuova tabella(entità) che avrà come chiave primaria le chiavi primarie di entrambe le tabelle ed eventuali attributi dati dall'associazione
---3. B
---4. B
---5. Sì

--PARTE PRATICA--
--CREATE DATABASE NegozioDischi
CREATE TABLE Band(
IdBand INT IDENTITY(1,1) NOT NULL,
Nome NVARCHAR(20),
NumeroComponenti INT
CONSTRAINT Pk_Band PRIMARY KEY (IdBand)
);

CREATE TABLE Album(
IdAlbum INT IDENTITY(1,1) NOT NULL,
Titolo NVARCHAR(40),
AnnoNascita DATE,
CasaDiscografica NVARCHAR(20),
Genere NVARCHAR(10),
SupportoDistribuzione NVARCHAR(10),
IdBand INT FOREIGN KEY REFERENCES Band(IdBand),
CONSTRAINT Pk_Album PRIMARY KEY (IdAlbum),
CONSTRAINT Ak_Album UNIQUE(Titolo,AnnoNascita,CasaDiscografica,Genere,SupportoDistribuzione), 
CONSTRAINT CheckGenere CHECK (Genere = 'Classico' OR Genere = 'Jazz' OR Genere = 'Pop' OR Genere = 'Rock' OR Genere = 'Metal'),
CONSTRAINT CheckSupporto CHECK (SupportoDistribuzione = 'CD' OR SupportoDistribuzione = 'Vinile' OR SupportoDistribuzione = 'Streaming')
);

CREATE TABLE Brano(
IdBrano INT IDENTITY(1,1) NOT NULL,
Titolo NVARCHAR(30),
Durata TIME
CONSTRAINT Pk_Brano PRIMARY KEY (IdBrano)
);

CREATE TABLE AlbumBrano(
IdAlbum INT FOREIGN KEY REFERENCES Album(IdAlbum),
IdBrano INT FOREIGN KEY REFERENCES Brano(IdBrano)
CONSTRAINT Pk_AlbumBrano PRIMARY KEY (IdAlbum,IdBrano)
);

INSERT INTO Band VALUES ('883',2);
INSERT INTO Band VALUES ('Maneskin',4);
INSERT INTO Band VALUES ('The Giornalisti',3);
INSERT INTO Band VALUES ('One Direction',5);
INSERT INTO Band VALUES ('Backstreet Boys',6);

INSERT INTO Album VALUES ('Home','2018','Sony Music','Pop','CD',4);
INSERT INTO Album VALUES ('Teatro dira','2021','Sony Music','Rock','Vinile',2);
INSERT INTO Album VALUES ('Teatro dira','2021','Sony Music','Rock','CD',2);
INSERT INTO Album VALUES ('Hanno ucciso l’Uomo','1992','Fri Records','Pop','CD',1);
INSERT INTO Album VALUES ('Nord sud ovest est','1993','Fri Records','Pop','CD',1);
INSERT INTO Album VALUES ('La donna il sogno','1995','Fri Records','Pop','CD',1);
INSERT INTO Album VALUES ('La legge del gol!','1997','Fri Records','Pop','CD',1);
INSERT INTO Album VALUES ('Grazie mille','1999','S4','Pop','CD',1);
INSERT INTO Album VALUES ('Uno in più','2001','Wea International','Pop','CD',1);
INSERT INTO Album VALUES ('Backstreet Boys','2020','Sony Music','Pop','Streaming',5);
INSERT INTO Album VALUES ('Il ballo della vita','2018','Sony Music','Pop','Streaming',2);
INSERT INTO Album VALUES ('Chosen','2017','Sony Music','Pop','Streaming',2);
INSERT INTO Album VALUES ('Album The Giornalisti','2018','Carosello','Pop','CD',3);

INSERT INTO Brano VALUES ('Imagine','00:03:00');
INSERT INTO Brano VALUES ('Riccione','00:03:20');
INSERT INTO Brano VALUES ('Completamente','00:02:50');
INSERT INTO Brano VALUES ('Questa nostra stupida canzone','00:02:57');
INSERT INTO Brano VALUES ('Little Black Dress','00:02:30');
INSERT INTO Brano VALUES ('Zitti e Buoni','00:02:45');
INSERT INTO Brano VALUES ('Torna a casa','00:02:05');
INSERT INTO Brano VALUES ('Morirò da re','00:03:02');
INSERT INTO Brano VALUES ('Beggin','00:02:45');
INSERT INTO Brano VALUES ('Vengo dalla luna','00:02:58');
INSERT INTO Brano VALUES ('Come mai','00:03:20');
INSERT INTO Brano VALUES ('Sei un mito','00:03:20');
INSERT INTO Brano VALUES ('Tieni il tempo','00:02:20');
INSERT INTO Brano VALUES ('Nessun Rimpianto','00:02:10');
INSERT INTO Brano VALUES ('Mamma mia','00:02:30');
INSERT INTO Brano VALUES ('Stay','00:02:40');

INSERT INTO AlbumBrano VALUES (1,5);
INSERT INTO AlbumBrano VALUES (2,1); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (3,6); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (11,7); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (12,8); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (12,9); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (12,10); --ALBUM MANESKIN
INSERT INTO AlbumBrano VALUES (4,11); --ALBUM 883
INSERT INTO AlbumBrano VALUES (5,12); --ALBUM 883
INSERT INTO AlbumBrano VALUES (6,13); --ALBUM 883
INSERT INTO AlbumBrano VALUES (7,14); --ALBUM 883
INSERT INTO AlbumBrano VALUES (8,1); --ALBUM 883
INSERT INTO AlbumBrano VALUES (9,14); --ALBUM 883
INSERT INTO AlbumBrano VALUES (10,1); --ALBUM bsb
INSERT INTO AlbumBrano VALUES (13,2); --ALBUM The Giornalisti
INSERT INTO AlbumBrano VALUES (13,3); --ALBUM The Giornalisti
INSERT INTO AlbumBrano VALUES (13,4); --ALBUM The Giornalisti

---QUERY---
--1. Scrivere una query che restituisca i titoli degli album degli “883” in ordine alfabetico;
SELECT a.Titolo
FROM Album a JOIN Band b ON b.IdBand = a.IdBand
WHERE b.Nome = '883'
ORDER BY a.Titolo;

--2. Selezionare tutti gli album della casa discografica “Sony Music” relativi all’anno 2020;
SELECT *
FROM Album a
WHERE a.CasaDiscografica = 'Sony Music' AND a.AnnoNascita = '2020';

--3. Scrivere una query che restituisca tutti i titoli delle canzoni dei “Maneskin” appartenenti ad album pubblicati prima del 2019;
SELECT br.Titolo
FROM Brano br JOIN AlbumBrano ab ON ab.IdBrano = br.IdBrano JOIN Album al ON al.IdAlbum = ab.IdAlbum JOIN Band b ON b.IdBand = al.IdBand
WHERE b.Nome = 'Maneskin' AND al.AnnoNascita < '2019';

--4. Individuare tutti gli album in cui è contenuta la canzone “Imagine”;
SELECT al.Titolo
FROM Brano br JOIN AlbumBrano ab ON ab.IdBrano = br.IdBrano JOIN Album al ON al.IdAlbum = ab.IdAlbum
WHERE br.Titolo = 'Imagine';

--5. Restituire il numero totale di canzoni eseguite dalla band “The Giornalisti”;
SELECT b.Nome AS [Nome Band], COUNT(b.Nome) AS [Numero Canzoni]
FROM Brano br JOIN AlbumBrano ab ON ab.IdBrano = br.IdBrano JOIN Album al ON al.IdAlbum = ab.IdAlbum JOIN Band b ON b.IdBand = al.IdBand
WHERE b.Nome = 'The Giornalisti'
GROUP BY b.Nome;

--6. Contare per ogni album, la “durata totale” cioè la somma dei secondi dei suoi brani
SELECT al.Titolo AS [Titolo Album],
sum( DATEPART(SECOND, [Durata]) + 60 * 
              DATEPART(MINUTE, [Durata]) + 3600 * 
              DATEPART(HOUR, [Durata] ) 
            ) as [Durata totale (secondi)] 
FROM Brano br JOIN AlbumBrano ab ON ab.IdBrano = br.IdBrano JOIN Album al ON al.IdAlbum = ab.IdAlbum
GROUP BY al.Titolo;

--7. Mostrare i brani (distinti) degli “883” che durano più di 3 minuti (in alternativa usare i secondi quindi 180 s).
SELECT DISTINCT br.*
FROM Brano br JOIN AlbumBrano ab ON ab.IdBrano = br.IdBrano JOIN Album al ON al.IdAlbum = ab.IdAlbum JOIN Band b ON b.IdBand = al.IdBand
WHERE b.Nome = '883' AND br.Durata > '00:03:00';

--8. Mostrare tutte le Band il cui nome inizia per “M” e finisce per “n”.
SELECT *
FROM Band b
WHERE b.Nome LIKE 'M%n';

--9. Mostrare il titolo dell’Album e di fianco un’etichetta che stabilisce che si tratta di un Album:
	--‘Very Old’ se il suo anno di uscita è precedente al 1980,
	--‘New Entry’ se l’anno di uscita è il 2021,
	--‘Recente’ se il suo anno di uscita è compreso tra il 2010 e 2020,
	--‘Old’ altrimenti.
SELECT al.Titolo,
CASE
	WHEN al.AnnoNascita <'1980' THEN 'Very Old'
	WHEN al.AnnoNascita BETWEEN '2010' AND '2020' THEN 'Recente'
	ELSE 'Old'
END AS [Classifica Tipo Album]
FROM Album al;

--10. Mostrare i brani non contenuti in nessun album.
SELECT br.*
FROM Brano br
WHERE br.IdBrano NOT IN (SELECT ab.IdBrano FROM AlbumBrano ab);

--11. Motrare il Nome delle band che sono un duo
SELECT b.Nome
FROM Band b
WHERE b.NumeroComponenti = 2;

--12. Mostrare il titolo di un album che contiene più brani
SELECT al.Titolo
FROM Album al
WHERE (
		(SELECT MAX(NumBrani) AS MaxNumBrani
		FROM (SELECT ab.IdAlbum, COUNT(ab.IdBrano) AS NumBrani
				FROM AlbumBrano ab
				GROUP BY ab.IdAlbum) AS ContaBrani)
		=
		(SELECT COUNT(Ab.IdBrano) AS NumBrani
		FROM AlbumBrano ab
		WHERE al.IdAlbum = ab.IdAlbum)
	);
--13. Mostrare tutte le band che hanno scritto 2 o più brani dopo il 2010
SELECT b.Nome
FROM Band b JOIN Album al ON al.IdBand = b.IdBand JOIN AlbumBrano ab ON ab.IdAlbum = al.IdAlbum JOIN Brano br ON br.IdBrano = ab.IdBrano
WHERE al.AnnoNascita > '2010' 
GROUP BY b.Nome
HAVING COUNT(br.IdBrano) > 2;


--14. Mostrare le band che hanno pubblicato brani di genere POP prima del 2000
SELECT DISTINCT b.* --ho messo distinct perchè se no avevo 5 colonne di 883--
FROM Band b JOIN Album al ON al.IdBand = b.IdBand JOIN AlbumBrano ab ON ab.IdAlbum = al.IdAlbum JOIN Brano br ON br.IdBrano = ab.IdBrano
WHERE al.Genere = 'POP' AND al.AnnoNascita < '2000';