#!/bin/bash -x

basedir=/home/warehouseuser/dashboard-reports
now=$(date +"%Y%m%d%H%M%S")

tblsuffix=""
if [ -n "$1" ]; then
  tblsuffix="_$1"
fi

# Log file
LOG_FILE="$basedir/logs/validate_airing_agg"$tblsuffix"_tables.$now.log"

# Close STDOUT file descriptor
exec 1<&-
# Close STDERR FD
exec 2<&-

# Open STDOUT as $LOG_FILE file for read and write.
exec 1<>$LOG_FILE

# Redirect STDERR to STDOUT
exec 2>&1

sqldir=$basedir/sql

dbusername=warehouseuser
dbpassword=1973Warehouse1@

database=tv_airings
tblname=ad_airings_all
mysql -u $dbusername -p$dbpassword $database -e "SELECT sum(ad_cost_est), count(*) FROM $tblname;"

database=dashboard
tblname=content_brand_network_show$tblsuffix
mysql -u $dbusername -p$dbpassword $database -e "SELECT sum(spend), sum(airings), count(*) FROM $tblname;"

tblname=content_brand_network$tblsuffix
mysql -u $dbusername -p$dbpassword $database -e "SELECT sum(spend), sum(airings), count(*) FROM $tblname;"

tblname=brand_network_show$tblsuffix
mysql -u $dbusername -p$dbpassword $database -e "SELECT sum(spend), sum(airings), count(*) FROM $tblname;"

tblname=brand_network$tblsuffix
mysql -u $dbusername -p$dbpassword $database -e "SELECT sum(spend), sum(airings), count(*) FROM $tblname;"
