#!/bin/bash -x

# http://dev.mysql.com/doc/refman/5.5/en/time-zone-support.html

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
num_days=$6

subQuery=
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="AND DATE(CONVERT_TZ(start_time_first, '+00:00', getTZString(user_tz))) >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT content_id,
       DATE(CONVERT_TZ(start_time_first, '+00:00', getTZString(user_tz))) AS airing_date,
       getDaypart(CONVERT_TZ(start_time_first, '+00:00', getTZString(user_tz)), TRUE) AS daypart,
       ROUND(loc_lat, 1) AS lat, ROUND(loc_long, 1) AS lng, COUNT(*) AS viewers
FROM $tblname
WHERE content_id > 0 AND loc_lat != 0.0 AND loc_long != 0.0 $subQuery
GROUP BY content_id, airing_date, daypart, lat, lng;"