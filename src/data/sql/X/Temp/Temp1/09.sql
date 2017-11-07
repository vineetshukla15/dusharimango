select * from products;

SELECT * FROM insights.products where brand_id in (3396,
6217,
10503,
10874,
10922,
11089,
12869,
15614,
15811,
18549,
18966,
204872
);

SELECT * FROM insights.products where brand_id in (3396, 6217, 10503, 10874, 10922, 11089, 12869, 15614, 15811, 18549, 18966, 204872);

select p.product_id, (case when(p.product_display_name is null) then p.product_name else p.product_display_name end) as product_name,
	   p.brand_id, p.category_id,
	   p.productline_id, (case when(pl.product_display_name is null) then pl.product_name else pl.product_display_name end) as productline_name,
       pl.brand_id, pl.category_id
from insights.products as p,
	 insights.products as pl
where p.productline_id = pl.product_id;

