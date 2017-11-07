DROP TABLE IF EXISTS insights.content_airings_master;
CREATE TABLE insights.content_airings_master
(
   content_id int(11) unsigned, INDEX(content_id),# FOREIGN KEY(content_id) references insights.contents(content_id),
   airing_start_time_UTC datetime, INDEX(airing_start_time_UTC),
   pod_position int(10) unsigned,
   spend int(10) unsigned,
   tv_station_id int(10) unsigned, INDEX(tv_station_id),
   tv_station_tz varchar(100), INDEX(tv_station_tz),
   tv_network varchar(100), INDEX(tv_network),
   show_title varchar(100), INDEX(show_title),
   show_genres varchar(100),
   show_start_time_UTC datetime,
   show_end_time_UTC datetime,
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id)
);


DROP TABLE IF EXISTS insights.content_airings;#content_product_brand_category_station_network_show
CREATE TABLE insights.content_airings
(
   content_id int(11) unsigned, INDEX(content_id),
   content_title varchar(255), INDEX(content_title),
   content_duration int(10) unsigned,
   product_id int(11) unsigned, INDEX(product_id),
   product_name varchar(120), INDEX(product_name),
   brand_id int(11) unsigned, INDEX(brand_id),
   brand_name varchar(120), INDEX(brand_name),
   category_id int(10) unsigned, INDEX(category_id),
   category_name varchar(120), INDEX(category_name),
   airing_start_time_UTC datetime, INDEX(airing_start_time_UTC),
   airing_time datetime, INDEX(airing_time),
   daypart varchar(24), INDEX(daypart),
   pod_position int(10) unsigned,
   spend int(10) unsigned,
   tv_station_id int(10) unsigned, INDEX(tv_station_id),
   tv_station_tz varchar(100), INDEX(tv_station_tz),
   tv_network varchar(100), INDEX(tv_network),
   show_title varchar(100), INDEX(show_title),
   show_genres varchar(100),
   show_start_time_UTC datetime,
   show_end_time_UTC datetime,
   UNIQUE KEY(content_id, airing_start_time_UTC, tv_station_id)
);