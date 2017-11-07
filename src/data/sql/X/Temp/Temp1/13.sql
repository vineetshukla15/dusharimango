REPLACE INTO insights.content_airings
select a.content_id, a.content_title,a.content_duration, a.content_group_id, a.product_id, a.product_name, a.productline_id,
	   a.coop_product_id, p.product_name as coop_product_name,
       a.brand_id, a.brand_name, p.brand_id as coop_brand_id, p.brand_name as coop_brand_name,
       a.category_id, a.category_name, p.category_id as coop_category_id, p.categor_name as coop_category_name,
       a.airing_start_time_UTC, a.airing_time, a.daypart, a.pod_position, a.spend, a.tv_station_id, a.tv_station_tz, a.tv_network,
       a.show_title, a.show_genres, a.show_start_time_UTC, a.show_end_time_UTC, a.show_start_time, a.show_end_time
from
(select cam.content_id, (case when(c.content_display_title is null) then c.content_title else c.content_display_title end) as content_title,
	   (round(c.content_duration/15000) * 15) as content_duration, c.content_group_id,
       c.content_product_id as product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name, p.productline_id,
       c.content_coop_product_id as coop_product_id,
	   p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name,
       cam.airing_start_time_UTC, CONVERT_TZ(cam.airing_start_time_UTC, 'UTC', tv_station_tz) as airing_time,
       insights.getDayPart(CONVERT_TZ(cam.airing_start_time_UTC, 'UTC', tv_station_tz)) as daypart,
       cam.pod_position, cam.spend, cam.tv_station_id, cam.tv_station_tz, cam.tv_network, cam.show_title, cam.show_genres, cam.show_start_time_UTC, cam.show_end_time_UTC,
       CONVERT_TZ(cam.show_start_time_UTC, 'UTC', tv_station_tz) as show_start_time, CONVERT_TZ(cam.show_end_time_UTC, 'UTC', tv_station_tz) as show_end_time
FROM content_airings_master as cam, contents as c,
	 products as p, brands as b, categories as cat
where cam.content_id = c.content_id and
	  c.content_product_id = p.product_id and
      p.brand_id = b.brand_id and
      p.category_id = cat.category_id) as a #airings
left join
(select p.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name,
	   p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name
from 
     products as p, brands as b, categories as cat
where p.brand_id = b.brand_id and
      p.category_id = cat.category_id) as p #products
on a.content_coop_product_id = p.product_id;


#REPLACE INTO insights.content_product_brand_category
select cpbc.content_id, cpbc.content_title, cpbc.content_duration, cpbc.alphonso_owned, cpbc.content_group_id,
       cpbc.product_id, cpbc.product_name, cpbc.productline_id, cpbc.brand_id, cpbc.brand_name, cpbc.brand_group_id,
       cpbc.category_id, cpbc.category_name,
       cpbc.coop_product_id, coop.product_name as coop_product_name, coop.productline_id as coop_productline_id,
       coop.brand_id as coop_brand_id, coop.brand_name as coop_brand_name, coop.brand_group_id as coop_brand_group_id,
       coop.category_id as coop_category_id, coop.category_name as coop_category_name
from
(select c.content_id, (case when(c.content_display_title is null) then c.content_title else c.content_display_title end) as content_title,
	   (round(c.content_duration/15000) * 15) as content_duration, c.alphonso_owned, c.content_group_id,
       c.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name, p.productline_id,
	   p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name, b.brand_group_id,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name,
       c.coop_product_id
from contents as c
left join products as p on c.product_id = p.product_id
left join brands as b on p.brand_id = b.brand_id
left join categories as cat on p.category_id = cat.category_id) as cpbc # content product brand category
left join
(select p.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name, p.productline_id,
       p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name, b.brand_group_id,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name
from products as p
left join brands as b on p.brand_id = b.brand_id
left join categories as cat on p.category_id = cat.category_id) as coop # CoOp data
on cpbc.coop_product_id = coop.product_id;







REPLACE INTO insights.content_airings
select cam.content_id, c.content_title, c.content_duration, c.alphonso_owned, c.content_group_id, c.product_id as product_id, c.product_name, c.productline_id,
	   c.brand_id, c.brand_name, c.brand_group_id, c.category_id, c.category_name,
       cam.airing_start_time_UTC, CONVERT_TZ(cam.airing_start_time_UTC, 'UTC', tv_station_tz) as airing_time,
       insights.getDayPart(CONVERT_TZ(cam.airing_start_time_UTC, 'UTC', tv_station_tz)) as daypart,
       cam.pod_position, cam.spend, cam.tv_station_id, cam.tv_station_tz, cam.tv_network, cam.show_title, cam.show_genres, cam.show_start_time_UTC, cam.show_end_time_UTC,
       CONVERT_TZ(cam.show_start_time_UTC, 'UTC', tv_station_tz) as show_start_time, CONVERT_TZ(cam.show_end_time_UTC, 'UTC', tv_station_tz) as show_end_time,
       c.coop_product_id, c.coop_product_name, c.coop_productline_id, c.coop_brand_id, c.coop_brand_name, c.coop_brand_group_id, c.coop_category_id, c.coop_category_name 
FROM content_airings_master as cam
left join content_product_brand_category as c
on cam.content_id = c.content_id
where cam.airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL 5 DAY);