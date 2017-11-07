#!/bin/bash -x

basedir=/home/warehouseuser/dashboard-reports
now=$(date +"%Y%m%d%H%M%S")

tblsuffix=""
if [ -n "$1" ]; then
  tblsuffix="_$1"
fi

# Log file
LOG_FILE="$basedir/logs/append_delta_to_airing_agg"$tblsuffix"_tables.$now.log"

# Close STDOUT file descriptor
exec 1<&-
# Close STDERR FD
exec 2<&-

# Open STDOUT as $LOG_FILE file for read and write.
exec 1<>$LOG_FILE

# Redirect STDERR to STDOUT
exec 2>&1
echo $(date)

sqlDir=$basedir/sql
dumpDir=$basedir/dump

dbusername=warehouseuser
dbpassword=1973Warehouse1@
updatenumdays=5

database=dashboard
tblname=content_brand_network_show$tblsuffix
parentdatabase=tv_airings
parenttblname=ad_airings_all
$sqlDir/content_brand_network_show_out.sh $dbusername $dbpassword $parentdatabase $parenttblname $updatenumdays > $dumpDir/$tblname.tsv
echo $(date)
mysqlimport -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 $database $dumpDir/$tblname.tsv
echo $(date)
mv $dumpDir/$tblname.tsv $dumpDir/$tblname.$now.tsv
echo $(date)

tblname=content_brand_network$tblsuffix
parentdatabase=dashboard
parenttblname=content_brand_network_show$tblsuffix
$sqlDir/content_brand_network_out.sh $dbusername $dbpassword $parentdatabase $parenttblname $updatenumdays > $dumpDir/$tblname.tsv
echo $(date)
mysqlimport -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 $database $dumpDir/$tblname.tsv
echo $(date)
mv $dumpDir/$tblname.tsv $dumpDir/$tblname.$now.tsv
echo $(date)

tblname=brand_network_show$tblsuffix
parenttblname=content_brand_network_show$tblsuffix
$sqlDir/brand_network_show_out.sh $dbusername $dbpassword $parentdatabase $parenttblname $updatenumdays > $dumpDir/$tblname.tsv
echo $(date)
mysqlimport -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 $database $dumpDir/$tblname.tsv
echo $(date)
mv $dumpDir/$tblname.tsv $dumpDir/$tblname.$now.tsv
echo $(date)

tblname=brand_network$tblsuffix
parenttblname=brand_network_show$tblsuffix
$sqlDir/brand_network_out.sh $dbusername $dbpassword $parentdatabase $parenttblname $updatenumdays > $dumpDir/$tblname.tsv
echo $(date)
mysqlimport -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 $database $dumpDir/$tblname.tsv
echo $(date)
mv $dumpDir/$tblname.tsv $dumpDir/$tblname.$now.tsv
echo $(date)
