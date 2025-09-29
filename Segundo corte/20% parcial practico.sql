create database empleados_2;
use empleados_2;

create table departamento(
	id_departamento int primary key auto_increment,
	nombre VARCHAR(50)
);

insert into departamento (id_departamento, nombre) values ("", "IT");
insert into departamento (id_departamento, nombre) values ("", "Ventas");
insert into departamento (id_departamento, nombre) values ("", "Recursos Humanos");
insert into departamento (id_departamento, nombre) values ("", "Contabilidad");
insert into departamento (id_departamento, nombre) values ("", "Legal");

create table empleados (
	id_empleado int primary key auto_increment,
	nombre VARCHAR(50),
	fecha_nacimiento date,
	salario DECIMAL(7,2),
	fecha_contrato DATE,
    id_departamentoFK int,
    foreign key(id_departamentoFK) references departamento(id_departamento)
);

insert into empleados (id_empleado,nombre, fecha_nacimiento, salario, fecha_contrato, id_departamentoFK) values("", "tomas ruiz", "2007/02/14", 4730.03, "2024/03/03", 1);
insert into empleados (id_empleado,nombre, fecha_nacimiento, salario, fecha_contrato, id_departamentoFK) values("", "juan felipe poveda", "2005/03/04", 5302.93, "2023/02/02", 3);
insert into empleados (id_empleado,nombre, fecha_nacimiento, salario, fecha_contrato, id_departamentoFK) values("", "juan jose obando", "1963/06/24", 2532.25, "2021/05/07", 1);
insert into empleados (id_empleado,nombre, fecha_nacimiento, salario, fecha_contrato, id_departamentoFK) values("", "angel david amaya", "1990/12/19", 4003.00, "2025/09/13", 2);
insert into empleados (id_empleado,nombre, fecha_nacimiento, salario, fecha_contrato, id_departamentoFK) values("", "jaime antonio gamba", "2003/06/3", 1000.23, "2024/10/26", 4);

#1.lista de empleados
select nombre, timestampdiff(year, fecha_nacimiento, curdate()), salario from empleados;

#2.altos ingresos
select nombre, salario from empleados where salario > 4000;

#3.fuerza de ventas
select nombre, id_departamentoFK from empleados where (select nombre from departamento where id_departamento = id_departamentoFK) = "Ventas";

#4.rango de edad
select nombre, timestampdiff(year, fecha_nacimiento, curdate()) from empleados where timestampdiff(year, fecha_nacimiento, curdate()) between 30 and 40;

#5.nuevas contrataciones
select nombre, fecha_contrato from empleados where year(fecha_contrato) > 2020;

#6.distribucion de empleados
select id_departamentoFK, count(*) as num_empleados from empleados group by id_departamentoFK; 

#7.análisis salarial
select avg(salario) as promedio_salario from empleados;

#8.nombres selectivos
select nombre from empleados where left(nombre, 1) in ('A', 'C');

#9.departamentos específicos
select nombre, id_departamentoFK from empleados where (select nombre from departamento where id_departamento = id_departamentoFK) != "IT";

#10.el mejor pagado
select nombre, salario from empleados where salario = (select max(salario) from empleados);

#consultar los empleados cuyos salarios sean mayor al salario promedio

#nombre del empleado con el segundo salario mas alto

#utilizando left join muestre los departamentos que no tienen empleados asignados
select e.nombre as 'empleado', d.nombre as 'departamento' from empleados e inner join departamento d on e.id_departamentoFK = d.id_departamento;
#muestre el total de empleados por cada departamento