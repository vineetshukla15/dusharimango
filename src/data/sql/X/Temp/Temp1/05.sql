DROP TABLE IF EXISTS insights.brands;
CREATE TABLE insights.brands
(
   brand_id int(11) unsigned, PRIMARY KEY(brand_id),
   brand_name varchar(120), INDEX(brand_name),
   brand_display_name varchar(120), INDEX(brand_display_name),
   brand_group_id int(11) unsigned, INDEX(brand_group_id)# FOREIGN KEY(brand_group_id) references insights.brands(brand_id)
);
DROP TRIGGER IF EXISTS insights.brands_init;
DELIMITER //
CREATE TRIGGER insights.brand_init BEFORE INSERT ON insights.brands FOR EACH ROW
	BEGIN
    IF NEW.brand_group_id IS NULL THEN
		SET NEW.brand_group_id := NEW.brand_id;
	END IF;
--     IF NEW.brand_display_name IS NULL THEN
-- 		SET NEW.brand_display_name := NEW.brand_name;
-- 	END IF;
    END//
DELIMITER ;

DROP TABLE IF EXISTS insights.categories;
CREATE TABLE insights.categories
(
   category_id int(10) unsigned, PRIMARY KEY(category_id),
   category_name varchar(120), INDEX(category_name),
   category_display_name varchar(120), INDEX(category_display_name),
   parent_category_id int(10) unsigned, INDEX(parent_category_id)# FOREIGN KEY(parent_category_id) references insights.categories(category_id)
);
-- DROP TRIGGER IF EXISTS insights.category_init;
-- DELIMITER //
-- CREATE TRIGGER insights.category_init BEFORE INSERT ON insights.categories FOR EACH ROW
-- 	BEGIN
--     IF NEW.category_display_name IS NULL THEN
-- 		SET NEW.category_display_name := NEW.category_name;
-- 	END IF;
--     END//
-- DELIMITER ;

-- DROP TABLE IF EXISTS insights.productlines;
-- CREATE TABLE insights.productlines
-- (
--    productline_id int(11) unsigned, PRIMARY KEY(productline_id),
--    productline_name varchar(120), INDEX(productline_name),
--    brand_id int(11) unsigned, FOREIGN KEY(brand_id) references insights.brands(brand_id),
--    category_id int(10) unsigned, FOREIGN KEY(category_id) references insights.categories(category_id)
-- );

DROP TABLE IF EXISTS insights.products;
CREATE TABLE insights.products
(
   product_id int(11) unsigned, PRIMARY KEY(product_id),
   product_name varchar(120), INDEX(product_name),
   brand_id int(11) unsigned, INDEX(brand_id),# FOREIGN KEY(brand_id) references insights.brands(brand_id),
   category_id int(10) unsigned DEFAULT NULL, INDEX(category_id),# FOREIGN KEY(category_id) references insights.categories(category_id),
   product_display_name varchar(120), INDEX(product_display_name),
   productline_id int(11) unsigned, INDEX(productline_id)# FOREIGN KEY(productline_id) references insights.products(product_id)
--    productline_id int(11) unsigned, FOREIGN KEY(productline_id) references insights.productlines(productline_id)
);
DROP TRIGGER IF EXISTS insights.product_init;
DELIMITER //
CREATE TRIGGER insights.product_init BEFORE INSERT ON insights.products FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
	END IF;
--     IF NEW.product_display_name IS NULL THEN
-- 		SET NEW.product_display_name := NEW.product_name;
-- 	END IF;
    IF NEW.productline_id IS NULL THEN
		SET NEW.productline_id := NEW.product_id;
	END IF;
    END//
DELIMITER ;

-- DROP TABLE IF EXISTS insights.commercial_group;
-- CREATE TABLE insights.commercial_group
-- (
--    commercial_group_id int(10) unsigned, PRIMARY KEY(commercial_group_id),
--    flag_bearing_commercial_id int(10) unsigned, INDEX(flag_bearing_commercial_id)
-- );

DROP TABLE IF EXISTS insights.contents;
CREATE TABLE insights.contents
(
   content_id int(11) unsigned, PRIMARY KEY(content_id),
   content_title varchar(255), INDEX(content_title),
   content_duration int(10) unsigned,
   alphonso_owned boolean,
   product_id int(11) unsigned, INDEX(product_id),# FOREIGN KEY(content_product_id) references insights.products(product_id),
   content_group_id int(11) unsigned, INDEX(content_group_id),# FOREIGN KEY(content_group_id) references insights.contents(content_id),
   content_display_title varchar(255), INDEX(content_display_title),
   coop_product_id int(11) unsigned, INDEX(coop_product_id)# FOREIGN KEY(content_product_id) references insights.products(product_id)
);
DROP TRIGGER IF EXISTS insights.content_init;
DELIMITER //
CREATE TRIGGER insights.content_init BEFORE INSERT ON insights.contents FOR EACH ROW
	BEGIN
    IF NEW.content_group_id = 0 THEN
		SET NEW.content_group_id := NEW.content_id;
	END IF;
    END//
DELIMITER ;
-- DROP TABLE IF EXISTS insights.coop;
-- CREATE TABLE insights.coop
-- (
--    commercial_id int(10) unsigned, FOREIGN KEY(commercial_id) references insights.commercial(commercial_id),
--    product_id int(10) unsigned, FOREIGN KEY(product_id) references insights.product(product_id)
-- );

DROP TABLE IF EXISTS insights.airings_master;
CREATE TABLE insights.airings_master
(
   content_id int(11) unsigned, INDEX(content_id),# FOREIGN KEY(content_id) references insights.contents(content_id),
   airing_start_time_UTC datetime, INDEX(airing_start_time_UTC),
   pod_position int(10) unsigned,
   spend int(10) unsigned,
   tv_station_id int(10) unsigned, INDEX(tv_station_id),
   tv_station_tz varchar(100), INDEX(tv_station_tz),
   tv_network varchar(100), INDEX(tv_network),
   show_title varchar(100), INDEX(show_title),
   show_genres varchar(100),
   show_start_time_UTC datetime,
   show_end_time_UTC datetime,
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id)
);

DROP TABLE IF EXISTS insights.content_product_brand_category;
CREATE TABLE insights.content_product_brand_category
(
   content_id int(11) unsigned, PRIMARY KEY(content_id),
   content_title varchar(255), INDEX(content_title),
   content_duration int(10) unsigned,
   alphonso_owned boolean,
   content_group_id int(11) unsigned, INDEX(content_group_id),#content_group_id and content_duration should be used in combination to unique content groups
   #content_group_title varchar(255), INDEX(content_group_title),
   product_id int(11) unsigned, INDEX(product_id),
   product_name varchar(120), INDEX(product_name),
   productline_id int(11) unsigned, INDEX(productline_id),
   #productline_name varchar(120), INDEX(productline_name),
   brand_id int(11) unsigned, INDEX(brand_id),
   brand_name varchar(120), INDEX(brand_name),
   brand_group_id int(11) unsigned, INDEX(brand_group_id),
   #brand_group_name varchar(120), INDEX(brand_group_name),
   category_id int(10) unsigned DEFAULT NULL, INDEX(category_id),
   category_name varchar(120), INDEX(category_name),
   coop_product_id int(11) unsigned, INDEX(coop_product_id),
   coop_product_name varchar(120), INDEX(coop_product_name),
   coop_productline_id int(11) unsigned, INDEX(coop_productline_id),
   #coop_productline_name varchar(120), INDEX(coop_productline_name),
   coop_brand_id int(11) unsigned, INDEX(coop_brand_id),
   coop_brand_name varchar(120), INDEX(coop_brand_name),
   coop_brand_group_id int(11) unsigned, INDEX(coop_brand_group_id),
   #coop_brand_group_name varchar(120), INDEX(coop_brand_group_name),
   coop_category_id int(10) unsigned DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name varchar(120), INDEX(coop_category_name)
);


DROP TABLE IF EXISTS insights.airings;#content_product_brand_category_station_network_show
CREATE TABLE insights.airings
(
   content_id int(10) unsigned, INDEX(content_id),# FOREIGN KEY(content_id) references insights.contents(content_id),
   content_title varchar(255), INDEX(content_title),
   content_duration int(10) unsigned,
   alphonso_owned boolean,
   content_group_id int(11) unsigned, INDEX(content_group_id),#content_group_id and content_duration should be used in combination to unique content groups
   #content_group_title varchar(255), INDEX(content_group_title),
   product_id int(11) unsigned, INDEX(product_id),
   product_name varchar(120), INDEX(product_name),
   productline_id int(11) unsigned, INDEX(productline_id),
   #productline_name varchar(120), INDEX(productline_name),
   brand_id int(11) unsigned, INDEX(brand_id),
   brand_name varchar(120), INDEX(brand_name),
   brand_group_id int(11) unsigned, INDEX(brand_group_id),
   #brand_group_name varchar(120), INDEX(brand_group_name),
   category_id int(10) unsigned DEFAULT NULL, INDEX(category_id),
   category_name varchar(120), INDEX(category_name),
   airing_start_time_UTC datetime, INDEX(airing_start_time_UTC),
   airing_time datetime, INDEX(airing_time),
   daypart varchar(24), INDEX(daypart),
   pod_position int(10) unsigned,
   spend int(10) unsigned,
   tv_station_id int(10) unsigned, INDEX(tv_station_id),
   tv_station_tz varchar(100), INDEX(tv_station_tz),
   tv_network varchar(100), INDEX(tv_network),
   show_title varchar(100), INDEX(show_title),
   show_genres varchar(100),
   show_start_time_UTC datetime,
   show_end_time_UTC datetime,
   show_start_time datetime,
   show_end_time datetime,
   coop_product_id int(11) unsigned, INDEX(coop_product_id),
   coop_product_name varchar(120), INDEX(coop_product_name),
   coop_productline_id int(11) unsigned, INDEX(coop_productline_id),
   #coop_productline_name varchar(120), INDEX(coop_productline_name),
   coop_brand_id int(11) unsigned, INDEX(coop_brand_id),
   coop_brand_name varchar(120), INDEX(coop_brand_name),
   coop_brand_group_id int(11) unsigned, INDEX(coop_brand_group_id),
   #coop_brand_group_name varchar(120), INDEX(coop_brand_group_name),
   coop_category_id int(10) unsigned DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name varchar(120), INDEX(coop_category_name),
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id)
);





DROP TABLE IF EXISTS insights.tv_station_pricing;
CREATE TABLE insights.tv_station_pricing
(
   tv_station_id int(10) unsigned, INDEX(tv_station_id),
   tv_network varchar(100), INDEX(tv_network),
   datetime_range_start datetime,
   datetime_range_end datetime,
   show_genres varchar(100),
   commercial_duration int(10) unsigned,
   tv_station_spot_price int(10) unsigned
)