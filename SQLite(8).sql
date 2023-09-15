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
SELECT k.CustomerId, k.FirstName, k.LastName, COUNT(*)
    FROM (SELECT DISTINCT cteLinea.CustomerId, cteLinea.FirstName, cteLinea.LastName, g.GenreId
            FROM (SELECT c.CustomerId, c.FirstName, c.LastName, il.TrackId
                  FROM Customer c
                  INNER JOIN Invoice i ON i.CustomerId = c.CustomerId
                  INNER JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId) cteLinea
            INNER join Track t ON t.TrackId = cteLinea.TrackId
            INNER join Genre g ON t.GenreId = g.GenreId) k
	GROUP BY k.CustomerId, k.FirstName, k.LastName
    HAVING COUNT(*) <5
*/

--INSERT INTO [Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingCountry], [BillingPostalCode], [Total]) VALUES (412, 58, '2013-12-22 00:00:00', '12,Community Centre', 'Delhi', 'India', '110017', 1.99);



    (SELECT DISTINCT cteLinea.CustomerId, cteLinea.FirstName, cteLinea.LastName, t.Name, cteLinea.InvoiceId, cteLinea.InvoiceLineId, g.GenreId
                FROM (SELECT c.CustomerId, c.FirstName, c.LastName, il.TrackId, i.InvoiceId, il.InvoiceLineId
                      FROM Customer c
                      INNER JOIN Invoice i ON i.CustomerId = c.CustomerId
                      INNER JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId) cteLinea
                INNER join Track t ON t.TrackId = cteLinea.TrackId
                INNER join Genre g ON t.GenreId = g.GenreId
    ORDER BY cteLinea.CustomerId) 


/*
 */
 
 
 

    
    
