DROP DATABASE IF EXISTS alfa_home_project;
CREATE DATABASE alfa_home_project;
USE alfa_home_project;

DROP TABLE IF EXISTS catalogs; 
CREATE TABLE catalogs (
	id SERIAL,
	name VARCHAR(255) UNIQUE COMMENT '�������� �������',
	is_delete BIT DEFAULT 0
) COMMENT '������� ��������';

 
DROP TABLE IF EXISTS users; 
CREATE TABLE users (
	id SERIAL,
	name VARCHAR(255) COMMENT '��� ����������',
	birthday_at DATE COMMENT '���� ��������',
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0
) COMMENT '����������';

DROP TABLE IF EXISTS users_profiles; 
CREATE TABLE users_profiles (
	user_id BIGINT UNSIGNED NOT NULL,
	gender ENUM ('�','�'),
	hometouwn VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
	
) COMMENT '������� �����������';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL,
	name VARCHAR(255) COMMENT '�������� ������',
	discription TEXT COMMENT '��������',
	price DECIMAL (11,2) COMMENT '����',
	catalog_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	KEY products_name_idx (name) COMMENT '������ ��� ������ �� ������������ ������',
	
	FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
	
) COMMENT '�������� �������';

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type (
	id SERIAL,
	name VARCHAR(100),
	is_delete BIT DEFAULT 0
) COMMENT '���� ������';

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	product_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	filename VARCHAR (255) COMMENT '������ ��� ����� ��������� ����',
	metadata JSON,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (media_type_id) REFERENCES media_type(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
	
) COMMENT '����� �����';

DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
	to_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM ('��', '���', '� ��������'),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS opinions;
CREATE TABLE opinions (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,
	discription TEXT COMMENT '��������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
	
) COMMENT '������';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
	
) COMMENT '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id SERIAL,
	order_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,
	total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	PRIMARY KEY (order_id, product_id),
	FOREIGN KEY (order_id) REFERENCES orders(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
	
) COMMENT '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,
	discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
	started_at DATETIME,
	finished_at DATETIME,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	KEY index_of_user_id(user_id),
	KEY index_of_product_id(product_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (product_id) REFERENCES products(id)

) COMMENT '������';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
	id SERIAL,
	name VARCHAR(255) COMMENT '��������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0
) COMMENT '������';	

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL,
	storehouses_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,
	value INT UNSIGNED COMMENT '������� �������� ������� �� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (storehouses_id) REFERENCES storehouses(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
	
) COMMENT '������� �� ������';

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id SERIAL,
	storehouses_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255) COMMENT '��� ����������',
	birthday_at DATE COMMENT '���� ����������',
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (storehouses_id) REFERENCES storehouses(id)
	
) COMMENT '����������';

DROP TABLE IF EXISTS staff_profiles;
CREATE TABLE staff_profiles (
	staff_id BIGINT UNSIGNED NOT NULL,
	gender ENUM ('�','�'),
	hometouwn VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	is_delete BIT DEFAULT 0,
	
	FOREIGN KEY (staff_id) REFERENCES staff(id)
	
) COMMENT '������� �����������';


DROP TABLE IF EXISTS del_by;
CREATE TABLE del_by (
  name VARCHAR(100),
  id BIGINT,
  deleted_date DATETIME,
  deleted_by VARCHAR(100)

)  ENGINE = ARCHIVE COMMENT '��� ������ ��������';

DROP TABLE IF EXISTS create_users;
CREATE TABLE create_users (
	created_at DATETIME NOT NULL,
	name_by VARCHAR(45) NOT NULL,
	str_id BIGINT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE COMMENT '��� �������� �������������';

-- �������������

CREATE VIEW v_catalogs_view AS SELECT * FROM catalogs ORDER BY name;
create view v_catalogs_reverse_view (catalogs, catalog_id) as select name, id from catalogs;
create or replace view v_prodacts_view (id, name, price, total) as select p.id, p.name, p.price, length (name) from products as p;
create algorithm = temptable view v_catalogs_view_new as select * from catalogs;
CREATE OR REPLACE VIEW v_cat (prod_id, prod_name, catalog_name) AS
SELECT p.id AS prod_id, p.name, cat.name
FROM products AS p
LEFT JOIN catalogs AS cat 
ON p.catalog_id = cat.id;




