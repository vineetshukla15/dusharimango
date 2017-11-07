SELECT * FROM tv_airings.ad_airings_all where content_id in (3216790, 3200052) and network = 'Univision' order by ad_airing_start_time_STN desc;


rename table insights.ad_airings_all to tv_airings.ad_airings_all;

rename table insights.ad_airings_all_20161029 to tv_airings.ad_airings_all_20161029;