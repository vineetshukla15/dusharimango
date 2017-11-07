#DROP TABLE IF EXISTS products;
CREATE TABLE products
(
   product_id INT(11) UNSIGNED, PRIMARY KEY(product_id),
   product_name VARCHAR(120), INDEX(product_name),
   brand_id INT(11) UNSIGNED, INDEX(brand_id), # FOREIGN KEY(brand_id) references brands(brand_id),
   category_id INT(10) UNSIGNED DEFAULT NULL, INDEX(category_id), # FOREIGN KEY(category_id) references categories(category_id),
   product_display_name VARCHAR(120), INDEX(product_display_name),
   productline_id INT(11) UNSIGNED, INDEX(productline_id) # FOREIGN KEY(productline_id) references products(product_id)
);
DROP TRIGGER IF EXISTS product_init;
DELIMITER //
CREATE TRIGGER product_init BEFORE INSERT ON products FOR EACH ROW
	BEGIN
    IF NEW.category_id = 0 THEN
		SET NEW.category_id := NULL;
	END IF;
    IF NEW.productline_id IS NULL THEN
		SET NEW.productline_id := NEW.product_id;
	END IF;
    END//
DELIMITER ;