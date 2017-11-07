SELECT * FROM insights.content_product_brand_category where coop_product_id is not null;

REPLACE INTO insights.content_product_brand_category
select cpbc.content_id, cpbc.content_title, cpbc.content_duration, cpbc.alphonso_owned, cpbc.content_group_id,
       cpbc.product_id, cpbc.product_name, cpbc.productline_id, cpbc.brand_id, cpbc.brand_name, cpbc.brand_group_id,
       cpbc.category_id, cpbc.category_name,
       cpbc.coop_product_id, coop.product_name as coop_product_name, coop.productline_id as coop_productline_id,
       coop.brand_id as coop_brand_id, coop.brand_name as coop_brand_name, coop.brand_group_id as coop_brand_group_id,
       coop.category_id as coop_category_id, coop.category_name as coop_category_name
from
(select c.content_id, (case when(c.content_display_title is null) then c.content_title else c.content_display_title end) as content_title,
	   (round(c.content_duration/15000) * 15) as content_duration, c.alphonso_owned, c.content_group_id,
       c.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name, p.productline_id,
	   p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name, b.brand_group_id,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name,
       c.coop_product_id
from contents as c
left join products as p on c.product_id = p.product_id
left join brands as b on p.brand_id = b.brand_id
left join categories as cat on p.category_id = cat.category_id) as cpbc # content product brand category
left join
(select p.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name, p.productline_id,
       p.brand_id, (case when(b.brand_display_name is null) then b.brand_name else b.brand_display_name end) as brand_name, b.brand_group_id,
       p.category_id, (case when(cat.category_display_name is null) then cat.category_name else cat.category_display_name end) as category_name
from products as p
left join brands as b on p.brand_id = b.brand_id
left join categories as cat on p.category_id = cat.category_id) as coop # CoOp data
on cpbc.coop_product_id = coop.product_id;