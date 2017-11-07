SELECT count(*) as n, content_id, brand_id FROM tv_airings.ad_airings_all where brand_id in (3396, 6217, 10503, 10874, 10922, 11089, 12869, 15614, 15811, 18549, 18966, 204872) group by brand_id, content_id order by n desc;

SELECT 
    stations_id as tv_station_id,
    MIN(airing_time) as start_time,
    MAX(airing_time) as end_time,
    COUNT(*) as num_airings,
    network as tv_network,
    station_tz as tv_station_tz,
    insights.getTvStationTZ(stations_id) AS config_file_tv_station_tz
FROM
    tv_airings.ad_airings_all
GROUP BY stations_id , station_tz , network;

select stations_id, network as tv_station_tz from tv_airings.ad_airings_all group by stations_id, network;

select content_id, airing_time as airing_start_time_UTC,
	   (CASE WHEN(seq_no < 0)THEN 0 ELSE seq_no END) as pod_position,
       ad_cost_est as spend, stations_id as tv_station_id,
       insights.getTvStationTZ(stations_id) as tv_station_tz, network as tv_network,
       show_name as show_title, show_genre as show_genres,
       '0000-00-00 00:00:00' as show_start_time_UTC,
       '0000-00-00 00:00:00' as show_end_time_UTC
FROM tv_airings.ad_airings_all limit 10;


SELECT 
    DATE(airing_time) AS airing_date, count(*) as num_records
FROM
    tv_airings.ad_airings_all
WHERE
    station_tz = 'NULL'
GROUP BY airing_date
ORDER BY airing_date DESC;

select * from tv_airings.ad_airings_all where brand_id = 356 order by airing_time desc;
		