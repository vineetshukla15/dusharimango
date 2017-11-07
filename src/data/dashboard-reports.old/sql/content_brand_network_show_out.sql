SELECT DATE(airing_time) AS airing_date, content_id, title as content_title, brand_id, brand, network, show_name, COUNT(*) AS airings, SUM(ad_cost_est) AS spend
#FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all) AS ad_airings_all
#FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all WHERE DATE(airing_time) >= DATE('2016-01-01')) AS ad_airings_all
FROM (SELECT DISTINCT * FROM tv_airings.ad_airings_all WHERE DATE(airing_time) >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)) AS ad_airings_all
GROUP BY airing_date, content_id, brand_id, network, show_name
ORDER BY airing_date, content_title, brand, network, show_name;
