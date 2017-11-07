SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp;

select * from tv_airings.ad_airings_all_tmp order by airing_time asc;

select * from tv_airings.ad_airings_all_tmp order by airing_time desc;

SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where ad_cost_est <= 0;