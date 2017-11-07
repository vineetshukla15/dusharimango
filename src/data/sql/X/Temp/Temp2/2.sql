SELECT * FROM tv_airings.ad_airings_all where brand_id = 249891;

SELECT content_id, count(*) FROM tv_airings.ad_airings_all where brand_id = 249891 group by content_id;