#DROP TABLE IF EXISTS categories;
CREATE TABLE categories
(
   category_id INT(10) UNSIGNED, PRIMARY KEY(category_id),
   category_name VARCHAR(120), INDEX(category_name),
   category_display_name VARCHAR(120), INDEX(category_display_name),
   parent_category_id INT(10) UNSIGNED, INDEX(parent_category_id ) # FOREIGN KEY(parent_category_id) references categories(category_id)
);