SELECT * FROM insights.content_product_brand_category where brand_id = 331;


select * from(
select * from(
select content_group_id, sum(alphonso_owned) as alphonso_owned, count(*) as num_contents
from contents
group by content_group_id, content_duration
) as x
where x.alphonso_owned > 1) as y
left join content_product_brand_category as cpbc
on y.content_group_id = cpbc.content_group_id
order by cpbc.brand_id, cpbc.content_group_id, cpbc.content_id;