#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   brand_id INT(11) UNSIGNED, PRIMARY KEY(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   brand_display_name VARCHAR(120), INDEX(brand_display_name),
   brand_group_id INT(11) UNSIGNED, INDEX(brand_group_id) # FOREIGN KEY(brand_group_id) references brands(brand_id)
);
DROP TRIGGER IF EXISTS brand_init$now;
DELIMITER //
CREATE TRIGGER brand_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.brand_group_id IS NULL THEN
		SET NEW.brand_group_id := NEW.brand_id;
	END IF;
    END//
DELIMITER ;"