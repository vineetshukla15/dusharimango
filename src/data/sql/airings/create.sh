#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

# The queries on this table should be on content_group_id and not content_id
# the content_id exists, and not replaced by content_group_id, to avoid accidental duplication of records
# Check if above is a valid scenario: Low priority
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_id INT(10) UNSIGNED, INDEX(content_id), # FOREIGN KEY(content_id) references insights.contents(content_id),
   content_title VARCHAR(255), INDEX(content_title),
   content_duration INT(10) UNSIGNED,
   alphonso_owned BOOLEAN,
   publish_status BOOLEAN,
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id), # content_group_id and content_duration should be used in combination to unique content groups
   #content_group_title varchar(255), INDEX(content_group_title),
   product_id INT(11) UNSIGNED, INDEX(product_id),
   product_name VARCHAR(120), INDEX(product_name),
   #productline_id int(11) unsigned, INDEX(productline_id),
   #productline_name varchar(120), INDEX(productline_name),
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   #brand_group_id int(11) unsigned, INDEX(brand_group_id),
   #brand_group_name varchar(120), INDEX(brand_group_name),
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id),
   category_name VARCHAR(120), INDEX(category_name),
   airing_start_time_UTC DATETIME, INDEX(airing_start_time_UTC),
   airing_time DATETIME, INDEX(airing_time),
   daypart VARCHAR(24), INDEX(daypart),
   daypart2 VARCHAR(24), INDEX(daypart2),
   broadcast_year INT(4),
   broadcast_quarter VARCHAR(20),
   broadcast_month VARCHAR(20),
   broadcast_week INT(2),
   pod_position INT(10) UNSIGNED,
   spend INT(10) UNSIGNED,
   tv_station_id INT(10) UNSIGNED, INDEX(tv_station_id),
   tv_station_tz VARCHAR(100), INDEX(tv_station_tz),
   tv_network VARCHAR(100), INDEX(tv_network),
   show_tmsid VARCHAR(100), INDEX(show_tmsid),
   show_title VARCHAR(100), INDEX(show_title),
   show_genres VARCHAR(100), INDEX(show_genres),
   #show_start_time_UTC datetime,
   #show_end_time_UTC datetime,
   #show_start_time datetime,
   #show_end_time datetime,
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id),
   coop_product_name VARCHAR(120), INDEX(coop_product_name),
   #coop_productline_id int(11) unsigned, INDEX(coop_productline_id),
   #coop_productline_name varchar(120), INDEX(coop_productline_name),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_brand_name VARCHAR(120), INDEX(coop_brand_name),
   #coop_brand_group_id int(11) unsigned, INDEX(coop_brand_group_id),
   #coop_brand_group_name varchar(120), INDEX(coop_brand_group_name),
   coop_category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name VARCHAR(120), INDEX(coop_category_name),
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id, tv_station_tz) # Duplicated from arings_master
);
DROP TRIGGER IF EXISTS airing_init$now;
DELIMITER //
CREATE TRIGGER airing_init$now BEFORE INSERT ON $tblname FOR EACH ROW
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