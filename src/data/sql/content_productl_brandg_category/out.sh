#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblsuffix=$5

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT c.content_id, (CASE WHEN(c.content_display_title IS NULL) THEN c.content_title ELSE c.content_display_title END) AS content_title,
	   (ROUND(c.content_duration/15000) * 15) AS content_duration, c.alphonso_owned, c.publish_status, c.content_group_id,
       pl.product_id, (CASE WHEN(pl.product_display_name IS NULL) THEN pl.product_name ELSE pl.product_display_name END) AS product_name,
	   bg.brand_id, (CASE WHEN(bg.brand_display_name IS NULL) THEN bg.brand_name ELSE bg.brand_display_name END) AS brand_name,
       (CASE WHEN(cat.category_id is NULL)THEN 0 ELSE cat.category_id END) as category_id,
       (CASE WHEN(cat.category_display_name IS NULL) THEN cat.category_name ELSE cat.category_display_name END) AS category_name,
       (CASE WHEN(cooppl.product_id is NULL)THEN 0 ELSE cooppl.product_id END) as coop_product_id,
       (CASE WHEN(cooppl.product_display_name IS NULL) THEN cooppl.product_name ELSE cooppl.product_display_name END) AS coop_product_name,
       (CASE WHEN(coopbg.brand_id is NULL)THEN 0 ELSE coopbg.brand_id END) as coop_brand_id,
       (CASE WHEN(coopbg.brand_display_name IS NULL) THEN coopbg.brand_name ELSE coopbg.brand_display_name END) AS coop_brand_name,
       (CASE WHEN(coopcat.category_id is NULL)THEN 0 ELSE coopcat.category_id END) as coop_category_id,
       (CASE WHEN(coopcat.category_display_name IS NULL) THEN coopcat.category_name ELSE coopcat.category_display_name END) AS coop_category_name
FROM contents$tblsuffix AS c
#LEFT JOIN contents$tblsuffix AS cg ON c.content_group_id = cg.content_id
LEFT JOIN products$tblsuffix AS p ON c.product_id = p.product_id
LEFT JOIN products$tblsuffix AS pl ON p.productline_id = pl.product_id
LEFT JOIN brands$tblsuffix AS b ON pl.brand_id = b.brand_id
LEFT JOIN brands$tblsuffix AS bg on b.brand_group_id = bg.brand_id
LEFT JOIN categories$tblsuffix AS cat ON pl.category_id = cat.category_id
LEFT JOIN products$tblsuffix AS coopp ON c.coop_product_id = coopp.product_id
LEFT JOIN products$tblsuffix AS cooppl ON coopp.productline_id = cooppl.product_id
LEFT JOIN brands$tblsuffix AS coopb ON cooppl.brand_id = coopb.brand_id
LEFT JOIN brands$tblsuffix AS coopbg on coopb.brand_group_id = coopbg.brand_id
LEFT JOIN categories$tblsuffix AS coopcat ON cooppl.category_id = coopcat.category_id;"