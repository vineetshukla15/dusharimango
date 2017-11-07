SELECT * FROM insights.contents;



select c.content_id, c.content_title, c.content_duration, c.alphonso_owned, c.product_id, c.content_group_id from(
select * from(
select content_group_id, (round(content_duration/15000) * 15) as content_duration, sum(alphonso_owned) as alphonso_owned, count(*) as num_contents
from contents
group by content_group_id, content_duration
) as x
where x.alphonso_owned > 1) as y
left join contents as c
on y.content_group_id = c.content_group_id
order by c.content_group_id, c.content_id;