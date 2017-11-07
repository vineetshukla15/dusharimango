#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
num_days=$6
startDate=$6
endDate=$7

subQuery=
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="WHERE airing_time >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
elif  [ -n $6 -a -n $7 ]; then
  subQuery="WHERE airing_time >= '$startDate' AND airing_time < '$endDate'"
elif  [ -n $6 ]; then
  subQuery="WHERE airing_time >= '$startDate'"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT content_id, airing_time AS airing_start_time_UTC,
       (CASE WHEN(seq_no < 0)THEN 0 ELSE seq_no END) AS pod_position,
       ad_cost_est AS spend, stations_id AS tv_station_id, station_tz AS tv_station_tz,
       #(CASE WHEN(station_tz = 'NULL')THEN null ELSE station_tz END) as tv_station_tz,
       network AS tv_network, show_tmsid, show_name AS show_title, show_genre AS show_genres,
       TRUE AS national_airing
FROM $tbl $subQuery;"
# FROM $tbl $subQuery AND show_name NOT IN ('null', 'undefined', 'Paid Programming', 'SIGN OFF');"