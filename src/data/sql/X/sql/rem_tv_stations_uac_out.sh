#!/bin/bash -x

dbusername=$1
dbpassword=$2
database=$3
tblname=$4

mysql -u $dbusername -p$dbpassword $database -e "SELECT id,
                                                        tms_stn_id,
                                                        rovi_svc_id,
                                                        rovi_src_id,
                                                        tms_chn_name,
                                                        rovi_chn_name,
                                                        network_name
                                                FROM $tblname;"
