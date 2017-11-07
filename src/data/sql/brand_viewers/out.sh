#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
num_days=$6

subQuery=""
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT brand_id, airing_date, daypart, lat, lng, sum(viewers) AS viewers,
       (CASE WHEN(coop_brand_id IS NULL)THEN 0 ELSE coop_brand_id END) AS coop_brand_id
FROM $tbl $subQuery
GROUP BY brand_id, airing_date, daypart, lat, lng, coop_brand_id;"