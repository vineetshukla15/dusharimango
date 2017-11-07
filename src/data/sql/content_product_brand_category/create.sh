#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_id INT(11) UNSIGNED, PRIMARY KEY(content_id),
   content_title VARCHAR(255), INDEX(content_title),
   content_duration INT(10) UNSIGNED,
   alphonso_owned BOOLEAN,
   publish_status BOOLEAN,
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id), # content_group_id and content_duration should be used in combination to unique content groups
   content_group_title VARCHAR(255), INDEX(content_group_title),
   product_id INT(11) UNSIGNED, INDEX(product_id),
   product_name VARCHAR(120), INDEX(product_name),
   productline_id INT(11) UNSIGNED, INDEX(productline_id),
   productline_name VARCHAR(120), INDEX(productline_name),
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   brand_group_id INT(11) UNSIGNED, INDEX(brand_group_id),
   brand_group_name VARCHAR(120), INDEX(brand_group_name),
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id),
   category_name VARCHAR(120), INDEX(category_name),
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id),
   coop_product_name VARCHAR(120), INDEX(coop_product_name),
   coop_productline_id INT(11) UNSIGNED, INDEX(coop_productline_id),
   coop_productline_name VARCHAR(120), INDEX(coop_productline_name),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_brand_name VARCHAR(120), INDEX(coop_brand_name),
   coop_brand_group_id INT(11) UNSIGNED, INDEX(coop_brand_group_id),
   coop_brand_group_name VARCHAR(120), INDEX(coop_brand_group_name),
   coop_category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name VARCHAR(120), INDEX(coop_category_name)
);
DROP TRIGGER IF EXISTS cpbcat_init$now;
DELIMITER //
CREATE TRIGGER cpbcat_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
		SET NEW.category_name := NULL;
	END IF;
    IF NEW.coop_product_id = 0 THEN
		SET NEW.coop_product_id := NULL;
		SET NEW.coop_product_name := NULL;
		SET NEW.coop_productline_id := NULL;
		SET NEW.coop_productline_name := NULL;
		SET NEW.coop_brand_id := NULL;
		SET NEW.coop_brand_name := NULL;
		SET NEW.coop_brand_group_id := NULL;
		SET NEW.coop_brand_group_name := NULL;
	END IF;
    IF NEW.coop_category_id = 0 THEN
		SET NEW.coop_category_id := NULL;
		SET NEW.coop_category_name := NULL;
	END IF;
    END//
DELIMITER ;"