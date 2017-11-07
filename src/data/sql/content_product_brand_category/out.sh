#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblsuffix=$5

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT cpbc.content_id, cpbc.content_title, cpbc.content_duration, cpbc.alphonso_owned, cpbc.publish_status,
       cpbc.content_group_id, (CASE WHEN(c.content_display_title IS NULL) THEN c.content_title ELSE c.content_display_title END) AS content_group_title,
       cpbc.product_id, cpbc.product_name, cpbc.productline_id, (CASE WHEN(p.product_display_name IS NULL) THEN p.product_name ELSE p.product_display_name END) AS productline_name,
       cpbc.brand_id, cpbc.brand_name, cpbc.brand_group_id, (CASE WHEN(b.brand_display_name IS NULL) THEN b.brand_name ELSE b.brand_display_name END) AS brand_group_name,
       (CASE WHEN(cpbc.category_id is NULL)THEN 0 ELSE cpbc.category_id END) AS category_id, cpbc.category_name,
       (CASE WHEN(cpbc.coop_product_id is NULL)THEN 0 ELSE cpbc.coop_product_id END) as coop_product_id,
       coop.product_name AS coop_product_name,
       (CASE WHEN(coop.productline_id is NULL)THEN 0 ELSE coop.productline_id END) AS coop_productline_id,
       (CASE WHEN(coopp.product_display_name IS NULL) THEN coopp.product_name ELSE coopp.product_display_name END) AS coop_productline_name,
       (CASE WHEN(coop.brand_id is NULL)THEN 0 ELSE coop.brand_id END) AS coop_brand_id, coop.brand_name AS coop_brand_name,
       (CASE WHEN(coop.brand_group_id is NULL)THEN 0 ELSE coop.brand_group_id END) AS coop_brand_group_id,
       (CASE WHEN(coopb.brand_display_name IS NULL) THEN coopb.brand_name ELSE coopb.brand_display_name END) AS coop_brand_group_name,
       (CASE WHEN(coop.category_id is NULL)THEN 0 ELSE coop.category_id END) AS coop_category_id, coop.category_name AS coop_category_name
FROM
(SELECT c.content_id, (CASE WHEN(c.content_display_title IS NULL) THEN c.content_title ELSE c.content_display_title END) AS content_title,
	   (ROUND(c.content_duration/5000) * 5) AS content_duration, c.alphonso_owned, c.publish_status, c.content_group_id,
       c.product_id, (CASE WHEN(p.product_display_name IS NULL) THEN p.product_name ELSE p.product_display_name END) AS product_name, p.productline_id,
	   p.brand_id, (CASE WHEN(b.brand_display_name IS NULL) THEN b.brand_name ELSE b.brand_display_name END) AS brand_name, b.brand_group_id,
       p.category_id, (CASE WHEN(cat.category_display_name IS NULL) THEN cat.category_name ELSE cat.category_display_name END) AS category_name,
       c.coop_product_id
FROM contents$tblsuffix AS c
LEFT JOIN products$tblsuffix AS p ON c.product_id = p.product_id
LEFT JOIN brands$tblsuffix AS b ON p.brand_id = b.brand_id
LEFT JOIN categories$tblsuffix AS cat ON p.category_id = cat.category_id) AS cpbc # content product brand category
LEFT JOIN
(SELECT p.product_id, (CASE WHEN(p.product_display_name IS NULL) THEN p.product_name ELSE p.product_display_name END) AS product_name, p.productline_id,
       p.brand_id, (CASE WHEN(b.brand_display_name IS NULL) THEN b.brand_name ELSE b.brand_display_name END) AS brand_name, b.brand_group_id,
       p.category_id, (CASE WHEN(cat.category_display_name IS NULL) THEN cat.category_name ELSE cat.category_display_name END) AS category_name
FROM products$tblsuffix AS p
LEFT JOIN brands$tblsuffix AS b ON p.brand_id = b.brand_id
LEFT JOIN categories$tblsuffix AS cat ON p.category_id = cat.category_id) AS coop # CoOp data
ON cpbc.coop_product_id = coop.product_id
LEFT JOIN contents$tblsuffix AS c ON cpbc.content_group_id = c.content_id
LEFT JOIN products$tblsuffix AS p ON cpbc.productline_id = p.product_id
LEFT JOIN brands$tblsuffix AS b ON cpbc.brand_group_id = b.brand_id
LEFT JOIN products$tblsuffix AS coopp ON coop.productline_id = coopp.product_id
LEFT JOIN brands$tblsuffix AS coopb ON coop.brand_group_id = coopb.brand_id;"