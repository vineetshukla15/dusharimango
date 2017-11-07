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
SELECT content_group_id, airing_date,  sum(spend) as spend, sum(airings) as airings
FROM $tbl
$subQuery
GROUP BY content_group_id, airing_date;"