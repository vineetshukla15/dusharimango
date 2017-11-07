
drop table if exists tv_stations_uac;
CREATE TABLE tv_stations_uac (
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
  INDEX rovi_stn_id (rovi_svc_id, rovi_src_id));

-- drop table dashboard.content_brand_viewer;
-- CREATE TABLE dashboard.content_brand_viewer (
--   content_id INT(11),
--   content_title VARCHAR(100),
--   brand VARCHAR(100),
--   lat FLOAT(5,2),
--   lng FLOAT(5,2),
--   airing_date DATE,
--   viewers INT(11) DEFAULT 0,
--   PRIMARY KEY (content_id, brand, lat, lng, airing_date),
--   INDEX content_idx (content_id),
--   INDEX brand_idx (brand),
--   INDEX airing_date_idx (airing_date)
-- );
-- 
-- drop table dashboard.brand_viewer;
-- CREATE TABLE dashboard.brand_viewer (
--   brand VARCHAR(100),
--   lat FLOAT(5,2),
--   lng FLOAT(5,2),
--   airing_date DATE,
--   viewers INT(10) DEFAULT 0,
--   PRIMARY KEY (brand, lat, lng, airing_date),
--   INDEX brand_idx (brand),
--   INDEX airing_date_idx (airing_date)
-- );