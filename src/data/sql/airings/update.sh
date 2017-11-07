#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
num_days=$6

subQuery=
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="AND airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
fi

# Update the Cartoon -> Adult Swim and Nickelodeon -> nick@nite for airing time 9:00pm - 6:00am
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT tv_network, tv_station_tz, COUNT(*) AS num_airings,
(CASE WHEN(HOUR(airing_time) >= 21 OR HOUR(airing_time) < 6)THEN '9:00pm-6:00am' ELSE '6:00am-9:00pm' END) AS broadcast_hour
FROM $tbl
WHERE tv_network IN ('Adult Swim', 'Cartoon', 'nick@nite', 'Nickelodeon') $subQuery
GROUP BY tv_network, tv_station_tz, broadcast_hour;

UPDATE $tbl SET tv_network = 'Adult Swim'
WHERE tv_network ='Cartoon' AND (HOUR(airing_time) >= 21 OR HOUR(airing_time) < 6) $subQuery;

UPDATE $tbl SET tv_network = 'nick@nite'
WHERE tv_network ='Nickelodeon' AND (HOUR(airing_time) >= 21 OR HOUR(airing_time) < 7) $subQuery;

SELECT tv_network, tv_station_tz, COUNT(*) AS num_airings,
(CASE WHEN(HOUR(airing_time) >= 21 OR HOUR(airing_time) < 6)THEN '9:00pm-6:00am' ELSE '6:00am-9:00pm' END) AS broadcast_hour
FROM $tbl
WHERE tv_network IN ('Adult Swim', 'Cartoon', 'nick@nite', 'Nickelodeon') $subQuery
GROUP BY tv_network, tv_station_tz, broadcast_hour;"