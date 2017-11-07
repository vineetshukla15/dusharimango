REPLACE INTO insights.airings_master
select content_id, airing_time as airing_start_time_UTC,
	   (CASE WHEN(seq_no < 0)THEN 0 ELSE seq_no END) as pod_position,
       ad_cost_est as spend, stations_id as tv_station_id,
       (CASE WHEN(station_tz = 'NULL')THEN null ELSE station_tz END) as tv_station_tz,
       network as tv_network, show_name as show_title, show_genre as show_genres,
       '0000-00-00 00:00:00' as show_start_time_UTC, '0000-00-00 00:00:00' as show_end_time_UTC
FROM tv_airings.ad_airings_all
where airing_time >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)
;