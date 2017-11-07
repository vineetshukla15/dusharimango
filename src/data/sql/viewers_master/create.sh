#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   content_id INT(11) UNSIGNED, INDEX(content_id), # FOREIGN KEY(content_id) references insights.contents(content_id),
   airing_date DATE, INDEX(airing_date),
   daypart VARCHAR(24), INDEX(daypart),
   lat FLOAT(5,2), INDEX(lat),
   lng FLOAT(5,2), INDEX(lng),
   viewers INT(10) DEFAULT 0,
   UNIQUE KEY(content_id, airing_date, daypart, lat, lng)
);"