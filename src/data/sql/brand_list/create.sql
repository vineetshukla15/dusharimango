#DROP TABLE IF EXISTS brand_list;
CREATE TABLE brand_list
(
   brand_id INT(11) UNSIGNED, PRIMARY KEY(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   is_transient BOOLEAN DEFAULT TRUE
);