#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
num_days=$6
startDate=$6
endDate=$7

subQuery=""
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="WHERE airing_time >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $6 -a -n $7 ]; then
  subQuery="WHERE airing_time >= '$startDate' AND airing_time < '$endDate'"
elif  [ -n $6 ]; then
  subQuery="WHERE airing_time >= '$startDate'"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT content_id, content_title, content_duration,sum(alphonso_owned) as alphonso_owned,
   sum(publish_status) as publish_status, content_group_id, product_id, product_name, brand_id, brand_name,
   (CASE WHEN(category_id IS NULL)THEN 0 ELSE category_id END) AS category_id, category_name,
   DATE(airing_time) as airing_date, daypart2, broadcast_year, broadcast_quarter, broadcast_month, broadcast_week,
   sum(spend) as spend, count(*) as airings, tv_network, show_title, show_genres,
   (CASE WHEN(coop_product_id IS NULL)THEN 0 ELSE coop_product_id END) AS coop_product_id, coop_product_name,
   (CASE WHEN(coop_brand_id IS NULL)THEN 0 ELSE coop_brand_id END) AS coop_brand_id, coop_brand_name,
   (CASE WHEN(coop_category_id IS NULL)THEN 0 ELSE coop_category_id END) AS coop_category_id, coop_category_name
FROM $tblname $subQuery
GROUP BY content_id, airing_date, daypart2, tv_network, show_title, show_genres;"