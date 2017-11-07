#!/bin/bash -x

# http://dev.mysql.com/doc/refman/5.5/en/time-zone-support.html

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
airings_stage_tbl=$5
num_days=$6
startDate=$6
endDate=$7

subQuery=
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="WHERE airings_type = 1 AND airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $6 -a -n $7 ]; then
  subQuery="WHERE airings_type = 1 AND airing_start_time_UTC >= '$startDate' AND airing_start_time_UTC < '$endDate'"
elif  [ -n $6 ]; then
  subQuery="WHERE airings_type = 1 AND airing_start_time_UTC >= '$startDate'"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT content_id, content_title, content_duration, alphonso_owned, publish_status, content_group_id, product_id, product_name,
	     brand_id, brand_name, (CASE WHEN(category_id IS NULL)THEN 0 ELSE category_id END) AS category_id, category_name,
       airing_start_time_UTC, airing_time, daypart, daypart2, broadcast_year, broadcast_quarter, broadcast_month, broadcast_week,
       pod_position, spend, tv_station_id, tv_station_tz, tv_network, show_tmsid, show_title, show_genres,
       (CASE WHEN(coop_product_id IS NULL)THEN 0 ELSE coop_product_id END) AS coop_product_id, coop_product_name,
       (CASE WHEN(coop_brand_id IS NULL)THEN 0 ELSE coop_brand_id END) AS coop_brand_id, coop_brand_name,
       (CASE WHEN(coop_category_id IS NULL)THEN 0 ELSE coop_category_id END) AS coop_category_id, coop_category_name
FROM $airings_stage_tbl $subQuery;"