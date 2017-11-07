SELECT airing_date, brand_id, brand, network, sum(airings) AS airings, SUM(spend) AS spend
#FROM dashboard.brand_network_show_temp
FROM dashboard.brand_network_show WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)
GROUP BY airing_date, brand_id, network
ORDER BY airing_date, brand, network;
