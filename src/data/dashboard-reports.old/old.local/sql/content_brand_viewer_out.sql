drop function if exists dashboard.getTZString;
delimiter //
create function data_export.getTZString (strinput varchar(10)) returns varchar(10)
begin
	declare rtnval varchar(10);
    
	CASE strinput
		WHEN '540' THEN set rtnval = '+09:00';
		WHEN '600' THEN set rtnval = '+10:00';
		WHEN '-240' THEN set rtnval = '-04:00';
		WHEN '-300' THEN set rtnval = '-05:00';
		WHEN '-360' THEN set rtnval = '-06:00';
		WHEN '-420' THEN set rtnval = '-07:00';
		WHEN '-480' THEN set rtnval = '-08:00';
		WHEN '-540' THEN set rtnval = '-09:00';
		WHEN '-600' THEN set rtnval = '-10:00';
		WHEN '-660' THEN set rtnval = '-11:00';
		ELSE set rtnval = '+00:00';
	END CASE;
    
    return(rtnval);
end//
delimiter ;

SELECT content_id, title as content_title, brand, ROUND(loc_lat, 1) AS lat, ROUND(loc_long, 1) AS lng, DATE(CONVERT_TZ(start_time_first, '+00:00',dashboard.getTZString(user_tz))) AS airing_date, COUNT(*) AS viewers
FROM data_export.2016_jul_sling_data_all
WHERE content_id > 0 AND brand != 'null' AND (loc_lat != 0.0 AND loc_long != 0.0)
GROUP BY content_id, brand, lat, lng, airing_date
ORDER BY content_title, brand, airing_date;
