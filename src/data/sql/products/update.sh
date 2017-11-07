#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# select brand_id, brand_name, sum(num_contents) as num_contents, sum(alphonso_owned) as alphonso_owned
# from(
# select b.brand_id, b.brand_name, p.product_id, product_name, num_contents, alphonso_owned
# from
# brands as b
# left join
# products as p
# on b.brand_id = p.brand_id
# left join
# (select product_id, count(*) as num_contents, sum(alphonso_owned) as alphonso_owned from contents group by product_id) as c
# on c.product_id = p.product_id
# where b.brand_id in (3396, 18966, 18549, 10922, 10874, 15614, 12869, 11089, 6217, 10503, 7629, 15811, 204872) # Apple
# -- where b.brand_id in (317, 10364, 32251, 70234) # AT&T
# -- where b.brand_id in (248) # T-Mobile
# -- where b.brand_id in (300, 46269) # Verizon
# -- where b.brand_id in (878, 8325, 87484, 88544, 88579) # Sprint
# order by brand_id, num_contents desc
# ) as x group by brand_id
# ;


# Apple productline:
#                   2796535 => iPhone
#                   2894394 => iPad Pro
#                   2804078 => Apple Watch
#                   2951808 => AirPods
#                   2801141 => Apple TV
#                   2816975 => Apple Music
#                   2767766 is tagged with content for Apple TV and iPhone each
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
UPDATE $tbl SET product_display_name = 'iPhone' WHERE product_id = 2796535;
UPDATE $tbl SET productline_id = 2796535 WHERE product_id IN (2786339, 2970103, 2968016, 2973701, 2951806);
UPDATE $tbl SET product_display_name = 'iPad Pro' WHERE product_id = 2894394;
UPDATE $tbl SET productline_id = 2804078 WHERE product_id IN (2951805, 2951804);
UPDATE $tbl SET productline_id = 2951808 WHERE product_id IN (2980299);

UPDATE $tbl SET product_display_name = 'Galaxy' WHERE product_id = 2940614;
UPDATE $tbl SET product_display_name = 'Galaxy S7' WHERE product_id = 2837591;
UPDATE $tbl SET product_display_name = 'Galaxy S7 Edge' WHERE product_id = 2796095;

UPDATE $tbl SET product_display_name = 'Moto Z Droid' WHERE product_id = 2893760;

UPDATE $tbl SET product_display_name = 'Pixel' WHERE product_id = 2993229;

INSERT INTO products_temp (product_id, product_name, brand_id, category_id)
				   VALUES (1922000001, 'LG Stylo 2', 1922, 5);

UPDATE $tbl SET product_display_name = 'Galaxy J3' WHERE product_id = 3057740;

INSERT INTO products_temp (product_id, product_name, brand_id, category_id)
				   VALUES (2596000001, 'Microsoft Word', 2596, 5);"