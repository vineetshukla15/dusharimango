SELECT * FROM insights.contents;

SELECT * FROM insights.contents where content_id in (3204734, 3166710, 2966913, 3195977, 3212040, 3212403, 3212528, 3212375, 3214442, 3212466, 3214318, 3213559, 3197067, 3214799, 3215323);

UPDATE insights.contents set coop_product_id = 2845197 where content_id in (3204734, 3166710, 2966913, 3195977, 3212040, 3212403, 3212528, 3212375, 3214442, 3212466, 3214318, 3213559, 3197067, 3214799, 3215323);

UPDATE insights.contents set coop_product_id = 25569 where content_id in (3191967);
UPDATE insights.contents set coop_product_id = 2766911 where content_id in (3204057, 3205442, 3212522, 3212907, 3213159, 3213454);
UPDATE insights.contents set coop_product_id = 25636 where content_id in (3206959);
UPDATE insights.contents set coop_product_id = 27166 where content_id in (3213547);


# = 2845197;


select count(*) from
(select c.content_id, (case when(c.content_display_title is null) then c.content_title else c.content_display_title end) as content_title,
	   (round(c.content_duration/15000) * 15) as content_duration, c.alphonso_owned, c.content_group_id,
       c.content_product_id as product_id
from contents as c
left join products as p on c.content_product_id = p.product_id
left join brands as b on p.brand_id = b.brand_id
left join categories as cat on p.category_id = cat.category_id) as cpbc;