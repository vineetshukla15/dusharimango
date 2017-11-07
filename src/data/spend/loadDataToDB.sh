#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: program data_file database table"
    exit
fi


data_file=$1
database=$2
database_table=$3

dbhost='wh-db1.alphonso.tv'
dbusername='warehouseuser'
dbpassword='1973Warehouse1@'

basedir=$(dirname $(readlink -f "$0"))
data_file_base=$basedir/${data_file}

cp $data_file_base $basedir/${database_table}.tsv
echo "mysqlimport -h $dbhost -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 ${database} $basedir/${database_table}.tsv"
mysqlimport -h $dbhost -u $dbusername -p$dbpassword --replace --local --ignore-lines 1 ${database} $basedir/${database_table}.tsv
rm $basedir/${database_table}.tsv