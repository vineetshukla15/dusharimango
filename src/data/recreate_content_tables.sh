#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/recreate_content_tables.$now.log
# Load other config
source $basedir/config

dbusername=$insightsdbusername
dbpassword=$insightsdbpassword
dbhost=$insightsdbhost
database=$insightsdbname

<<"COMMENT"
# $1 -> update the prod table (boolean true/false defaults to false)
if [ "$1" = true ]; then
  tblsuffix=
fi
echo $tblsuffix
COMMENT

tblname=brands
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=categories
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=products
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=contents
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

<<"COMMENT"
tblname=content_product_brand_category
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now
COMMENT

tblname=content_productl_brandg_category
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now
