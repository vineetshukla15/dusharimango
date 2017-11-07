#!/bin/bash -x

dbusername=$1
dbpassword=$2
database=$3
tblname=$4

mysql -u $dbusername -p$dbpassword $database -e "CREATE TABLE tv_stations_uac (
  id int(10) unsigned, PRIMARY KEY (id),
  tms_stn_id varchar(16),
  rovi_svc_id varchar(16),
  rovi_src_id int(10) unsigned,
  tms_chn_name varchar(45),
  rovi_chn_name varchar(45),
  network_name varchar(45),
  UNIQUE KEY tms_rovi (tms_stn_id, rovi_svc_id, rovi_src_id),
  INDEX tms_chn_idx (tms_chn_name),
  INDEX rovi_chn_idx (rovi_chn_name),
  INDEX network_idx (network_name),
  INDEX tms_stn_id (tms_stn_id),
  INDEX rovi_stn_id (rovi_svc_id, rovi_src_id)
); "
