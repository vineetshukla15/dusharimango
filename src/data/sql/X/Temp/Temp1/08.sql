SELECT * FROM insights.brands;# where lcase(brand_name) like '%mobile%';

select b.brand_id, b.brand_name, b.brand_group_id, bg.brand_group_name
from
(select brand_id,
	   (case when(brand_display_name is null) then brand_name else brand_display_name end) as brand_name,
       brand_group_id 
from insights.brands) as b
left join
(select b.brand_id,
	   (case when(bg.brand_display_name is null) then bg.brand_name else bg.brand_display_name end) as brand_group_name
from insights.brands as b,
	 insights.brands as bg
where b.brand_group_id = bg.brand_id) as bg
on b.brand_id = bg.brand_id;

#update brands set brand_group_id = 1 where brand_id = 1;