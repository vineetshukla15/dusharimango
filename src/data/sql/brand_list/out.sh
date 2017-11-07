#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
content_list_tbl=$5
brands_meta_tbl=$6

# List of curated brands
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT DISTINCT cl.brand_id,
                (CASE WHEN(b.brand_display_name IS NULL) THEN b.brand_name ELSE b.brand_display_name END) AS brand_name,
                TRUE AS is_transient 
FROM $content_list_tbl AS cl,
$brands_meta_tbl AS b
WHERE cl.brand_id = b.brand_id;"