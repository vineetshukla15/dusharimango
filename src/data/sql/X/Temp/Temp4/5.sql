SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-01-01' and airing_time < '2016-02-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-02-01' and airing_time < '2016-03-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-03-01' and airing_time < '2016-04-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-04-01' and airing_time < '2016-05-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-05-01' and airing_time < '2016-06-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-06-01' and airing_time < '2016-07-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-07-01' and airing_time < '2016-08-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-08-01' and airing_time < '2016-09-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-09-01' and airing_time < '2016-10-01';
SELECT count(*), sum(ad_cost_est) FROM tv_airings.ad_airings_all_tmp where airing_time >= '2016-10-01' and airing_time < '2016-11-01';


-- drop table if exists tv_airings.ad_airings_all_tmp;
-- CREATE TABLE tv_airings.ad_airings_all_tmp
-- (
--    airing_time datetime, INDEX(airing_time),
--    content_id int, INDEX(content_id),
--    title varchar(100),
--    brand varchar(100), INDEX(brand),
--    brand_id int, INDEX(brand_id),
--    stations_id int, INDEX(stations_id),
--    network varchar(100), INDEX(network),
--    show_name varchar(100), INDEX(show_name),
--    show_genre varchar(100),
--    show_tmsid varchar(100), INDEX(show_tmsid),
--    ad_cost_est int,
--    brand_cat_id int,
--    brand_cat varchar(100),
--    end_dt datetime,
--    ad_block_id int,
--    seq_no int,
--    product_id int, 
--    product varchar(100),
--    content_duration int,
--    ad_airing_start_time_STN datetime,
--    station_tz varchar(100),
--    station_tz_abbr varchar(100),
--    station_tz_offset varchar(100),
--    PRIMARY KEY (airing_time, content_id, brand_id, stations_id, network, show_name, show_tmsid)
-- );