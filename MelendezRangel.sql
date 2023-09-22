/*


Laboratorio SQL por Daniela Leilany del Carmen Melendez Rangel 
DNI: 95855287 
LU: 102/20
*/
-- 1) en pizarron: "VENTA = INVOICE"
/*
Obtener la cantidad de ventas por país ordenadas de mayor a
menor. La consulta debe devolver país y cantidad de ventas.
*/

SELECT i.BillingCountry, COUNT(*) AS 'Cantidad de Ventas'
    FROM Invoice i
    GROUP BY i.BillingCountry
    ORDER BY COUNT(*) DESC

-- 2)
/*
Obtener los clientes cuyas compras en total superan los 40 pesos.
Devolver ID del cliente, y la cantidad total gastada de cada cliente
ordenada de mayor a menor
*/

SELECT c.CustomerId, SUM(i.Total) AS 'CantidadTotalGastada'
    FROM Invoice i
    INNER JOIN Customer c ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
    HAVING SUM(i.Total) >= 40
    ORDER BY SUM(i.Total) DESC 

-- 3) 
/*¿Cuál es el promedio de álbumes por PlayList? La respuesta debe ser un número.
*/
SELECT AVG(k.cantAlbums) AS 'PromedioAlbumsPorPlaylist' 
    FROM (SELECT q.PlaylistId, COUNT(q.AlbumId) as 'cantAlbums'
            FROM (SELECT DISTINCT p.PlaylistId, t.AlbumId
                        FROM Playlist p
                        LEFT OUTER JOIN PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
                        INNER JOIN Track t ON t.TrackId = pt.TrackId) q
            GROUP BY q.PlaylistId) k


-- 4)
/*
Obtener la cantidad de ventas de cada vendedor al año y ordenar
de mayor a menor por cantidad de ventas. Se debe devolver
EmployeeId, año y cantidad de ventas.
*/

SELECT e.EmployeeId, YEAR(i.InvoiceDate) AS 'Year', COUNT(*) AS 'Cantidad de Ventas'
    FROM Invoice i
    INNER JOIN Customer c ON c.CustomerId = i.CustomerId
    RIGHT OUTER JOIN Employee e ON c.SupportRepId = e.EmployeeId
    WHERE e.Title = 'Sales Support Agent'
    GROUP BY e.EmployeeId, YEAR(i.InvoiceDate)
    ORDER BY COUNT(*) DESC

-- 5)
/*
Obtener las Playlist cuyos tracks sean todos del mismo género.
Devolver la PlaylistId y su nombre junto con el id del género y su
nombre.

Nota para el corrector: Lo interpreto como "si no hay tracks, entonces no coloco la playlist", 
porque sino las 2 lineas (la que empieza con LEFT OUTER JOIN y INNER JOIN) las debo borrar y cambiar por:
    LEFT OUTER JOIN (PlaylistTrack pt INNER JOIN Track t ON pt.TrackId = t.TrackId) ON pt.PlaylistId = p.PlaylistId
*/

SELECT p.PlaylistId, t.GenreId, COUNT(t.TrackId) AS 'cantTracks'
    FROM Playlist p
    LEFT OUTER JOIN PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
    INNER JOIN Track t ON pt.TrackId = t.TrackId
    GROUP BY p.PlaylistId, t.GenreId
    HAVING COUNT(t.TrackId) = (SELECT COUNT(ptDos.TrackId) 
                                    FROM Playlist pDos
                                    LEFT OUTER JOIN PlaylistTrack ptDos ON ptDos.PlaylistId = pDos.PlaylistId
                                    WHERE pDos.PlaylistId = p.PlaylistId) 


-- 6)
/*
Devolver, si es que lo hubiera, el nombre y el id del género que no
haya sido comprado aún por ningún cliente
*/

SELECT c.CustomerId, g.GenreId
    FROM Customer c
    CROSS JOIN Genre g
EXCEPT
SELECT c.CustomerId, t.GenreId
    FROM Customer c
    LEFT OUTER JOIN Invoice i ON i.CustomerId = c.CustomerId
    INNER JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
    INNER JOIN Track t ON t.TrackId = il.TrackId

