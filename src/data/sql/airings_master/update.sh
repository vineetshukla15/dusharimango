#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5
contents_meta_tbl=$6

mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
DELETE FROM $tbl WHERE content_id = 0;
DELETE FROM $tbl WHERE content_id = 1781035; # Refer https://app.asana.com/0/158464490442702/234118845473691/f
DELETE FROM $tbl WHERE content_id = 3214486; # Refer https://app.asana.com/0/157781258557973/325376387269964/f
UPDATE $tbl SET local = TRUE WHERE content_id IN
(SELECT content_id  FROM $contents_meta_tbl 
WHERE brand_id IN (
    90550,#	East Coast Toyota
    20657,#	Optimum
    66160,#	P. C. Richard & Son
    21874,# Raymour & Flanigan
    85836,# Hudson Toyota
    97058 # Sunrise Toyota
));
# Pulaski & Middleman Commercial, Pulaski & Middleman, L.L.C, Attorneys Commercial
UPDATE $tbl SET local = TRUE WHERE content_id IN(2405167, 2400984, 2397991, 2403282, 49434);
# https://app.asana.com/0/157781258557973/355100802574900/f
# movie-trailer-in-cinema
UPDATE $tbl SET local = TRUE WHERE content_id IN(3240913, 3243408, 3243410, 3243415, 3243418,
                                                 3243432, 3243417, 3243414, 3243411);
UPDATE $tbl SET local = TRUE WHERE content_id IN(3243824, 3243821);
# Did-not-air
# Samsung
UPDATE $tbl SET local = TRUE WHERE content_id IN(3240329, 3240116);
# Apple
UPDATE $tbl SET local = TRUE WHERE content_id IN(3221449, 3220413, 3214326) AND YEAR(airing_start_time_UTC) > '2016';
UPDATE $tbl SET local = TRUE WHERE content_id IN(3241436, 3213438, 3241125);
# Local Networks
UPDATE $tbl SET local = TRUE WHERE tv_network IN ('Comcast SportsNet Chicago' ,'Fox Sports Atlantic' ,'Fox Sports Central',
                                                  'Fox Sports Pacific' ,'Fox Sports Ohio' ,'FSN Midwest OCC' ,'MASN',
                                                  'Root Sports Pittsburgh' ,'SportsTime Ohio');
# commercial-free
UPDATE $tbl SET local = TRUE WHERE tv_network IN ('Encore', 'Encore Family');
# duplicate-network
UPDATE $tbl SET local = TRUE WHERE tv_network IN ('Nick2');
# Did-not-air
UPDATE $tbl SET local = TRUE WHERE brand_id = 2618 AND coop_product_id IS NULL AND product_id IN (
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
                     'Encore','EWTN','Fox Business','Fox News','Great American Country','MTVU','Nick Junior','Nick2','Outer Max','Reelz','RFDTV',
                     'SEC','Smithsonian','Sportsman','Sprout','Sundance','TCM','TMC','Universal','Uplifting Entertainment ','Velocity','WGN');"