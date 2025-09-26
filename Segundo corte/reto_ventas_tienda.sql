create database ventas_tienda;
use ventas_tienda;

create table cliente(
	id_cliente int auto_increment key,
    documentoCliente varchar(50) not null,
    email varchar(50) not null,
    telefono varchar(50) null,
    fechaRegistro timestamp
);

create table pedido(
	id_pedido int auto_increment primary key,
    id_clienteFK int not null,
    fecha_pedido date not null,
    total decimal(10,2),
    foreign key(id_clienteFK) references cliente(id_cliente)
);

create table usuario(
	id_usuario int auto_increment primary key,
    nombre_usuario varchar(20) not null,
    contraseña varchar(20) not null
);

create table producto(
	id_producto int auto_increment primary key,
    nombre varchar(20) not null,
    marca varchar(20) not null
);

create table detalle_pedido(
	id_productoFK int not null,
    id_pedidoFK int not null,
    foreign key(id_pedidoFK) references pedido(id_pedido),
    foreign key(id_productoFK) references producto(id_producto)
);

alter table cliente
add id_usuarioFK int not null,
add foreign key(id_usuarioFK) references usuario(id_usuario);
