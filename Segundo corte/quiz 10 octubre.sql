use DBMascotas;

#1.Incluir en la tabla vacuna el campo para la fecha de vigencia de la vacuna Crear una función para saber si la vacuna esta vigente o esta vencida
alter table vacunas
add column fecha date not null;

DELIMITER $$
create function esVigente(fecha date)
returns bool
not deterministic
begin
	declare esVigente bool;
    if curdate() > fecha then
        set esVigente = false;
    else
        set esVigente = true;
    end if;
    return esVigente;
end$$
DELIMITER ;

select nombre, fecha, esVigente(fecha) from vacunas;

#2. crear función para mostrar el nombre de la mascota, la raza y el nombre del propietario
drop function mostrarInfo;
DELIMITER $$
create function mostrarInfo(id_mascota_p int)
returns varchar(60)
not deterministic
begin
	declare nom varchar(20);
    declare raza varchar(20);
    declare nom_cliente varchar(20);
	select m.nombre, m.raza, c.primer_nombre into nom, raza, nom_cliente from mascotas m
    inner join clientes c on m.cedula = c.cedula
    where id_mascota_p = m.id_mascota;
    return concat("nombre: ", nom, ", raza: ", raza, ", nombre dueño: ", nom_cliente);
end$$
DELIMITER ;

select m.id_mascota, m.nombre, m.raza, c.primer_nombre, mostrarInfo(id_mascota) from mascotas m
inner join clientes c on c.cedula = m.cedula;

#3. crear trigger que impade que se elimine un cliente si tiene una mascota registrada
drop trigger evitarEliminacion;
DELIMITER $$
create trigger evitarEliminacion
before delete on clientes
for each row
begin
    declare mensaje varchar(100);
    if exists (select 1 from mascotas m where m.cedula = old.cedula) then
        SIGNAL SQLSTATE '45000';
        set MESSAGE_TEXT = "cliente tiene mascotas";
    end if;
end$$
DELIMITER ;

delete from clientes where cedula = "1021634663";
select * from clientes;

#4. trigger que cuando se elimine un cliente lo guarde en una tabla que se llame clientesEliminados
create table clientes_eliminados(
	cedula varchar(10),
    primer_nombre varchar(20) NOT NULL,
    segundo_nombre varchar(20) NULL,
    primer_apellido varchar(20) NOT NULL,
    segundo_apellido varchar(20) NOT NULL,
    direccion varchar(50) NOT NULL,
    PRIMARY KEY(cedula)
);

DELIMITER $$
create trigger guardar_cliente_eliminado
before delete on clientes
for each row
begin
	insert into clientes_eliminados (cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion)
    values (
		old.cedula,
        old.primer_nombre,
        old.segundo_nombre,
        old.primer_apellido,
        old.segundo_apellido,
        old.direccion
	);
end $$
DELIMITER ;

#5. en la tabla cliente van a agregar un campo que se llame fecha de actualizacion 
#y crear un trigger cada vez que se actualice un cliente se actualice automaticamente ese campo de fecha
alter table clientes
add column fecha_actualizacion date;

DELIMITER $$
create trigger actualizar_fecha
before update on clientes
for each row
begin
	set new.fecha_actualizacion = curdate();
end$$
DELIMITER ;
