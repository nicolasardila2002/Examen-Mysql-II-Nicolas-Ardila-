-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.
SELECT ReportsTo, Employeeid
FROM Employee 
WHERE ReportsTo >=5; 
-- Lista los cinco artistas con más canciones vendidas en el último año.
SELECT TrackId, SUM(UnitPrice) as "CancionesVendidas"
from InvoiceLine
group by TrackId 
HAVING CancionesVendidas > 0.1;
--  Total de ventas y cantidad de canciones vendidas por país
SELECT 
    c.Country,
    SUM(i.Total) AS TotalVentas,
    COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY c.Country;

--  Número total de clientes que realizaron compras por cada género en un mes específico
SELECT 
    g.Name AS Genero,
    COUNT(DISTINCT i.CustomerId) AS Clientes
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE MONTH(i.InvoiceDate) = 7 AND YEAR(i.InvoiceDate) = 2025
GROUP BY g.Name;



--  Tres países con mayores ventas durante el último semestre
SELECT c.Country, SUM(i.Total) AS TotalVentas
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.Country
ORDER BY TotalVentas DESC
LIMIT 3;



-- 6. Promedio de edad de los clientes al momento de su primera compra
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(YEAR, e.BirthDate, MIN(i.InvoiceDate))), 1) AS EdadPromedio
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY c.CustomerId;


--  Informe de los clientes con más compras recurrentes
SELECT c.CustomerId, c.FirstName, c.LastName, COUNT(i.InvoiceId) AS Compras
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Compras DESC
LIMIT 10;

-- Precio promedio de venta por género
SELECT g.Name AS Genero, ROUND(AVG(il.UnitPrice), 2) AS PrecioPromedio
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name;

-- Cinco canciones más largas vendidas en el último año
SELECT t.Name, t.Milliseconds
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY t.Milliseconds DESC
LIMIT 5;



--  Cantidad total de minutos comprados por cada cliente en el último mes
SELECT c.CustomerId, c.FirstName, c.LastName,
