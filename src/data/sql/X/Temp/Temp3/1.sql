DROP TABLE IF EXISTS insights.content_network_show;#content_product_brand_category_station_network_show
CREATE TABLE insights.content_network_show
(
   content_id int(10) unsigned, INDEX(content_id),# FOREIGN KEY(content_id) references insights.contents(content_id),
   content_title varchar(255), INDEX(content_title),
   content_duration int(10) unsigned,
   alphonso_owned boolean,
   content_group_id int(11) unsigned, INDEX(content_group_id),#content_group_id and content_duration should be used in combination to unique content groups
   #content_group_title varchar(255), INDEX(content_group_title),
   product_id int(11) unsigned, INDEX(product_id),
   product_name varchar(120), INDEX(product_name),
   productline_id int(11) unsigned, INDEX(productline_id),
   #productline_name varchar(120), INDEX(productline_name),
   brand_id int(11) unsigned, INDEX(brand_id),
   brand_name varchar(120), INDEX(brand_name),
   brand_group_id int(11) unsigned, INDEX(brand_group_id),
   #brand_group_name varchar(120), INDEX(brand_group_name),
   category_id int(10) unsigned DEFAULT NULL, INDEX(category_id),
   category_name varchar(120), INDEX(category_name),
   airing_date date, INDEX(airing_date),
   #daypart varchar(24), INDEX(daypart),
   airings int(10) unsigned,
   spend int(10) unsigned,
   tv_network varchar(100), INDEX(tv_network),
   show_title varchar(100), INDEX(show_title),
   show_genres varchar(100),
   coop_product_id int(11) unsigned, INDEX(coop_product_id),
   coop_product_name varchar(120), INDEX(coop_product_name),
   coop_productline_id int(11) unsigned, INDEX(coop_productline_id),
   #coop_productline_name varchar(120), INDEX(coop_productline_name),
   coop_brand_id int(11) unsigned, INDEX(coop_brand_id),
   coop_brand_name varchar(120), INDEX(coop_brand_name),
   coop_brand_group_id int(11) unsigned, INDEX(coop_brand_group_id),
   #coop_brand_group_name varchar(120), INDEX(coop_brand_group_name),
   coop_category_id int(10) unsigned DEFAULT NULL, INDEX(coop_category_id),
   coop_category_name varchar(120), INDEX(coop_category_name),
   UNIQUE KEY(content_id, airing_date, #daypart, 
			  tv_network, show_title, show_genres)
);

REPLACE INTO insights.content_network_show
select content_id, content_title, content_duration, alphonso_owned, content_group_id,
	   product_id, product_name, productline_id, brand_id, brand_name, brand_group_id, category_id, category_name,
       DATE(airing_time) as airing_date, #daypart, 
       count(*) as airings, sum(spend) as spend, tv_network, show_title, show_genres,
       coop_product_id, coop_product_name, coop_productline_id, coop_brand_id, coop_brand_name, coop_brand_group_id, coop_category_id, coop_category_name
from airings as a
-- left join
-- (select content_id as content_group_id, (case when(content_display_title is null) then content_title else content_display_title end) as content_group_title from contents) as c
-- on a.content_group_id = c.content_group_id
-- left join
-- (select product_id as productline_id, (case when(product_display_name is null) then product_name else product_display_name end) as productline_name from products) as p
-- on a.productline_id = p.productline_id
group by content_id, airing_date, #daypart, 
         tv_network, show_title, show_genres;
         
         
drop table if exists tv_airings.ad_airings_all_tmp;
CREATE TABLE tv_airings.ad_airings_all_tmp
(
   airing_time datetime, INDEX(airing_time),
   content_id int, INDEX(content_id),
   title varchar(100),
   brand varchar(100), INDEX(brand),
   brand_id int, INDEX(brand_id),
   stations_id int, INDEX(stations_id),
   network varchar(100), INDEX(network),
   show_name varchar(100), INDEX(show_name),
   show_genre varchar(100),
   show_tmsid varchar(100), INDEX(show_tmsid),
   ad_cost_est int,
   brand_cat_id int,
   brand_cat varchar(100),
   end_dt datetime,
   ad_block_id int,
   seq_no int,
   product_id int, 
   product varchar(100),
   content_duration int,
   ad_airing_start_time_STN datetime,
   station_tz varchar(100),
   station_tz_abbr varchar(100),
   station_tz_offset varchar(100),
   PRIMARY KEY (airing_time, content_id, brand_id, stations_id, network, show_name, show_tmsid)
);


SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01' and ad_cost_est <= 0;

select * from tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01' order by airing_time asc;

select * from tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01' order by airing_time desc;