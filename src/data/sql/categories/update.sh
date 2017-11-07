#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# Government & Non-profits
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
UPDATE $tbl SET category_display_name = 'Government & Non profits' WHERE category_id = 8;"