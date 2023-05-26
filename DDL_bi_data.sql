-- Creamos la base de datos que utilizaremos en el proyecto
create schema bi_data;

-- Creamos la tabla de clientes "customers"
-- que tiene las siguientes columnas: cust_id	cust_name	cust_seg	cust_region	cust_city	cust_state_province	cust_pc
create table bi_data.customers
(
    cust_id             varchar(250) comment 'Customer ID',
    cust_name           varchar(50)  not null comment 'Customer name',
    cust_seg            varchar(50)  not null comment 'Customer segment',
    cust_email          varchar(50)  not null comment 'Customer email',
    cust_gender         varchar(50)  not null comment 'Customer gender',
    cust_address        varchar(50)  not null comment 'Customer all address',
    cust_phone          varchar(50)  not null comment 'Customer phone',
    constraint cust_pk
        primary key (`cust_id`)
);

-- Moficicar el varchar5(50) por varchar(250) en la columna cust_address
alter table bi_data.customers
    modify cust_address varchar(250) not null comment 'Customer all address';

-- Creamos la tabla de subcategorias "sub_categories"
-- que tiene las siguientes columnas: sub_category_id	sub_category_name category
create table bi_data.sub_categories
(
    sub_category_id   int comment 'Sub Category ID',
    sub_category_name varchar(50)  not null comment 'Sub Category name',
    category          varchar(50)  not null comment 'Category',
    constraint sc_pk
        primary key (`sub_category_id`)
);

alter table bi_data.sub_categories
    modify sub_category_id int auto_increment comment 'Sub Category ID';

-- Creamos la tabla de productos "products" que tiene relacion con la tabla de subcategorias
-- tiene las siguientes columnas: prod_id	sub_category_id	prod_name	prod_profit	prod_price
create table bi_data.products
(
    prod_id          varchar(250) comment 'Product ID',
    sub_category_id  int comment 'Sub Category ID',
    prod_name        varchar(50)  not null comment 'Product name',
    prod_profit      decimal(10, 2) not null comment 'Product profit',
    prod_price       decimal(10, 2) not null comment 'Product price',
    constraint prod_pk
        primary key (`prod_id`),
    constraint prod_sc_fk
        foreign key (`sub_category_id`) references bi_data.sub_categories (`sub_category_id`)
);

ALTER TABLE bi_data.products
    MODIFY prod_name VARCHAR(250) NOT NULL COMMENT 'Product name';

-- Creamos la tabla de metodos de envio "ship_modes"
-- que tiene las siguientes columnas: ship_mode_id	ship_mode_name
create table bi_data.ship_modes
(
    ship_mode_id   int comment 'Ship Mode ID',
    ship_mode_name varchar(50)  not null comment 'Ship Mode name',
    constraint sm_pk
        primary key (`ship_mode_id`)
);

alter table bi_data.ship_modes
    modify ship_mode_id int auto_increment comment 'Ship Mode ID';

-- creamos la tabla de los centros de distribucion "dist_center"
create table bi_data.dist_center
(
    dc_id      int comment 'Distribution Center ID',
    dc_name    varchar(50)  not null comment 'Distribution center name',
    dc_manager varchar(150) not null comment 'Distribution center manager',
    constraint dc_pk
        primary key (`dc_id`)
);

alter table bi_data.dist_center
    modify dc_id int auto_increment comment 'Distribution Center ID';

-- Creamos la tabla de pedidos "orders" que tiene relacion con la tabla de clientes, productos y envios
-- que tiene las siguientes columnas: order_id	order_date	sales	order_quantity	order_discount	cust_id	prod_id	ship_id
create table bi_data.orders
(
    order_id         varchar(250) comment 'Order ID',
    order_date       date not null comment 'Order date',
    sales            decimal(10, 2) not null comment 'Sales',
    cust_id          varchar(250) comment 'Customer ID',
    constraint order_pk
        primary key (`order_id`),
    constraint order_cust_fk
        foreign key (`cust_id`) references bi_data.customers (`cust_id`)
);

-- generaremos una tabla del detalle de las ordenes para fines practicos
-- Creamos la tabla de detalle de pedidos "order_details" que tiene relacion con la tabla de pedidos y productos
-- que tiene las siguientes columnas: order_id	order_quantity	order_discount
create table bi_data.orders_details
(
    order_detail_id  int auto_increment comment 'Order detail ID',
    order_id         varchar(250) comment 'Order ID',
    order_quantity   int not null comment 'Order quantity',
    order_discount   decimal(10, 2) not null comment 'Order discount',
    prod_id          varchar(250) comment 'Product ID',
    constraint order_detail_pk
        primary key (`order_detail_id`),
    constraint order_detail_prod_fk
        foreign key (`prod_id`) references bi_data.products (`prod_id`),
    constraint order_detail_order_fk
        foreign key (`order_id`) references bi_data.orders (`order_id`)
);

-- Creamos la tabla de envios "ships" que tiene relacion con la tabla de metodos de envio y centros de distribucion
-- que tiene las siguientes columnas: order_id	ship_id	ship_date	ship_region	ship_city	ship_state_province	ship_pc	ship_mode_id	dc_id
create table bi_data.ships
(
    ship_id              int comment 'Ship ID',
    order_id             varchar(250) comment 'Order ID',
    ship_date            date not null comment 'Ship date',
    ship_region          varchar(50)  not null comment 'Ship region',
    ship_city            varchar(50)  not null comment 'Ship city',
    ship_state_province  varchar(50)  not null comment 'Ship state province',
    ship_pc              varchar(50)  not null comment 'Ship postal code',
    ship_mode_id         int comment 'Ship Mode ID',
    dc_id                int comment 'Distribution Center ID',

    constraint ship_pk
        primary key (`ship_id`),
    constraint ship_sm_fk
        foreign key (`ship_mode_id`) references bi_data.ship_modes (`ship_mode_id`),
    constraint ship_dc_fk
        foreign key (`dc_id`) references bi_data.dist_center (`dc_id`),
    constraint ship_orders_fk
        foreign key (`order_id`) references bi_data.orders (`order_id`)
);

alter table bi_data.ships
    modify ship_id int auto_increment comment 'Ship ID';


