SELECT * FROM insights.categories;

select category_id,
	   (case when(category_display_name is null) then category_name else category_display_name end) as category_name
from insights.categories;