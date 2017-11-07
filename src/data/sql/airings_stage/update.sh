#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
num_days=$6

subQuery=
if [ -n $6 -a "$6" -eq "$6" ]; then
  subQuery="AND airing_start_time_UTC >= DATE_SUB(CURDATE(),INTERVAL $num_days DAY)"
fi

# Update the Cartoon -> Adult Swim and Nickelodeon -> nick@nite for airing time 9:00pm - 6:00am
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
UPDATE $tbl SET tv_network = 'Adult Swim'
WHERE tv_network ='Cartoon' AND (HOUR(airing_time) >= 21 OR HOUR(airing_time) < 6) $subQuery;
UPDATE $tbl SET tv_network = 'nick@nite'
WHERE tv_network ='Nickelodeon' AND (HOUR(airing_time) >= 21 OR HOUR(airing_time) < 7) $subQuery;

# local-airing
UPDATE $tbl SET airings_type = 2
WHERE brand_id IN (
    90550,#	East Coast Toyota
    20657,#	Optimum
    66160,#	P. C. Richard & Son
    21874,# Raymour & Flanigan
    85836,# Hudson Toyota
    97058 # Sunrise Toyota
);
# Pulaski & Middleman Commercial, Pulaski & Middleman, L.L.C, Attorneys Commercial
# https://app.asana.com/0/157781258557973/355100802574900/f
UPDATE $tbl SET airings_type = 2 WHERE content_id IN (2405167, 2400984, 2397991, 2403282, 49434);

# invalid-content
UPDATE $tbl SET airings_type = 11 WHERE content_id = 0;
UPDATE $tbl SET airings_type = 11 WHERE content_id = 1781035; # Refer https://app.asana.com/0/158464490442702/234118845473691/f
UPDATE $tbl SET airings_type = 11 WHERE content_id = 3214486; # Refer https://app.asana.com/0/157781258557973/325376387269964/f
# invalid-show
UPDATE $tbl SET airings_type = 12 WHERE show_title IN ('null', 'undefined');
# paid-program
UPDATE $tbl SET airings_type = 13 WHERE show_title IN ('Paid Programming', 'SIGN OFF');
# content-deleted
UPDATE $tbl SET airings_type = 14 WHERE content_id = 3236822;

# movie-trailer-in-cinema
UPDATE $tbl SET airings_type = 21 WHERE content_id IN(3240913, 3243408, 3243410, 3243415, 3243418,
                                                 3243432, 3243417, 3243414, 3243411);
UPDATE $tbl SET airings_type = 21 WHERE content_id IN(3243824, 3243821);

# did-not-air
# Samsung
UPDATE $tbl SET airings_type = 31 WHERE content_id IN(3240329, 3240116);
# Apple
UPDATE $tbl SET airings_type = 31 WHERE content_id IN(3221449, 3220413, 3214326) AND YEAR(airing_start_time_UTC) > '2016';
UPDATE $tbl SET airings_type = 31 WHERE content_id IN(3241436, 3213438, 3241125);
# does-not-buy
UPDATE $tbl SET airings_type = 32 WHERE brand_id = 2618 AND coop_product_id IS NULL AND product_id IN (
2940614,# Galaxy
2796095,# Galaxy S7 Edge
2772654,# Samsung Electronics
3199135,# Samsung Galaxy S8
3262597,# Samsung Galaxy Tab S3
3166495,# Samsung Gear 360
1437980,# Samsung Mobile
3065830,# Samsung Pay
3225931,# Samsung VR
2837591,# Galaxy S7
2908029,# Samsung Galaxy Note7
2977308,# Samsung Gear Fit2
3070091,# Samsung Gear VR

2771289 # Samsung S4

) AND tv_network IN ('Aspire','AXS.TV','BET Gospel','Big Ten Network','Boomerang','Chiller','Cloo','Discovery Family','Disney','Disney Junior',
                     'EWTN','Fox Business','Fox News','Great American Country','MTVU','Nick Junior','Outer Max','Reelz','RFDTV', 'SEC',
                     'Smithsonian','Sportsman','Sprout','Sundance','TCM','TMC','Universal','Uplifting Entertainment ','Velocity','WGN');
# commercial-free-network
UPDATE $tbl SET airings_type = 33 WHERE tv_network IN ('Encore', 'Encore Family');
# doubtful-airing
UPDATE $tbl SET airings_type = 34 WHERE content_id = 3242263;

# duplicate-network
UPDATE $tbl SET airings_type = 41 WHERE tv_network IN ('Nick2');
"