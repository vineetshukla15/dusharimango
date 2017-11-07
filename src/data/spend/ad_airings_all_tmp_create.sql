DROP TABLE IF EXISTS tv_airings.ad_airings_all_tmp;
CREATE TABLE tv_airings.ad_airings_all_tmp
(
   airing_time DATETIME, INDEX(airing_time),
   content_id INT, INDEX(content_id),
   title VARCHAR(100),
   brand VARCHAR(100), INDEX(brand),
   brand_id INT, INDEX(brand_id),
   stations_id INT, INDEX(stations_id),
   network VARCHAR(100), INDEX(network),
   show_name VARCHAR(100), INDEX(show_name),
   show_genre VARCHAR(100),
   show_tmsid VARCHAR(100), INDEX(show_tmsid),
   ad_cost_est INT,
   brand_cat_id INT,
   brand_cat VARCHAR(100),
   end_dt DATETIME,
   ad_block_id INT,
   seq_no INT,
   product_id INT, 
   product VARCHAR(100),
   content_duration INT,
   ad_airing_start_time_STN DATETIME,
   station_tz VARCHAR(100),
   station_tz_abbr VARCHAR(100),
   station_tz_offset VARCHAR(100),
   PRIMARY KEY (airing_time, content_id, brand_id, stations_id, network, show_name, show_tmsid)
);