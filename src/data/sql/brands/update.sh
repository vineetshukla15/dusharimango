#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# Apple
#SELECT * FROM insights.brands where brand_id in (3396, 18966, 18549, 10922, 10874, 15614, 12869, 11089, 6217, 10503, 7629, 15811, 204872);
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
UPDATE $tbl SET brand_group_id = 3396 WHERE brand_id IN (10503);

# Samsung Galaxy, Samsung Mobile, Samsung Smart TV, Samsung Home Appliances, Samsung S4, Samsung Electronics, SAMSUNG - GALAXY S6, SAMSUNG - GALAXY S6 EDGE PHONES
UPDATE $tbl SET brand_group_id = 2618 WHERE brand_id IN (303700, 1468, 7010, 8230, 7089, 8522, 10688, 12275);"

# AT&T
#SELECT * FROM insights.brands where brand_id in (317, 10364, 32251, 70234);

# T-Mobile
#SELECT * FROM insights.brands where brand_id in (248);

# Verizon
#SELECT * FROM insights.brands where brand_id in (300, 46269);

# Sprint
#SELECT * FROM insights.brands where brand_id in (878, 8325, 87484, 88544, 88579);