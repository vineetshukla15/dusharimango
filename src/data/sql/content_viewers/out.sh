#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
viewers_master_tbl=$5
contents_meta_tbl=$6
num_days=$7

subQuery=
if [ -n $7 -a "$7" -eq "$7" ]; then
  subQuery="WHERE vm.airing_date >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
fi

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT vm.content_id, cpbc.content_duration, cpbc.content_group_id, cpbc.product_id, cpbc.brand_id,
       (CASE WHEN(cpbc.category_id IS NULL)THEN 0 ELSE cpbc.category_id END) AS category_id,
       vm.airing_date, vm.daypart, vm.lat, vm.lng, sum(viewers) as viewers,
       (CASE WHEN(cpbc.coop_product_id IS NULL)THEN 0 ELSE cpbc.coop_product_id END) AS coop_product_id,
       (CASE WHEN(cpbc.coop_brand_id IS NULL)THEN 0 ELSE cpbc.coop_brand_id END) AS coop_brand_id,
       (CASE WHEN(cpbc.coop_category_id IS NULL)THEN 0 ELSE cpbc.coop_category_id END) AS coop_category_id
FROM $viewers_master_tbl AS vm
LEFT JOIN $contents_meta_tbl AS cpbc
ON vm.content_id = cpbc.content_id $subQuery
GROUP BY content_id, content_duration, airing_date, daypart, lat, lng;"