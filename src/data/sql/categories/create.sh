#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tblname=$5
now=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "CREATE TABLE $tblname
(
   category_id INT(10) UNSIGNED, PRIMARY KEY(category_id),
   category_name VARCHAR(120), INDEX(category_name),
   category_display_name VARCHAR(120), INDEX(category_display_name),
   parent_category_id INT(10) UNSIGNED, INDEX(parent_category_id) # FOREIGN KEY(parent_category_id) references categories(category_id)
);"