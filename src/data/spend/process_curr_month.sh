#!/bin/bash

./dump_spend_data.sh 2017-Apr-airings-all 2017-04-01 2017-04-30
./loadDataToDB.sh 2017-Apr-airings-all.updated tv_airings ad_airings_all_tmp
