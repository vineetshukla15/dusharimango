#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/populate_viewer_tables.$now.log
# Load master config
source $basedir/config

sourcedbusername=$warehousedbusername
sourcedbpassword=$warehousedbpassword
sourcedbhost=$warehousedbhost
sourcedbname=$warehouseviewersdbname

#mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getDaypart.sql
#mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getTZString.sql

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
source $basedir/populate_viewer_config$tblsuffix

insightstblname=viewers_master
# Define all the months variables to process
sourcetblnames[0]=2016_jan_sling_data_all
toprocess[0]=$jan_2016_sling_data_all
sourcetblnames[1]=2016_feb_sling_data_all
toprocess[1]=$feb_2016_sling_data_all
sourcetblnames[2]=2016_mar_sling_data_all
toprocess[2]=$mar_2016_sling_data_all
sourcetblnames[3]=2016_apr_sling_data_all
toprocess[3]=$apr_2016_sling_data_all
sourcetblnames[4]=2016_may_sling_data_all
toprocess[4]=$may_2016_sling_data_all
sourcetblnames[5]=2016_jun_sling_data_all
toprocess[5]=$jun_2016_sling_data_all
sourcetblnames[6]=2016_jul_sling_data_all
toprocess[6]=$jul_2016_sling_data_all
sourcetblnames[7]=2016_aug_sling_data_all
toprocess[7]=$aug_2016_sling_data_all
sourcetblnames[8]=2016_sep_sling_data_all
toprocess[8]=$sep_2016_sling_data_all
sourcetblnames[9]=2016_oct_sling_data_all
toprocess[9]=$oct_2016_sling_data_all
sourcetblnames[10]=2016_nov_sling_data_all
toprocess[10]=$nov_2016_sling_data_all
sourcetblnames[11]=2016_dec_sling_data_all
toprocess[11]=$dec_2016_sling_data_all
sourcetblnames[12]=2017_jan_sling_data_all
toprocess[12]=$jan_2017_sling_data_all
sourcetblnames[13]=2017_feb_sling_data_all
toprocess[13]=$feb_2017_sling_data_all
sourcetblnames[14]=2017_mar_sling_data_all
toprocess[14]=$mar_2017_sling_data_all
sourcetblnames[15]=2017_apr_sling_data_all
toprocess[15]=$apr_2017_sling_data_all
sourcetblnames[16]=2017_may_sling_data_all
toprocess[16]=$may_2017_sling_data_all
sourcetblnames[17]=2017_jun_sling_data_all
toprocess[17]=$jun_2017_sling_data_all

# get length of an array
monthstoprocess=$((${#sourcetblnames[@]} - 1))
i=0 #initalize
if [[ -n "$numdays" ]]; then
  i=$monthstoprocess
fi
echo $monthstoprocess $i
for (( ; i<=$monthstoprocess; i++ ));
do
  sourcetblname=${sourcetblnames[$i]}
  dumpFile=$dumpDir/$sourcetblname.tsv
  processFlag=${toprocess[$i]}
  if [ "$processFlag" = true ]; then
    echo $(date)
    if [ ! -s $dumpFile -o $i -eq $monthstoprocess ]; then
      $sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname $numdays > $dumpDir/$insightstblname$tblsuffix.tsv
    else
      mv $dumpFile $dumpDir/$insightstblname$tblsuffix.tsv
    fi
    echo $(date)
    mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
    echo $(date)
    mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpFile
    echo $(date)
  fi
done

sourcedbusername=$insightsdbusername
sourcedbpassword=$insightsdbpassword
sourcedbhost=$insightsdbhost
sourcedbname=$insightsdbname

mysql -u $sourcedbusername -p$sourcedbpassword --host=$sourcedbhost $sourcedbname < $sqlDir/function_def/getBroadcastX.sql

sourcetblname=viewers_master
contentmetatblname=content_productl_brandg_category
insightstblname=content_viewers
if [ "$content_viewers" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $contentmetatblname$tblsuffix $numdays > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi

sourcetblname=content_viewers
insightstblname=brand_viewers
if [ "$brand_viewers" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname$tblsuffix $numdays > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi