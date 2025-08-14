-- ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
delimiter //
create trigger tg_actualizacion_ventas 
after insert on ReportsTo
for each ROW 
BEGIN 
	update Employee 
	set ReportsTo = ReportsTo - new.ReportsTo  
	where Quantity = new.Quantity;

	if (select ReportsTo  from Employee e  where ReportsTo = new.ReportsTo ) < 0 then
		
	end if;
END//

delimiter ;