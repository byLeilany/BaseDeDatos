-- 2.3) a)
/*
SELECT DISTINCT al.AlbumId, t.TrackId, COUNT(pt.PlaylistId)
	from Album al
    Inner Join Track t ON t.AlbumId = al.AlbumId
    Inner join PlaylistTrack pt on pt.TrackId = t.TrackId
    GROUP by al.AlbumId, t.TrackId
    HAVING COUNT(pt.PlaylistId) = (SELECT COUNT(p.PlaylistId) from Playlist p)
*/

-- b)
/*
SELECT kdos.ArtistId, kdos.Name
FROM (SELECT k.ArtistId, k.Name, COUNT(*) as 'songsEnPlaylist' 
      FROM (SELECT a.ArtistId, a.Name, pt.PlaylistId 
            FROM Album al
            INNER JOIN Artist a ON al.ArtistId = a.ArtistId
            Inner Join Track t ON t.AlbumId = al.AlbumId
            Inner join PlaylistTrack pt on pt.TrackId = t.TrackId) k
       GROUP by k.ArtistId, k.Name) kdos
 WHERE kdos.songsEnPlaylist = ( SELECT MIN(songsEnPlaylist) FROM (SELECT k.ArtistId, k.Name, COUNT(*) as 'songsEnPlaylist' 
                                                                  FROM (SELECT a.ArtistId, a.Name, pt.PlaylistId 
                                                                        FROM Album al
                                                                        INNER JOIN Artist a ON al.ArtistId = a.ArtistId
                                                                        Inner Join Track t ON t.AlbumId = al.AlbumId
                                                                        Inner join PlaylistTrack pt on pt.TrackId = t.TrackId) k
                                                                   GROUP by k.ArtistId, k.Name)
 )
 */
 
 --2.4) a) quiero playlist que NO tengan NIGNUN track de los artistas X e Y.
 -- no lo hice en AR ni en CRT

/*
SELECT * FROM Playlist p
EXCEPT
SELECT DISTINCT pt.PlaylistId, p.Name
	from Album al
    Inner Join Track t ON t.AlbumId = al.AlbumId
    Inner join PlaylistTrack pt on pt.TrackId = t.TrackId
 	INNER JOIN Playlist p ON p.PlaylistId  = pt.PlaylistId
    INNER JOIN Artist a ON a.ArtistId = al.ArtistId
    WHERE a.Name IN ('Black Sabbath','Chico Buarque')
*/

-- b) quiero ctes que compraron tracks de 1 UNICO genero
/*

INSERT INTO [Customer] ([CustomerId], [FirstName], [LastName], [Address], [City], [Country], [PostalCode], [Phone], [Email], [SupportRepId]) VALUES (6969, 'ho', 'La', '3,Raj Bhavan Road', 'Bangalore', 'India', '560001', '+91 080 22289999', 'puja_srivastava@yahoo.in', 3);

INSERT INTO [Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingCountry], [BillingPostalCode], [Total]) VALUES (1000, 6969, '2013-12-22 00:00:00', '12,Community Centre', 'Delhi', 'India', '110017', 1.99);
INSERT INTO [Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingCountry], [BillingPostalCode], [Total]) VALUES (1001, 6969, '2013-12-22 00:00:00', '12,Community Centre', 'Delhi', 'India', '110017', 1.99);

INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3000, 1000, 2, 1.99, 1);
INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3001, 1000, 4, 1.99, 1);

INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3002, 1001, 6, 1.99, 1);

SELECT k.CustomerId, k.FirstName, k.LastName, COUNT(*) as "GenreDistintos"
FROM (SELECT DISTINCT cteLinea.CustomerId, cteLinea.FirstName, cteLinea.LastName, g.GenreId
                FROM (SELECT c.CustomerId, c.FirstName, c.LastName, il.TrackId, i.InvoiceId, il.InvoiceLineId
                      FROM Customer c
                      INNER JOIN Invoice i ON i.CustomerId = c.CustomerId
                      INNER JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId) cteLinea
                INNER join Track t ON t.TrackId = cteLinea.TrackId
                INNER join Genre g ON t.GenreId = g.GenreId
    	ORDER BY cteLinea.CustomerId) k
GROUP BY k.CustomerId, k.FirstName, k.LastName
HAVING COUNT(*) = 1
ORDER BY COUNT(*) 
*/

-- 2.5)
CREATE TABLE [Actor]
(
    [idActor] INTEGER  NOT NULL,
    [nombreActor] NVARCHAR(160)  NOT NULL,
    [edad] INTEGER  NOT NULL,
    CONSTRAINT [PK_Actor] PRIMARY KEY  ([idActor]),
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Genero]
(
    [idGenero] INTEGER  NOT NULL,
    [nombreGenero] NVARCHAR(160)  NOT NULL,
    CONSTRAINT [PK_Genero] PRIMARY KEY  ([idGenero]),
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Serie]
(
    [idSerie] INTEGER  NOT NULL,
    [nombreSerie] NVARCHAR(160)  NOT NULL,
    [idGenero] INTEGER  NOT NULL,
  	[aInicio] DATE  NOT NULL,
  	[aFin] DATE  NOT NULL,
    CONSTRAINT [PK_Serie] PRIMARY KEY  ([idSerie]),
  			   [aInicio] < [aFin],
    FOREIGN KEY ([idGenero]) REFERENCES [Genero] ([idGenero]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Canal]
(
    [idCanal] INTEGER  NOT NULL,
    [nombreCanal] NVARCHAR(160)  NOT NULL,
    CONSTRAINT [PK_Canal] PRIMARY KEY  ([idCanal]),
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [ParticipaEn]
(
    [idActor] INTEGER  NOT NULL,
    [idSerie] INTEGER  NOT NULL,
    CONSTRAINT [PK_PlaylistTrack] PRIMARY KEY  ([idActor], [idSerie]),
    FOREIGN KEY ([idActor]) REFERENCES [Actor] ([idActor]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([idSerie]) REFERENCES [Serie] ([idSerie]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);


 CREATE TABLE [Transmite]
(
    [idCanal] INTEGER  NOT NULL,
    [idSerie] INTEGER  NOT NULL,
    CONSTRAINT [PK_Transmite] PRIMARY KEY  ([idCanal], [idSerie]),
    FOREIGN KEY ([idCanal]) REFERENCES [Canal] ([idCanal]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([idSerie]) REFERENCES [Serie] ([idSerie]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);
 
 

    
    
