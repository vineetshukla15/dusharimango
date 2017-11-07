#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
airings_tbl=$5
contents_meta_tbl=$6
num_days=$7
startDate=$7
endDate=$8

<<"COMMENT"
subQuery=
if [ -n $7 -a "$7" -eq "$7" ]; then
  subQuery="WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $7 -a -n $8 ]; then
  subQuery="WHERE airing_date >= '$startDate' AND airing_date < '$endDate'"
elif  [ -n $7 ]; then
  subQuery="WHERE airing_date >= '$startDate'"
fi
COMMENT

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT c.content_id, c.content_title, c.content_duration, c.alphonso_owned, c.publish_status,
       c.content_group_id, cga.airing_start, cga.airing_end, cga.airings, cga.spend,
       c.product_id, c.product_name, c.brand_id, c.brand_name, c.category_id, c.category_name,
       (CASE WHEN(c.coop_product_id is NULL)THEN 0 ELSE c.coop_product_id END) as coop_product_id, c.coop_product_name,
       (CASE WHEN(c.coop_brand_id is NULL)THEN 0 ELSE c.coop_brand_id END) as coop_brand_id, c.coop_brand_name,
       (CASE WHEN(c.coop_category_id is NULL)THEN 0 ELSE c.coop_category_id END) as coop_category_id, c.coop_category_name,
       TRUE AS is_transient
FROM 
#(SELECT DISTINCT content_group_id FROM $airings_tbl $subQuery) AS a,
(SELECT * FROM $contents_meta_tbl WHERE alphonso_owned > 0 AND publish_status > 0 AND category_id IS NOT NULL) AS c,
(SELECT content_group_id, MIN(airing_date) AS airing_start, MAX(airing_date) AS airing_end,
		SUM(airings) AS airings, SUM(spend) AS spend FROM $airings_tbl GROUP BY content_group_id) AS cga
WHERE
  #a.content_group_id = c.content_group_id AND
  c.content_group_id = cga.content_group_id;"