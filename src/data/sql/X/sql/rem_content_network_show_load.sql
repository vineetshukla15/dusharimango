REPLACE INTO insights.content_network_show
select content_id, content_title, content_duration, alphonso_owned, content_group_id,
	   product_id, product_name, productline_id, brand_id, brand_name, brand_group_id, category_id, category_name,
       DATE(airing_time) as airing_date, #daypart, 
       count(*) as airings, sum(spend) as spend, tv_network, show_title, show_genres,
       coop_product_id, coop_product_name, coop_productline_id, coop_brand_id, coop_brand_name, coop_brand_group_id, coop_category_id, coop_category_name
from airings as a
-- left join
-- (select content_id as content_group_id, (case when(content_display_title is null) then content_title else content_display_title end) as content_group_title from contents) as c
-- on a.content_group_id = c.content_group_id
-- left join
-- (select product_id as productline_id, (case when(product_display_name is null) then product_name else product_display_name end) as productline_name from products) as p
-- on a.productline_id = p.productline_id
group by content_id, airing_date, #daypart, 
         tv_network, show_title, show_genres;