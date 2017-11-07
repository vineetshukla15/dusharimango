SELECT *   FROM insights.content_airings;

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
      
      
drop function if exists insights.getDayPart;
delimiter //
create function insights.getDayPart (datetimeLocal DATETIME) returns varchar(24)
begin
    declare daypart varchar(24);
    declare dayofweek int(1);
    declare hourofday int(2);
    
    set dayofweek = weekday(datetimeLocal);
    set hourofday = hour(datetimeLocal);

    IF (dayofweek <= 4) THEN # That is Day is between Monday to Friday
        IF (hourofday < 1) THEN set daypart = 'LATE FRINGE';
        ELSEIF (hourofday < 5) THEN set daypart = 'OVER NIGHT';
        ELSEIF (hourofday < 10) THEN set daypart = 'EARLY MORNING';
        ELSEIF (hourofday < 16) THEN set daypart = 'DAY TIME';
        ELSEIF (hourofday < 19) THEN set daypart = 'EARLY FRINGE';
        ELSEIF (hourofday < 23) THEN set daypart = 'PRIME TIME';
        ELSE set daypart = 'LATE FRINGE';
        END IF;
    ELSE # That is Day is Saturday / Sunday
        IF (hourofday < 13) THEN set daypart = 'WEEKEND DAY';
        ELSEIF (hourofday < 19) THEN set daypart = 'WEEKEND AFTERNOON';
        ELSEIF (hourofday < 23) THEN set daypart = 'PRIME TIME';
        ELSE set daypart = 'WEEKEND DAY';
        END IF;
    END IF;

    return(daypart);
end//
delimiter ;

