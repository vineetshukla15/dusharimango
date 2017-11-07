#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
airings_tbl=$5

# List of curated brands
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT DISTINCT brand_id, brand_name, coop_brand_id, coop_brand_name, TRUE AS is_transient 
FROM $airings_tbl
WHERE coop_brand_id IS NOT NULL;"