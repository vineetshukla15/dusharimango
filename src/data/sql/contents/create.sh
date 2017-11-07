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
   product_id INT(11) UNSIGNED, INDEX(product_id), # FOREIGN KEY(product_id) references products(product_id),
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id), # FOREIGN KEY(coop_product_id) references products(product_id),
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id), # FOREIGN KEY(content_group_id) references contents(content_id),
   content_display_title VARCHAR(255), INDEX(content_display_title)
);
DROP TRIGGER IF EXISTS content_init$now;
DELIMITER //
CREATE TRIGGER content_init$now BEFORE INSERT ON $tblname FOR EACH ROW
	BEGIN
    IF NEW.coop_product_id = 0 THEN
		SET NEW.coop_product_id := NULL;
	END IF;
    IF NEW.content_group_id = 0 THEN
		SET NEW.content_group_id := NEW.content_id;
	END IF;
    END//
DELIMITER ;"