#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id),
   airing_date DATE, INDEX(airing_date),
   spend INT(10) UNSIGNED DEFAULT 0,
   airings INT(11) UNSIGNED DEFAULT 0,
   UNIQUE KEY(category_id, airing_date)
);
DROP TRIGGER IF EXISTS category_airing_init$now;
DELIMITER //
CREATE TRIGGER category_airing_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
	END IF;
    END//
DELIMITER ;"