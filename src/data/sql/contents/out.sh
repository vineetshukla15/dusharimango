#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# hack on content_group_id as the export was putting 'NULL' in the tsv file
# the mysqlimport on warehouse db was automatically converting the 'NULL' to 0
# on insightsdb following error was thrown
# mysqlimport: Error: 1366, Incorrect integer value: 'NULL' for column 'content_group_id' at row 1, when using table: contents
# mysqlimport: Error: 1366, Incorrect integer value: 'NULL' for column 'content_duration' at row 25763, when using table: contents
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
SELECT id AS content_id, title AS content_title,
       (CASE WHEN(duration IS NULL)THEN 0 ELSE duration END) AS content_duration,
       (CASE WHEN(\`source\` = 'aclipper' OR \`source\` = 'amanual' OR \`source\` = 'sb2017clipper' OR \`source\` = 'sb2016clipper')THEN TRUE ELSE FALSE END) AS alphonso_owned,
       (CASE WHEN($tbl.status = 'published' OR $tbl.status = 'archived')THEN TRUE ELSE FALSE END) AS publish_status,
       product_id, #(CASE WHEN(coop_product_id IS NULL)THEN 0 ELSE coop_product_id END) AS coop_product_id,
       (CASE WHEN(\`group\` IS NULL)THEN id ELSE \`group\` END) AS content_group_id
FROM $tbl LEFT JOIN content_similar ON content.id = content_similar.content_id
WHERE content.product_id IS NOT NULL;"