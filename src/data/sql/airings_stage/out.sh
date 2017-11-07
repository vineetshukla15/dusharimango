#!/bin/bash -x

# http://dev.mysql.com/doc/refman/5.5/en/time-zone-support.html

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
airings_master_tbl=$5
contents_meta_tbl=$6
num_days=$7
startDate=$7
endDate=$8

subQuery=
if [ -n $7 -a "$7" -eq "$7" ]; then
  subQuery="WHERE am.airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $7 -a -n $8 ]; then
  subQuery="WHERE am.airing_start_time_UTC >= '$startDate' AND am.airing_start_time_UTC < '$endDate'"
elif  [ -n $7 ]; then
  subQuery="WHERE am.airing_start_time_UTC >= '$startDate'"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT am.content_id, cpbc.content_title, cpbc.content_duration, cpbc.alphonso_owned,  cpbc.publish_status,
	     cpbc.content_group_id,# cpbc.content_group_title,
       cpbc.product_id, cpbc.product_name,# cpbc.productline_id, cpbc.productline_name,
	     cpbc.brand_id, cpbc.brand_name,# cpbc.brand_group_id, cpbc.brand_group_name,
       (CASE WHEN(cpbc.category_id IS NULL)THEN 0 ELSE cpbc.category_id END) AS category_id, cpbc.category_name,
       am.airing_start_time_UTC, CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVStationTZ(am.tv_station_id)) AS airing_time,
       getDaypart(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVStationTZ(am.tv_station_id)), FALSE) AS daypart,
       getDaypart(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVStationTZ(am.tv_station_id)), TRUE) AS daypart2,
       getBroadcastYear(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVStationTZ(am.tv_station_id))) AS broadcast_year,
       getBroadcastQuarter(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVstationTZ(am.tv_station_id))) AS broadcast_quarter,
       getBroadcastMonth(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVstationTZ(am.tv_station_id))) AS broadcast_month,
       getBroadcastWeek(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTVstationTZ(am.tv_station_id))) AS broadcast_week,
       am.pod_position, am.spend, am.tv_station_id, getTVstationTZ(am.tv_station_id) AS tv_station_tz, am.tv_network,# am.tv_station_tz is ignored
       am.show_tmsid, am.show_title, am.show_genres,# am.show_start_time_UTC, am.show_end_time_UTC,
       #CONVERT_TZ(am.show_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id)) as show_start_time,
       #CONVERT_TZ(am.show_end_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id)) as show_end_time,
       (CASE WHEN(cpbc.coop_product_id IS NULL)THEN 0 ELSE cpbc.coop_product_id END) AS coop_product_id, cpbc.coop_product_name,# cpbc.coop_productline_id, cpbc.coop_productline_name,
       (CASE WHEN(cpbc.coop_brand_id IS NULL)THEN 0 ELSE cpbc.coop_brand_id END) AS coop_brand_id, cpbc.coop_brand_name,# cpbc.coop_brand_group_id, cpbc.coop_brand_group_name,
       (CASE WHEN(cpbc.coop_category_id IS NULL)THEN 0 ELSE cpbc.coop_category_id END) AS coop_category_id, cpbc.coop_category_name, am.national_airing as airing_type
FROM $airings_master_tbl AS am
LEFT JOIN $contents_meta_tbl AS cpbc
ON am.content_id = cpbc.content_id $subQuery;"