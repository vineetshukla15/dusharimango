#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT id AS brand_id, name AS brand_name FROM $tbl;"