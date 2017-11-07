REPLACE INTO insights.airings
-- select content_id, content_title, content_duration, alphonso_owned, content_group_id, content_group_title,
-- 	   product_id, product_name, productline_id, productline_name, brand_id, brand_name, brand_group_id, brand_group_name,
--        category_id, category_name, airing_start_time_UTC, airing_time, insights.getDayPart(airing_time) as daypart,
--        insights.getBroadCastYear(airing_time) as broadcast_year, insights.getBroadCastQuarter(airing_time) as broadcast_quarter,
--        insights.getBroadCastMonth(airing_time) as broadcast_month, insights.getBroadCastWeek(airing_time) as broadcast_week,
--        pod_position, spend, tv_station_id, tv_station_tz, tv_network, show_title, show_genres, show_start_time_UTC, show_end_time_UTC,
--        #CONVERT_TZ(am.show_start_time_UTC, 'UTC', tv_station_tz) as show_start_time, CONVERT_TZ(am.show_end_time_UTC, 'UTC', tv_station_tz) as show_end_time,
--        '0000-00-00 00:00:00' as show_start_time, '0000-00-00 00:00:00' as show_end_time,
--        coop_product_id, coop_product_name, coop_productline_id, coop_productline_name, coop_brand_id, coop_brand_name, coop_brand_group_id, coop_brand_group_name, coop_category_id, coop_category_name       
-- from
-- (
select am.content_id, cpbc.content_title, cpbc.content_duration, cpbc.alphonso_owned, cpbc.content_group_id, cpbc.content_group_title,
	   cpbc.product_id as product_id, cpbc.product_name, cpbc.productline_id, cpbc.productline_name,
	   cpbc.brand_id, cpbc.brand_name, cpbc.brand_group_id, cpbc.brand_group_name, cpbc.category_id, cpbc.category_name,
       am.airing_start_time_UTC, CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id)) as airing_time,
       insights.getDayPart(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id))) as daypart,
       insights.getBroadCastYear(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id))) as broadcast_year,
       insights.getBroadCastQuarter(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id))) as broadcast_quarter,
       insights.getBroadCastMonth(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id))) as broadcast_month,
       insights.getBroadCastWeek(CONVERT_TZ(am.airing_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id))) as broadcast_week,
       am.pod_position, am.spend, am.tv_station_id, getTvStationTZ(am.tv_station_id) as tv_station_tz, am.tv_network,# am.tv_station_tz is ignored
       am.show_title, am.show_genres, am.show_start_time_UTC, am.show_end_time_UTC,
       CONVERT_TZ(am.show_start_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id)) as show_start_time,
       CONVERT_TZ(am.show_end_time_UTC, 'UTC', getTvStationTZ(am.tv_station_id)) as show_end_time,
       cpbc.coop_product_id, cpbc.coop_product_name, cpbc.coop_productline_id, cpbc.coop_productline_name,
       cpbc.coop_brand_id, cpbc.coop_brand_name, cpbc.coop_brand_group_id, cpbc.coop_brand_group_name, cpbc.coop_category_id, cpbc.coop_category_name 
FROM airings_master as am
left join content_product_brand_category as cpbc
on am.content_id = cpbc.content_id
#where am.airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)
#) as airings
;