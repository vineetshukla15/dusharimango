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
   airing_start_time_UTC DATETIME, INDEX(airing_start_time_UTC),
   pod_position INT(10),
   spend INT(10) UNSIGNED,
   tv_station_id INT(10) UNSIGNED, INDEX(tv_station_id),
   tv_station_tz VARCHAR(100), INDEX(tv_station_tz),
   tv_network VARCHAR(100), INDEX(tv_network),
   show_tmsid VARCHAR(100), INDEX(show_tmsid),
   show_title VARCHAR(100), INDEX(show_title),
   show_genres VARCHAR(100), INDEX(show_genres),
   #show_start_time_UTC datetime,
   #show_end_time_UTC datetime,
   national_airing BOOLEAN DEFAULT TRUE,
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id, tv_station_tz)
);"