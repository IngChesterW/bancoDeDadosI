create database bdventa;
use bdventa;
create table cliente(
    id_cliente int not null AUTO_INCREMENT  primary key;
    nombre varchar(30);
    codigo varchar(9);
    telefono varchar(8);
)engine=innodb;
create table vendedor(
    id_vendedor int not  null AUTO_INCREMENT  primary key,
    nombre varchar(30),
    codigo varchar(9),
    telefono varchar(8)
)engine=innodb;
create table venta
(
    id_venta int not null AUTO_INCREMENT  primary key,
    fecha date,
    id_cliente int not null,
    id_vendedor int not null,
    constraint fk_cliente foreign key (id_cliente) references cliente(id_cliente),
    constraint fk_vendedor foreign key (id_vendedor) references vendedor(id_vendedor) 
)engine=innodb;
create table categoria
(
    id_categoria not null AUTO_INCREMENT primary key  ,
    nombre_categoria varchar(30),
)engine=innodb;
create table producto
(
    id_producto int not null AUTO_INCREMENT  primary key  ,
    nombre_producto varchar(30) not null,
    stok int,
    precio decimal(10,2),
    id_categoria int not null,
    constraint fk_categoria foreign key (id_categoria) references categoria(id_categoria)
)engine=innodb;
create table detalleVenta
(
    id_detalleVenta int not null AUTO_INCREMENT primary key,
    id_venta int not null ,
    id_producto int not null,
    cantidad int not null,
    constraint fk_venta foreign key(id_venta) references venta(id_venta),
    constraint fk producto foreign key(id_producto) references producto(id_producto)
)engine=innodb;
create procedure sp_insertarCliente
(
    in id int,
    in nomb varchar(30),
    in cod varchar(9),
    in telf varchar(20)
)
begin
insert into cliente values ( id,nomb,cod,telf);
end
delimiter;
create procedure sp_consultas_clientes()
begin
  select * from cliente
end
delimiter;
create procedure proc_venta_fechainicial_fechafin(in fechaIni date, in fechaFin date )
begin
  select venta.id_venta,venta.fecha,concat(cliente.nombre,'',cliente.codigo) as cliente,
    sum(producto.precio*detalleVenta.cantidad) as totalVenta,
  from cliente,venta,detalleVenta,producto
  where (cliente.id_cliente=venta.id_cliente and venta.id_venta = detalleVenta.id_venta and producto.id_producto = detalleVenta.id_producto and venta.fecha >= fechaIni and venta.fecha <= fechaFin)
  group by venta.id_venta;
end;
delimiter;
create procedure consulta_venta_codigo(in cod int)
begin
  select venta.id_venta, venta.fecha,concat(cliente.nombre,'',cliente.codigo) as cliente,
  producto.nombre_producto, producto.precio, detalleVenta.cantidad,(producto.precio*detalleVenta.cantidad) as subTot
  from venta, cliente, detalleVenta, producto
  where venta.idcliente = cliente.id_cliente and venta.id_venta = detalleVenta.id_venta and detalleVenta.id_producto =  producto.id_producto and venta.id_venta=cod;
end;
delimiter;
