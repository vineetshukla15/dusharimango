SELECT airing_date, content_id, content_title, brand_id, brand, network, sum(airings) AS airings, SUM(spend) AS spend
#FROM dashboard.content_brand_network_show_temp
FROM dashboard.content_brand_network_show WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL 7 DAY)
GROUP BY airing_date, content_id, brand_id, network
ORDER BY airing_date, content_title, brand, network;
