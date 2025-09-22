CREATE DATABASE DBMascotas;
#DROP DATABASE dbmascotas;

USE DBMascotas;
CREATE TABLE DBMascotas.mascotas (
	nombre varchar(50) NOT NULL,
    genero char(1) NOT NULL,
    raza varchar(50) NULL,
    id_mascota int auto_increment,
    PRIMARY KEY(id_mascota)
);

CREATE TABLE DBMascotas.mascotas_tipo(
	tipo varchar(20) NOT   NULL,
	id_mascota int NOT NULL,
    FOREIGN KEY(id_mascota) REFERENCES DBMascotas.mascotas(id_mascota)
);

CREATE TABLE DBMascotas.clientes (
	cedula varchar(10),
    primer_nombre varchar(20) NOT NULL,
    segundo_nombre varchar(20) NULL,
    primer_apellido varchar(20) NOT NULL,
    segundo_apellido varchar(20) NOT NULL,
    PRIMARY KEY(cedula)
);
describe dbmascotas.mascotas;

CREATE TABLE DBMascotas.clientes_direccion(
	direccion varchar(50) NOT NULL,
    cedula varchar(10) NOT NULL,
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula)
);

CREATE TABLE DBMascotas.clientes_telefonos(
	telefono varchar(15) NOT NULL,
    cedula varchar(10) NOT NULL,
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula)
);
  
CREATE TABLE DBMascotas.mascotas_compradas(
	id_mascota int NOT NULL,
    cedula varchar(10) NOT NULL,
    costo float NOT NULL,
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula),
    FOREIGN KEY(id_mascota) REFERENCES DBMascotas.mascotas(id_mascota)
);

CREATE TABLE DBMascotas.vacunas(
	nombre varchar(20) NOT NULL,
    dosis int NOT NULL,
    enfermedad varchar(20) NOT NULL,
    id_vacuna int NOT NULL,
    PRIMARY KEY(id_vacuna)
);

CREATE TABLE DBMascotas.vacunas_aplicadas(
	id_vacuna int NOT NULL,
    id_mascota int NOT NULL,
    FOREIGN KEY(id_vacuna) REFERENCES DBMascotas.vacunas(id_vacuna),
    FOREIGN KEY(id_mascota) REFERENCES DBMascotas.mascotas(id_mascota)
);

CREATE TABLE DBMascotas.productos(
	nombre varchar(20) NOT NULL,
    marca varchar(20) NOT NULL,
    precio float NOT NULL,
    codigo_barras char(100),
    PRIMARY KEY(codigo_barras)
);

CREATE TABLE DBMascotas.ventas(
	id_venta int,
    fecha datetime NOT NULL,
    costo_total float NOT NULL,
    cedula varchar(10) NOT NULL,
    PRIMARY KEY(id_venta),
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula)
);

CREATE TABLE DBMascotas.ventas_detalle(
	cantidad int NOT NULL,
    codigo_barras char(100) NOT NULL,
    id_venta int NOT NULL,
    FOREIGN KEY(codigo_barras) REFERENCES DBMascotas.productos(codigo_barras),
    FOREIGN KEY(id_venta) REFERENCES DBMascotas.ventas(id_venta)
);

describe dbmascotas.mascotas;

insert into dbmascotas.mascotas values("firulais", "M", "salchicha", ""),("snoopy", "M", "beagle", ""),("pepito", "M", "bulldog", ""),("pancho", "M", "pastor aleman", ""),("buñuelo", "M", "chihuahua", "");
select * from mascotas;
