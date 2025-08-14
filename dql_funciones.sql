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