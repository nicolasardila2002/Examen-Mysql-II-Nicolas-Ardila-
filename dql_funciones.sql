-- TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.
delimiter //
create function TotalGastoCliente(CustomerId int, Total decimal(10.2) )
returns decimal(10,2)
deterministic
begin
	declare Total decimal(10,2);
	set Total = 
end //
delimiter ;
-- PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.

delimiter //
create function PromedioPrecioPorAlbum(AlbumId int)
returns decimal(5,2)
deterministic
begin
	declare precio_promedio decimal(10,2);
	select UnitPrice(TrackId) into precio_promedio from Track  where AlbumId = id;
	set precio_promedio = 1.00 - TrackId ;
	return precio_promedio;
end //
delimiter ;

select PromedioPrecioPorAlbum();

-- DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
delimiter //
create function DuracionTotalPorGenero(Milliseconds int) 
returns int
reads sql data
begin
    declare tiempo_promedio int;
    
    select avg(TIMEDIFF(
        (select min(Milliseconds) from Track  
         where Genreid = pp.Name and Milliseconds = 'Segundos'),
        (select max(Milliseconds) from Track t  
         where Genreid = pp.Name and Milliseconds = 'Segundos')
    )) into tiempo_promedio
    from Track t2  pp
    where pp.Milliseconds = Milliseconds;
    
    return tiempo_promedio;
end //
delimiter ;

select DuracionTotalPorGenero();
-- DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
DELIMITER //

CREATE FUNCTION DescuentoPorFrecuencia(p_ClienteID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE v_Frecuencia INT;
    DECLARE v_Descuento DECIMAL(5,2);

    SELECT COUNT(*) INTO v_Frecuencia
    FROM Invoice
    WHERE CustomerId = p_ClienteID;

    IF v_Frecuencia >= 20 THEN
        SET v_Descuento = 0.20; -- 20%
    ELSEIF v_Frecuencia >= 10 THEN
        SET v_Descuento = 0.10; -- 10%
    ELSEIF v_Frecuencia >= 5 THEN
        SET v_Descuento = 0.05; -- 5%
    ELSE
        SET v_Descuento = 0.00; -- Sin descuento
    END IF;

    RETURN v_Descuento;
END;
//

DELIMITER ;

-- VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
DELIMITER //

CREATE FUNCTION VerificarClienteVIP(p_ClienteID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_GastoAnual DECIMAL(10,2);

    SELECT SUM(Total) INTO v_GastoAnual
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    RETURN v_GastoAnual >= 1000;
END;
//

DELIMITER ;
