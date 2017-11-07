#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_group_id INT(11) UNSIGNED, INDEX(content_group_id),
   airing_date DATE, INDEX(airing_date),
   spend INT(11) UNSIGNED DEFAULT 0,
   airings INT(11) UNSIGNED DEFAULT 0,
   UNIQUE KEY(content_group_id, airing_date)
);"