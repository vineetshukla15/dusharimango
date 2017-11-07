#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/recreate_airing_tables.$now.log
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

tblname=airings_master
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=airings_stage
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=content_network_show_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=content_network_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=contentg_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=content_list
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=product_network_show_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=product_network_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=category_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=brand_network_show_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=brand_network_airings
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=brand_list
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now

tblname=coop_list
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "drop table if exists $tblname$tblsuffix;"
$sqlDir/$tblname"/create.sh" $dbusername $dbpassword $dbhost $database $tblname$tblsuffix $now