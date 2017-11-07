#DROP TABLE IF EXISTS insights.coop_list;
CREATE TABLE insights.coop_list
(
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   coop_brand_id INT(11) UNSIGNED, INDEX(coop_brand_id),
   coop_brand_name VARCHAR(120), INDEX(coop_brand_name),
   is_transient BOOLEAN DEFAULT TRUE
);