#!/bin/bash

export PATH=$PATH:/home/rtbkit/local/bin
export NODE_PATH=/home/rtbkit/node_modules

main_file_prefix=$1
airing_start_date=$2
airing_end_date=$3

dbhost='wh-db1.alphonso.tv'
dbusername='warehouseuser'
dbpassword='1973Warehouse1@'
dbschema='tv_airings'

#select the current data from db for a month
mysql -h $dbhost -u $dbusername -p$dbpassword $dbschema -e "select * from ad_airings_all where DATE(airing_time) between '$airing_start_date' and '$airing_end_date' order by airing_time asc ;" > ${main_file_prefix}.out

#select the cols for spend process
cat ${main_file_prefix}.out |cut -f 1-10,13 > ${main_file_prefix}.spend_input

#reprocess spend data
input_file="${main_file_prefix}.spend_input"

output_file=${main_file_prefix}.spend_output

month_code=`echo "$input_file" |cut -d '-' -f 2 | awk '{print tolower($0)} ' `
year_code=`echo "$input_file" |cut -d '-' -f 1 |cut -c3-4 `
def_config_file="/home/nikhils/prod/config.txt.mar-17"
config_file="/home/nikhils/prod/config.txt.${month_code}-${year_code}"
if [ ! -s $config_file ]
then
  echo "$config_file does not exist, using default"
  config_file=$def_config_file
fi

duration_file="/tmp/spend/duration_monthly.csv"
rm -rf ${duration_file}
#mysql -h wh-db1.alphonso.tv -u warehouseuser -p1973Warehouse1@ -D dashboard -e "SELECT id, duration FROM content_all INTO OUTFILE '${duration_file}' FIELDS TERMINATED by ',' ; "
mysql -h $dbhost -u $dbusername -p$dbpassword -D dashboard -e "SELECT id, duration FROM content_all ; " |sed 's/\t/,/' > ${duration_file}

spend_script=$4
if test -z "$spend_script"
then
  spend_script="spend-pipe.py"
fi

echo "running spend script - python3 /home/nikhils/prod/${spend_script} ${input_file} ${output_file} ${config_file} ${duration_file} "
python3 /home/nikhils/prod/${spend_script} ${input_file} ${output_file} ${config_file} ${duration_file}

#recreate the db load file with updated spend data
cat ${main_file_prefix}.out  | node merge_new_spend_val.js  ${output_file} > ${main_file_prefix}.updated
