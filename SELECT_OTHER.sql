use beta_home_project;

-- 1. SELECT запросы

-- 1.1 Выборки пользователей

SELECT name, birthday_at from users where birthday_at + INTERVAL 18 year > now();
SELECT name, birthday_at from users where birthday_at + INTERVAL 18 year < now();
select name, (to_days(now()) - to_days(birthday_at)) / 365.25 as age from users;
select name, (to_days(now()) - to_days(birthday_at)) / 365.25 as age from users having age > 18;
select name, floor((to_days(now()) - to_days(birthday_at)) / 365.25) as age from users having age > 18;
select name, timestampdiff(year, birthday_at, now()) as age from users;
select id, name from users order by rand();
select id, concat(name, ' ', timestampdiff(year, birthday_at, now())) as name_age from users;
select id, if(timestampdiff(year, birthday_at, now()) > 18, 'Совершеннолетний', 'Не овершеннолетний') as status from users;
select id, concat(name, ' ', timestampdiff(year, birthday_at, now())) as name_age, if(timestampdiff(year, birthday_at, now()) > 18, 'Совершеннолетний', 'Не овершеннолетний') as status from users;
select id, name, id % 3 from users order by id % 3;
select id, name, substring(birthday_at, 1, 3) as decad from users order by decad desc;
select substring(birthday_at, 1, 3) as decad from users group by decad;
select count(*) as total, substring(birthday_at, 1, 3) as decad from users group by decad order by total desc;
select group_concat(name separator ' ') as names, substring(birthday_at, 1, 3) as decad from users group by decad;


-- 1.2 Выборки товаров

SELECT id, name, price from products where price between 5000 and 10000;
SELECT id, name, price from products order by price;
SELECT id, name, price from products order by price desc;
SELECT id, name, price from products order by price limit 1;
SELECT id, name, price from products order by price desc limit 1;
SELECT id, name, price, catalog_id from products order by catalog_id, price;
SELECT id, name, price, catalog_id from products order by catalog_id, price;
select distinct catalog_id from products;
select catalog_id from products group by catalog_id;
select id, catalog_id, name, price from products where catalog_id = 1 and price > 50000;
select catalog_id, sum(price), min(price) as min_p, max(price), avg(price) from products group by catalog_id order by min_p;

-- 1.3 Вложенные запросы, like запросы

select name, (select hometouwn from users_profiles where user_id = users.id) as city from users;
select * from media_type where name like '%s';
select count(*), monthname(birthday_at) from users group by monthname(birthday_at) order by count(*) desc;
select * from orders_products where product_id in (select id from orders where user_id = 1);
select id, name, (select name from catalogs where id = catalog_id) as `catalog` from products;
select id, name, catalog_id from products where catalog_id in (1, 10);
select id, name, price, catalog_id from products where catalog_id = 2 and price < all (select price from products where catalog_id = 10);
select id, name, price, catalog_id from products where catalog_id = 2 and price < any (select price from products where catalog_id = 10);
select id, name, price, catalog_id from products where catalog_id = 2 and price < some (select price from products where catalog_id = 10);
select id, name, price, catalog_id from products where catalog_id = 2;

insert catalogs (name) values ('for_check');
insert products (name, catalog_id) values ('Allert', '11');

select * from catalogs where exists (select * from products where catalog_id = catalogs.id);
select * from catalogs where not exists (select * from products where catalog_id = catalogs.id);
select id, name, price, catalog_id from products where (catalog_id, 27911.6) in (select id, price from catalogs);
select catalog_id, min(price) from products group by catalog_id;
select avg(price) from (select min(price) as price from products group by catalog_id) as avr_p;
select avg(p) from (select price as p from products where catalog_id = 1) as avr_p;


-- 2 Сложные запросы

-- 2.1 union

select name from users union select name from staff;
select name from users union all select name from staff;
select name from users union all select name from staff order by name;
select name from users union all select name from staff order by name desc;
select count(*) from users union all select count(*) from staff;

-- 2.2 join 

select * from users_profiles join staff_profiles;
select users_profiles.created_at, staff_profiles.created_at from users_profiles join staff_profiles;
select p.name, p.price, c.name from catalogs as c join products as p where c.id = p.catalog_id;
select u.name, o.id from users as u join orders as o where u.id = o.user_id;
select p.name, op.id from products as p join orders_products as op where p.id = op.product_id;
select p.name, op.id from products as p join orders_products as op on p.id = op.product_id;
select * from catalogs as c1 join catalogs as c2 on c1.id = c2.id;
select * from catalogs as c1 join catalogs as c2;
select * from catalogs as c1 join catalogs as c2 using(id);



select p.name, c.name from products as p join catalogs as c on p.catalog_id = c.id;
select count(*) from users_profiles;
select count(*) from staff_profiles;
select * from users_profiles join staff_profiles;
select * from users_profiles, staff_profiles;
select count(*) from users_profiles, staff_profiles;
select p.name, p.price, c.name from catalogs as c left join products as p on c.id = p.catalog_id;
select count(*), products.name from products join catalogs on products.catalog_id = catalogs.id group by products.catalog_id order by count(*);
select p.name, c.name, st.value from products as p join catalogs as c on p.catalog_id = c.id join storehouses_products as st on st.product_id = p.id where p.id = 1;
select count(*), concat(u.name, ' ', u.id) as nameID from users u join  orders o on u.id = o.user_id group by u.id;


-- Транзакции

select price from products where id = 1;

start transaction;
update products set price = price + 7000 where id = 1;
commit;

start transaction;
update products set price = price + 7000 where id = 1;
rollback;


-- Переменные 
select @name := 'Igor';
select @name;

select @price := max(price) from products;
select * from products where price = @price;

prepare var from 'select * from products where price = @price';
execute var;


-- delet комманды

SET FOREIGN_KEY_CHECKS = 0;
delete products, catalogs from catalogs join products on catalogs.id = products.catalog_id where catalogs.name = 'for_check';
SET FOREIGN_KEY_CHECKS = 1;

-- update комманды 

update products set price = price - 1000  where catalog_id = 1 and price > 50000;
update catalogs join products on catalog_id = products.catalog_id set price = price * 0.9 where catalogs.name = 'consequuntur';



