
select title, brand, brand_cat, network, show_name, airing_time, seq_no, daypart, product, (round(duration/15000) * 15) as 'duration (secs)' from
(select content_id, title, brand, brand_cat, network, show_name, 
		(CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END)as airing_time, 
		seq_no, tv_airings.getDayPart(airing_time, ad_airing_start_time_STN) as daypart 
from tv_airings.ad_airings_all 
where (brand_id = 3396 or content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375)) and 
	  DATE(CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END) between Date('2016-01-01') and Date('2016-10-06')) as airings 
left join
(select content_all.id as content_id, product, duration
from (select id, product_id, duration from content_all) as content_all
	left join
	 (select id, product from product) as product on content_all.product_id = product.id) as product on product.content_id = airings.content_id
order by airing_time desc;

select title, brand, brand_cat, network, show_name, airing_time, seq_no, daypart, product, (round(duration/15000) * 15) as duration 
from (select content_id, title, brand, brand_cat, network, show_name, 
			 (CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END) as airing_time, 
             seq_no, tv_airings.getDayPart(airing_time, ad_airing_start_time_STN) as daypart 
	  from tv_airings.ad_airings_all 
      where brand_id = 3396 and 
			DATE(CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END) between Date('2016-01-01') and Date('2016-10-06') ) as airings 
left join 
	 (select content_all.id as content_id, product, duration 
	  from (select id, product_id, duration from content_all) as content_all 
      left join 
		   (select id, product from product) as product 
	  on content_all.product_id = product.id) as content 
on content.content_id = airings.content_id 
order by airing_time desc;

select title, brand, brand_cat, network, show_name, airing_time, seq_no, daypart, product, (round(duration/15000) * 15) as duration from (select content_id, title, brand, brand_cat, network, show_name, (CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END) as airing_time, seq_no, tv_airings.getDayPart(airing_time, ad_airing_start_time_STN) as daypart from tv_airings.ad_airings_all where brand_id = 3396 and DATE(CASE WHEN(ad_airing_start_time_STN is null or ad_airing_start_time_STN = '0000-00-00 00:00:00')THEN airing_time ELSE ad_airing_start_time_STN END) between Date('2016-01-01') and Date('2016-10-06') ) as airings left join (select content_all.id as content_id, product, duration from (select id, product_id, duration from content_all) as content_all left join (select id, product from product) as product on content_all.product_id = product.id) as content on content.content_id = airings.content_id order by airing_time desc;
