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
   airing_date DATE, INDEX(airing_date),
   daypart VARCHAR(24), INDEX(daypart),
   lat FLOAT(5,2), INDEX(lat),
   lng FLOAT(5,2), INDEX(lng),
   viewers INT(10) DEFAULT 0,
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   UNIQUE KEY(brand_id, airing_date, daypart, lat, lng, coop_brand_id)
);
/*DROP TRIGGER IF EXISTS brand_viewer_init$now;
DELIMITER //
CREATE TRIGGER brand_viewer_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.coop_brand_id = 0 THEN
		SET NEW.coop_brand_id := NULL; # For all engines, a UNIQUE index permits multiple NULL values for columns that can contain NULL.
	END IF;
    END//
DELIMITER ;*/"