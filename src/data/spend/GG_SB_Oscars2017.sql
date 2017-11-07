# Golden Globe 2017
-- 74th Golden Globe Awards was at 8:00 PM - 11:00 PM on
-- Sunday, January 8, 2017
-- All times are in Eastern Time.
UPDATE tv_airings.ad_airings_all_tmp SET ad_cost_est= ROUND(content_duration * 577 / 30)
WHERE airing_time BETWEEN '2017-01-09 01:00:00' AND '2017-01-09 04:00:00' AND network = 'NBC';

# Superbowl 2017
-- Final/OT - Sunday, February 5, 6:30 PM
-- NRG Stadium, Houston, Texas
-- All times are in Eastern Time.
UPDATE tv_airings.ad_airings_all_tmp SET ad_cost_est= ROUND(content_duration * 4900 / 30)
WHERE airing_time between '2017-02-05 23:30:00' and '2017-02-06 03:30:00' and network = 'FOX';

# Oscar 2017
-- 89th Academy Awards was at 8:30 PM - 11:30 PM on
-- Sunday, February 26, 2017
-- All times are in Eastern Time.
UPDATE tv_airings.ad_airings_all_tmp SET ad_cost_est= ROUND(content_duration * 1950 / 30)
WHERE airing_time BETWEEN '2017-02-27 01:30:00' AND '2017-02-27 05:20:00' AND network = 'ABC';
