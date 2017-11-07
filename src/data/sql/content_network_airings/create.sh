#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_id INT(10) UNSIGNED, INDEX(content_id), # FOREIGN KEY(content_id) references insights.contents(content_id),
   content_title VARCHAR(255), INDEX(content_title),
   content_duration INT(10) UNSIGNED,
   alphonso_owned BOOLEAN,
   publish_status BOOLEAN,
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id),
   product_id INT(11) UNSIGNED, INDEX(product_id),
   product_name VARCHAR(120), INDEX(product_name),
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id),
   category_name VARCHAR(120), INDEX(category_name),
   airing_date DATE, INDEX(airing_date),
   daypart VARCHAR(24), INDEX(daypart),
   broadcast_year INT(4),
   broadcast_quarter VARCHAR(20),
   broadcast_month VARCHAR(20),
   broadcast_week INT(2),
   spend INT(10) UNSIGNED,
   airings INT(11) DEFAULT 0,
   tv_network VARCHAR(100), INDEX(tv_network),
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id),
   coop_product_name VARCHAR(120), INDEX(coop_product_name),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_brand_name VARCHAR(120), INDEX(coop_brand_name),
   coop_category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name VARCHAR(120), INDEX(coop_category_name),
   UNIQUE KEY(content_id, airing_date, daypart, tv_network)
);
DROP TRIGGER IF EXISTS cn_airing_init$now;
DELIMITER //
CREATE TRIGGER cn_airing_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
		SET NEW.category_name := NULL;
	END IF;
    IF NEW.coop_product_id = 0 THEN
		SET NEW.coop_product_id := NULL;
		SET NEW.coop_product_name := NULL;
		SET NEW.coop_brand_id := NULL;
		SET NEW.coop_brand_name := NULL;
	END IF;
    IF NEW.coop_category_id = 0 THEN
		SET NEW.coop_category_id := NULL;
		SET NEW.coop_category_name := NULL;
	END IF;
    END//
DELIMITER ;"