#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/populate_airing_tables.$now.log
# Load master config
source $basedir/config

sourcedbusername=$warehousedbusername
sourcedbpassword=$warehousedbpassword
sourcedbhost=$warehousedbhost
sourcedbname=$warehouseairingsdbname

# $1 / $2 -> update the prod table (boolean true/false defaults to false) or numdays (valid values integer only) to update
if [ -n $1 -a "$1" -eq "$1" ]; then # if first param is an integer
  numdays=$1
  if [ "$2" = true ]; then # check for second param as boolean
    tblsuffix=
  fi
elif [ -n $2 -a "$2" -eq "$2" ]; then # if second param is an integer
  numdays=$2
  if [ "$1" = true ]; then # check for first param as boolean
    tblsuffix=
  fi
elif [ "$1" = true ]; then # if only one param available
  tblsuffix=
fi
echo $tblsuffix $numdays
# Load this script config
source $basedir/populate_airing_config$tblsuffix
# Break the processing to monthly chunks
if [[ -z "$numdays" ]]; then
  # Define all the months variables to process
  startDates[0]=2016-01-01
  startDates[1]=2016-02-01
  startDates[2]=2016-03-01
  startDates[3]=2016-04-01
  startDates[4]=2016-05-01
  startDates[5]=2016-06-01
  startDates[6]=2016-07-01
  startDates[7]=2016-08-01
  startDates[8]=2016-09-01
  startDates[9]=2016-10-01
  startDates[10]=2016-11-01
  startDates[11]=2016-12-01
  startDates[12]=2017-01-01
  startDates[13]=2017-02-01
  startDates[14]=2017-03-01
  startDates[15]=2017-04-01
  startDates[16]=2017-05-01
  startDates[17]=2017-06-01
  startDates[18]=2017-07-01
else
  # Hack
  startDates[0]=$numdays
  startDates[1]=$numdays
fi
monthstoprocess=$((${#startDates[@]} - 1))

contentmetatblname=content_productl_brandg_category
sourcetblname=ad_airings_all
insightstblname=airings_master
if [ "$airings_master" = true ]; then
for (( i=0; i<$monthstoprocess; i++ ));
do
  startDate=${startDates[$i]}
  endDateIdx=$(($i + 1))
  endDate=${startDates[$endDateIdx]}
  $sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  if [[ -z "$numdays" ]]; then
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
  else
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
  fi
  echo $(date)
done
# $sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $contentmetatblname$tblsuffix
# echo $(date)
fi

sourcedbusername=$insightsdbusername
sourcedbpassword=$insightsdbpassword
sourcedbhost=$insightsdbhost
sourcedbname=$insightsdbname

mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getBroadcastX.sql
mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getCategoryAirings.sql
mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getDaypart.sql
mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getTVstationTZ.sql

sourcetblname=airings_master
insightstblname=airings_stage
if [ "$airings_master" = true ]; then
for (( i=0; i<$monthstoprocess; i++ ));
do
  startDate=${startDates[$i]}
  endDateIdx=$(($i + 1))
  endDate=${startDates[$endDateIdx]}
  $sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $contentmetatblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  if [[ -z "$numdays" ]]; then
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
  else
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
  fi
  echo $(date)
done
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
$sqlDir/$insightstblname"/localairings.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
echo $(date)
fi

sourcetblname=airings_stage
insightstblname=airings
if [ "$airings" = true ]; then
for (( i=0; i<$monthstoprocess; i++ ));
do
  startDate=${startDates[$i]}
  endDateIdx=$(($i + 1))
  endDate=${startDates[$endDateIdx]}
  $sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
  echo $(date)
  if [[ -z "$numdays" ]]; then
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
  else
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
  fi
  echo $(date)
done
# $sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
# echo $(date)
fi

for (( i=0; i<$monthstoprocess; i++ ));
do
startDate=${startDates[$i]}
endDateIdx=$(($i + 1))
endDate=${startDates[$endDateIdx]}

sourcetblname=airings
insightstblname=content_network_show_airings
if [ "$content_network_show_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=content_network_show_airings
insightstblname=content_network_airings
if [ "$content_network_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=content_network_airings
insightstblname=contentg_airings
if [ "$contentg_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=content_network_show_airings
insightstblname=product_network_show_airings
if [ "$product_network_show_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=product_network_show_airings
insightstblname=product_network_airings
if [ "$product_network_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=product_network_airings
insightstblname=category_airings
if [ "$category_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=product_network_show_airings
insightstblname=brand_network_show_airings
if [ "$brand_network_show_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

sourcetblname=brand_network_show_airings
insightstblname=brand_network_airings
if [ "$brand_network_airings" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi

done

sourcetblname=contentg_airings
insightstblname=content_list
if [ "$content_list" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $contentmetatblname$tblsuffix $startDate $endDate > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
if [[ -z "$numdays" ]]; then
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$startDate.$endDate.tsv
else
  mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
fi
echo $(date)
fi
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
echo $(date)

sourcetblname=content_list
insightstblname=brand_list
brandsmetatblname=brands
if [ "$brand_list" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $brandsmetatblname$tblsuffix > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
echo $(date)

sourcetblname=airings
insightstblname=coop_list
if [ "$coop_list" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix $numdays
echo $(date)