DROP DATABASE DBMascotas;
CREATE DATABASE DBMascotas;

USE DBMascotas;

CREATE TABLE DBMascotas.clientes (
	cedula varchar(10),
    primer_nombre varchar(20) NOT NULL,
    segundo_nombre varchar(20) NULL,
    primer_apellido varchar(20) NOT NULL,
    segundo_apellido varchar(20) NOT NULL,
    direccion varchar(50) NOT NULL,
    PRIMARY KEY(cedula)
);

CREATE TABLE DBMascotas.clientes_telefonos(
	telefono varchar(15) NOT NULL,
    cedula varchar(10) NOT NULL,
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula)
);

CREATE TABLE DBMascotas.mascotas (
	nombre varchar(50) NOT NULL,
    genero char(1) NOT NULL,
    raza varchar(50) NULL,
    tipo varchar(50) NOT NULL,
    id_mascota int auto_increment,
    cedula varchar(10),
    PRIMARY KEY(id_mascota),
    FOREIGN KEY(cedula) REFERENCES DBMascotas.clientes(cedula)
);

CREATE TABLE DBMascotas.vacunas(
	nombre varchar(20) NOT NULL,
    dosis int NOT NULL,
    enfermedad varchar(20) NOT NULL,
    id_vacuna int NOT NULL auto_increment,
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
    codigo_barras int auto_increment,
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
    codigo_barras int NOT NULL,
    id_venta int NOT NULL,
    FOREIGN KEY(codigo_barras) REFERENCES DBMascotas.productos(codigo_barras),
    FOREIGN KEY(id_venta) REFERENCES DBMascotas.ventas(id_venta)
);
describe vacunas;
insert into clientes values("1021634663", "tomas", "andres", "ruiz", "correa", "calle 17#4-88"),("7438296129", "jaime", "antonio", "gamba", "smith", "calle50 #3"),("4729481067", "juan", "felipe", "poveda", "jimenez", "calle 20#50-3"),("0391463728", "Juan", "jose", "obando", "ruiz", "calle 123 #4"),("7438138947", "angel", "david", "amaya", "montoya", "calle 53#123");
insert into mascotas (nombre, genero, raza, tipo, cedula) values("firulais", "M", "salchicha", "perro","1021634663"),("snoopy", "M", "beagle", "perro", "1021634663"),("pepito", "M", "bulldog", "perro", "1021634663"),("pancho", "M", "pastor aleman","perro","1021634663"),("buñuelo", "M", "chihuahua", "perro", "1021634663");
insert into vacunas (nombre, dosis, enfermedad) values("astrazeneca", 3, "coronavirus"), ("johnson", 3, "coronavirus"), ("poliomielitis", 1, "poliovirus"), ("dtp", 4, "tetano"), ("mmr", 1, "sarampion");
insert into productos (nombre, marca, precio) values("shampoo", "CanAmor", 30500), ("comidaPerro", "pedigree", 60000), ("comidaGato", "whiskas", 35000), ("comidaPez", "nutripez", 10500), ("comidaPerro", "perroski", 25000);



#cambiar 1 campo en varios registros
update mascotas set nombre="pepito" where id_mascota in (2,3);
select * from mascotas;
#en un registro cambiar varios campos
update mascotas set raza="bulldog frances", genero='f' where id_mascota = 1;

#begin rollback commit

#show variables like "autocommit";
#show processlist;
#select * from information_schema.innoddb_trx;

create view vistaMascotas1 as select m.nombre, m.raza from mascotas m;
select * from vistaMascotas1;

#nombre cliente y nombre mascota
create view vistaMascotas as select m.nombre, c.primer_nombre from clientes c inner join mascotas m on c.cedula = m.cedula;
select * from vistaMascotas;

DELIMITER $$
create procedure MascotasPorCliente(in cedula_cliente varchar(10))
begin
	select nombre, cedula from mascotas where cedula = cedula_cliente;
end $$
DELIMITER ;
call MascotasPorCliente("1021634663");

DELIMITER $$
create procedure ConsultarRegistrarMascota(
in nombre_mascota varchar(50),
in genero_mascota char(1),
in raza_mascota varchar(50),
in tipo_mascota varchar(50),
in id_mascota int,
in cedula_mascota varchar(10)
)
begin
	declare v_nombre varchar(50);
    select nombre into v_nombre from mascotas where nombre_mascota = nombre limit 1;
    if v_nombre is null then
		insert into mascotas (id_mascota, nombre, genero, raza, tipo, cedula) values("", nombre_mascota, genero_mascota, raza_mascota, tipo_mascota, cedula_mascota);
	else
		select concat("la mascota ", nombre_mascota, "ya esta registrada") as mensaje;
        select * from mascotas where nombre_mascota = nombre;
    end if;
end$$
DELIMITER ;
#call ConsultarRegistrarMascota("pepito perez", "M", "xxx", "dddd", "","1021634663");

#select * from mascotas;

drop procedure ConsultarVacunas;
DELIMITER $$
create procedure ConsultarVacunas(
in id_masc int,
in id_vac int
)
begin
	select m.nombre, v.nombre
    from vacunas_aplicadas a
    inner join mascotas m on m.id_mascota = a.id_mascota
    inner join vacunas v on v.id_vacuna =  a.id_vacuna
    where a.id_mascota = id_masc and a.id_vacuna = id_vac;
end$$
DELIMITER ;

#call ConsultarVacunas(1,1);
#insert into vacunas_aplicadas (id_mascota, id_vacuna) values(1,1), (1,2), (2,1);
#select * from vacunas_aplicadas;