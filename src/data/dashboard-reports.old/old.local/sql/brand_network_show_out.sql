SELECT airing_date, brand_id, brand, network, show_name, sum(airings) AS airings, SUM(spend) AS spend
#FROM dashboard.content_brand_network_show_temp
FROM dashboard.content_brand_network_show WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)
GROUP BY airing_date, brand_id, network, show_name
ORDER BY airing_date, brand, network, show_name;
