SELECT * FROM insights.content_product_brand_category;# where coop_product_id is not null;# where brand_id in (3396, 6217, 10503, 10874, 10922, 11089, 12869, 15614, 15811, 18549, 18966, 204872);

select * from content_product_brand_category where product_id = 2845197;

select count(*) as num_contents, content_duration, alphonso_owned, brand_id, brand_name from content_product_brand_category
where brand_name like '%apple%'
group by brand_id, content_duration, alphonso_owned;