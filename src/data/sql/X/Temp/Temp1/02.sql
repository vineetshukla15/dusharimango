SELECT sum(ad_cost_est), count(*) FROM tv_airings.ad_airings_all;

SELECT sum(spend), sum(airings), count(*) FROM dashboard.content_brand_network_show_temp;

SELECT sum(spend), sum(airings), count(*) FROM dashboard.content_brand_network_temp;

SELECT sum(spend), sum(airings), count(*) FROM dashboard.brand_network_show_temp;

SELECT sum(spend), sum(airings), count(*) FROM dashboard.brand_network_temp;