SELECT count(*) FROM data_export.2016_jan_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_feb_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_mar_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_apr_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_may_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_jun_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_jul_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_aug_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT count(*) FROM data_export.2016_sep_sling_data_all
where content_id > 0 and (brand is null or brand = 'null');

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_jan_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_feb_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_mar_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_apr_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_may_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_jun_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_jul_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_aug_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT DATE(start_time_first) AS airing_date, brand, COUNT(*) AS num_airings FROM data_export.2016_sep_sling_data_all
where content_id > 0 and (brand is null or brand = 'null') group by airing_date, brand;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE
        WHEN (validrec.valid_airings IS NULL) THEN 0
        ELSE validrec.valid_airings
    END) AS valid_airings,
    (allrec.num_airings - (CASE
        WHEN (validrec.valid_airings IS NULL) THEN 0
        ELSE validrec.valid_airings
    END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_jan_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_jan_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_feb_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_feb_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_mar_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_mar_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_apr_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_apr_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_may_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_may_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_jun_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_jun_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_jul_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_jul_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_aug_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_aug_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;

SELECT 
    allrec.airing_date,
    allrec.num_airings,
    (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END) as valid_airings,
    (allrec.num_airings - (CASE WHEN(validrec.valid_airings is null)THEN 0 ELSE validrec.valid_airings END)) AS invalid_airings
FROM
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS num_airings
    FROM
        data_export.2016_sep_sling_data_all
    WHERE
        content_id > 0
    GROUP BY airing_date) AS allrec
        LEFT JOIN
    (SELECT 
        DATE(start_time_first) AS airing_date,
            COUNT(*) AS valid_airings
    FROM
        data_export.2016_sep_sling_data_all
    WHERE
        content_id > 0 AND (loc_lat != 0.0 AND loc_long != 0.0)
    GROUP BY airing_date) AS validrec ON allrec.airing_date = validrec.airing_date
ORDER BY allrec.airing_date ASC;