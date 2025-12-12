CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;

CREATE TABLE categorias (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    idCategoria INT,
    talla VARCHAR(10),
    color VARCHAR(30),
    stock INT DEFAULT 0,
    fechaRegistro DATETIME DEFAULT NOW(),
    FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria)
);

CREATE TABLE precios (
    idPrecio INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT NOT NULL,
    precioCompra DECIMAL(10,2) NOT NULL,
    precioVenta DECIMAL(10,2) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    FOREIGN KEY (idProducto) REFERENCES productos(idProducto)
);

CREATE TABLE stock_estado (
    idStockEstado INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT NOT NULL,
    estado ENUM('DISPONIBLE','NO DISPONIBLE') NOT NULL,
    fechaActualizacion DATETIME DEFAULT NOW(),
    FOREIGN KEY (idProducto) REFERENCES productos(idProducto)
);

CREATE TABLE inventario_movimientos (
    idMovimiento INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT NOT NULL,
    tipo ENUM('ENTRADA', 'SALIDA') NOT NULL,
    cantidad INT NOT NULL,
    fechaMovimiento DATETIME DEFAULT NOW(),
    motivo VARCHAR(200),
    FOREIGN KEY (idProducto) REFERENCES productos(idProducto)
);

CREATE TABLE clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    dni CHAR(8),
    telefono VARCHAR(15),
    direccion VARCHAR(200)
);

CREATE TABLE ventas (
    idVenta INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    fechaVenta DATETIME DEFAULT NOW(),
    total DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

CREATE TABLE ventas_detalle (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    FOREIGN KEY (idVenta) REFERENCES ventas(idVenta),
    FOREIGN KEY (idProducto) REFERENCES productos(idProducto)
);

CREATE TABLE pagos (
    idPago INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT NOT NULL,
    montoPagado DECIMAL(10,2) NOT NULL,
    metodoPago ENUM('EFECTIVO','TARJETA','YAPE','PLIN') NOT NULL,
    fechaPago DATETIME DEFAULT NOW(),
    FOREIGN KEY (idVenta) REFERENCES ventas(idVenta)
);

DELIMITER $$
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON ventas_detalle
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE idProducto = NEW.idProducto;

    IF (SELECT stock FROM productos WHERE idProducto = NEW.idProducto) > 0 THEN
        INSERT INTO stock_estado(idProducto, estado)
        VALUES(NEW.idProducto, 'DISPONIBLE');
    ELSE
        INSERT INTO stock_estado(idProducto, estado)
        VALUES(NEW.idProducto, 'NO DISPONIBLE');
    END IF;
END $$
DELIMITER ;
