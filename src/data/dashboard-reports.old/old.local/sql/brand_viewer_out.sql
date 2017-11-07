SELECT brand, lat, lng, airing_date, sum(viewers) AS viewers
FROM dashboard.content_brand_viewer
WHERE airing_date >= DATE_SUB(CURDATE(),INTERVAL 45 DAY)
GROUP BY brand, lat, lng, airing_date
ORDER BY brand, airing_date;
