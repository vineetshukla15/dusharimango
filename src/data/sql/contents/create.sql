#DROP TABLE IF EXISTS contents;
CREATE TABLE contents
(
   content_id INT(11) UNSIGNED, PRIMARY KEY(content_id),
   content_title VARCHAR(255), INDEX(content_title),
   content_duration INT(10) UNSIGNED,
   alphonso_owned BOOLEAN,
   product_id INT(11) UNSIGNED, INDEX(product_id), # FOREIGN KEY(product_id) references products(product_id),
   coop_product_id INT(11) UNSIGNED, INDEX(coop_product_id), # FOREIGN KEY(coop_product_id) references products(product_id),
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id), # FOREIGN KEY(content_group_id) references contents(content_id),
   content_display_title VARCHAR(255), INDEX(content_display_title)
);
DROP TRIGGER IF EXISTS content_init;
DELIMITER //
CREATE TRIGGER content_init BEFORE INSERT ON contents FOR EACH ROW
	BEGIN
    IF NEW.coop_product_id = 0 THEN
		SET NEW.coop_product_id := NULL;
	END IF;
    IF NEW.content_group_id = 0 THEN
		SET NEW.content_group_id := NEW.content_id;
	END IF;
    END//
DELIMITER ;