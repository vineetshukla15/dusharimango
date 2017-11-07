#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_id INT(10) UNSIGNED, INDEX(content_id), # content_group_id, used in combination with content_duration
   content_duration INT(10) UNSIGNED,
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id),
   product_id INT(11) UNSIGNED, INDEX(product_id),
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id),
   airing_date DATE, INDEX(airing_date),
   daypart VARCHAR(24), INDEX(daypart),
   lat FLOAT(5,2), INDEX(lat),
   lng FLOAT(5,2), INDEX(lng),
   viewers INT(10) DEFAULT 0,
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(coop_category_id),
   UNIQUE KEY(content_id, airing_date, daypart, lat, lng)
);
DROP TRIGGER IF EXISTS content_viewer_init$now;
DELIMITER //
CREATE TRIGGER content_viewer_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
	END IF;
    IF NEW.coop_product_id = 0 THEN
		SET NEW.coop_product_id := NULL;
		SET NEW.coop_brand_id := NULL;
	END IF;
    IF NEW.coop_category_id = 0 THEN
		SET NEW.coop_category_id := NULL;
	END IF;
    END//
DELIMITER ;"