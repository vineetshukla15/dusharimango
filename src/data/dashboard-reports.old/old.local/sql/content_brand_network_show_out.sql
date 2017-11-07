drop function if exists dashboard.getDayPart;
delimiter //
create function dashboard.getDayPart (datetimeinput DATETIME) returns varchar(24)
begin
	declare daypart varchar(24);
    declare dayofweek int(1);
    declare hourofday int(2);
    
    set dayofweek = weekday(datetimeinput);
    set hourofday = hour(datetimeinput);

    IF (dayofweek <= 4) THEN # That is Day is between Monday to Friday
        IF (hourofday < 1) THEN set daypart = 'LATE FRINGE';
        ELSEIF (hourofday < 1) THEN set daypart = 'LATE FRINGE';
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

SELECT DATE(airing_time) AS airing_date, content_id, title as content_title, brand_id, brand, network, show_name, COUNT(*) AS airings, SUM(ad_cost_est) AS spend, dashboard.getDayPart(airing_time) AS daypart
#FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all) AS ad_airings_all
#FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all WHERE DATE(airing_time) >= DATE('2016-01-01')) AS ad_airings_all
FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all WHERE DATE(airing_time) >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)) AS ad_airings_all
GROUP BY airing_date, content_id, brand_id, network, show_name, daypart
ORDER BY airing_date, content_title, brand, network, show_name;
