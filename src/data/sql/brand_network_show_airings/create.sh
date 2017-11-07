#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   airing_date DATE, INDEX(airing_date),
   daypart VARCHAR(24), INDEX(daypart),
   broadcast_year INT(4),
   broadcast_quarter VARCHAR(20),
   broadcast_month VARCHAR(20),
   broadcast_week INT(2),
   spend INT(10) UNSIGNED,
   airings INT(11) DEFAULT 0,
   tv_network VARCHAR(100), INDEX(tv_network),
   show_title VARCHAR(100), INDEX(show_title),
   show_genres VARCHAR(100), INDEX(show_genres),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_brand_name VARCHAR(120), INDEX(coop_brand_name),
   UNIQUE KEY(brand_id, airing_date, daypart, tv_network, show_title, show_genres, coop_brand_id)
);
DROP TRIGGER IF EXISTS bns_airing_init$now;
DELIMITER //
CREATE TRIGGER bns_airing_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.coop_brand_id = 0 THEN
		#SET NEW.coop_brand_id := NULL; # For all engines, a UNIQUE index permits multiple NULL values for columns that can contain NULL.
		SET NEW.coop_brand_name := NULL;
	END IF;
    END//
DELIMITER ;"
