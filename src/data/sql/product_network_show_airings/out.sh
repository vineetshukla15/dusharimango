#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
num_days=$6
startDate=$6
endDate=$7

subQuery=""
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $6 -a -n $7 ]; then
  subQuery="WHERE airing_date >= '$startDate' AND airing_date < '$endDate'"
elif  [ -n $6 ]; then
  subQuery="WHERE airing_date >= '$startDate'"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT product_id, product_name, brand_id, brand_name,
   (CASE WHEN(category_id IS NULL)THEN 0 ELSE category_id END) AS category_id, category_name,
   airing_date, daypart, broadcast_year, broadcast_quarter, broadcast_month, broadcast_week,
   sum(spend) as spend, sum(airings) as airings, tv_network, show_title, show_genres,
   (CASE WHEN(coop_product_id IS NULL)THEN 0 ELSE coop_product_id END) AS coop_product_id, coop_product_name,
   (CASE WHEN(coop_brand_id IS NULL)THEN 0 ELSE coop_brand_id END) AS coop_brand_id, coop_brand_name,
   (CASE WHEN(coop_category_id IS NULL)THEN 0 ELSE coop_category_id END) AS coop_category_id, coop_category_name
FROM $tbl $subQuery
GROUP BY product_id, airing_date, daypart, tv_network, show_title, show_genres, coop_product_id;"