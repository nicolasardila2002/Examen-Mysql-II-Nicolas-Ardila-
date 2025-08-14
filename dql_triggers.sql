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

-- Tabla de auditoría de clientes
CREATE TABLE IF NOT EXISTS AuditoriaCliente (
    AuditoriaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    CampoModificado NVARCHAR(40),
    ValorAnterior NVARCHAR(255),
    ValorNuevo NVARCHAR(255),
    FechaCambio DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- AuditarActualizacionCliente
DELIMITER //

CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    IF OLD.FirstName <> NEW.FirstName THEN
        INSERT INTO AuditoriaCliente (ClienteID, CampoModificado, ValorAnterior, ValorNuevo)
        VALUES (OLD.CustomerId, 'FirstName', OLD.FirstName, NEW.FirstName);
    END IF;

    IF OLD.LastName <> NEW.LastName THEN
        INSERT INTO AuditoriaCliente (ClienteID, CampoModificado, ValorAnterior, ValorNuevo)
        VALUES (OLD.CustomerId, 'LastName', OLD.LastName, NEW.LastName);
    END IF;

    IF OLD.Email <> NEW.Email THEN
        INSERT INTO AuditoriaCliente (ClienteID, CampoModificado, ValorAnterior, ValorNuevo)
        VALUES (OLD.CustomerId, 'Email', OLD.Email, NEW.Email);
    END IF;
END;
//

DELIMITER ;

--  Tabla de historial de precios de canciones
CREATE TABLE IF NOT EXISTS HistorialPrecioCancion (
    HistorialID INT AUTO_INCREMENT PRIMARY KEY,
    TrackID INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaCambio DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- RegistrarHistorialPrecioCancion
DELIMITER //

CREATE TRIGGER RegistrarHistorialPrecioCancion
BEFORE UPDATE ON Track
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        INSERT INTO HistorialPrecioCancion (TrackID, PrecioAnterior, PrecioNuevo)
        VALUES (OLD.TrackId, OLD.UnitPrice, NEW.UnitPrice);
    END IF;
END;
//

DELIMITER ;

-- Tabla de notificaciones por cancelación de ventas
CREATE TABLE IF NOT EXISTS NotificacionCancelacionVenta (
    NotificacionID INT AUTO_INCREMENT PRIMARY KEY,
    InvoiceID INT,
    ClienteID INT,
    FechaCancelacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    Motivo NVARCHAR(255)
);

-- Trigger: NotificarCancelacionVenta
DELIMITER //

CREATE TRIGGER NotificarCancelacionVenta
BEFORE DELETE ON Invoice
FOR EACH ROW
BEGIN
    INSERT INTO NotificacionCancelacionVenta (InvoiceID, ClienteID, Motivo)
    VALUES (OLD.InvoiceId, OLD.CustomerId, 'Cancelación de venta registrada');
END;
//

DELIMITER ;

-- Trigger: RestringirCompraConSaldoDeudor
DELIMITER //

CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE deuda DECIMAL(10,2);

    SELECT SUM(Total) INTO deuda
    FROM Invoice
    WHERE CustomerId = NEW.CustomerId;

    IF deuda > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Compra bloqueada: cliente con saldo deudor.';
    END IF;
END;
//

DELIMITER ;
