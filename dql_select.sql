-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.
SELECT ReportsTo, Employeeid
FROM Employee 
WHERE ReportsTo >=5; 
-- Lista los cinco artistas con más canciones vendidas en el último año.
SELECT TrackId, SUM(UnitPrice) as "CancionesVendidas"
from InvoiceLine
group by TrackId 
HAVING CancionesVendidas > 0.1;