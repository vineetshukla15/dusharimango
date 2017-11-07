#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# hack on category_id as the export was putting 'NULL' in the tsv file
# the mysqlimport on warehouse db was automatically converting the 'NULL' to 0
# on insightsdb following error was thrown
# mysqlimport: Error: 1366, Incorrect integer value: 'NULL' for column 'category_id' at row 9, when using table: product
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT id AS product_id, product AS product_name, brand_id,
       (CASE WHEN(category_id IS NULL)THEN 0 ELSE category_id END) AS category_id
FROM $tbl;"