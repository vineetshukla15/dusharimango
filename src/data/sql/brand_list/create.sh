#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   brand_id INT(11) UNSIGNED, PRIMARY KEY(brand_id),
   brand_name VARCHAR(120), INDEX(brand_name),
   is_transient BOOLEAN DEFAULT TRUE
);"