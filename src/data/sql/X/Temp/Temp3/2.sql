SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01';

select * from tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01' order by airing_time asc;

select * from tv_airings.ad_airings_all where airing_time >= '2016-08-01' and airing_time <= '2016-09-01' order by airing_time desc;