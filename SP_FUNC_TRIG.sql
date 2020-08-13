
delimiter //

drop procedure if exists sp_my_vers//
create procedure sp_my_vers ()
begin 
	select version(); 
end//

set @for_user_id = 1//

drop procedure if exists sp_prefers//
create procedure sp_prefers ()
begin 
	-- в одном городе
	select up2.user_id from users_profiles up1 join users_profiles up2 on up1.hometouwn = up2.hometouwn 
	where up1.user_id = @for_user_id and up2.user_id != @for_user_id;
	-- заказывали одни товары
	select distinct o.user_id from orders o join orders_products op on o.id = op.order_id 
	where o.user_id != @for_user_id and product_id 
	in (select op.product_id from orders o join orders_products op on o.id = op.order_id where o.user_id = @for_user_id);
	
end//

delimiter ;
-- функция для подсчета количества заказанного товара, сделана из интерфейса "дебивера"
set @product_id = 10;
DROP FUNCTION IF EXISTS f_coun_prod_order;

DELIMITER $$
$$
CREATE FUNCTION f_coun_prod_order()
RETURNS INT deterministic
BEGIN
	declare requests_orders bigint;
	set requests_orders = (
	select count(*) from orders_products where product_id = @product_id
	);
	return requests_orders;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS check_user_age_befor_update;

DELIMITER $$
$$
CREATE TRIGGER check_user_age_befor_UPDATE
BEFORE UPDATE 
ON users FOR EACH ROW
begin 
	IF NEW.birthday_at >= current_date() THEN
		signal sqlstate '45000'
			SET MESSAGE_TEXT = 'Отменено';
	END IF;
end
$$
DELIMITER ;

DROP TRIGGER IF EXISTS check_user_age_befor_INSERT;

DELIMITER $$
$$
CREATE TRIGGER check_user_age_befor_INSERT
BEFORE INSERT 
ON users FOR EACH ROW
begin 
	IF NEW.birthday_at > current_date() THEN
		SET NEW.birthday_at = current_date();
	END IF;
end
$$
DELIMITER ;

-- Логировать удаления каталогов в отдельную таблицу


DROP TRIGGER IF EXISTS check_del_catalogs;

DELIMITER $$
$$
CREATE TRIGGER check_del_catalogs
AFTER  DELETE 
ON catalogs FOR EACH ROW
BEGIN 
	DECLARE var_User varchar(100);
	SELECT USER() INTO var_User;
	INSERT INTO del_by
   ( name,
   	 id,
     deleted_date,
     deleted_by)
   VALUES
   ( OLD.name,
     OLD.id,
     now(),
     var_User );
	
END
$$
DELIMITER ;


DROP TRIGGER IF EXISTS watchlog_users_INSERT;
DELIMITER //
CREATE TRIGGER watchlog_users_INSERT AFTER INSERT ON users
FOR EACH ROW
BEGIN
	DECLARE var_User varchar(100);
	SELECT USER() INTO var_User;
	INSERT INTO create_users (created_at, name_by, str_id, name_value)
	VALUES (NOW(), var_User, NEW.id, NEW.name);
END //
DELIMITER ;





