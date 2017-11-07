select aggregate.network as network, 0 as b1, ifnull(content.b2, 0) as b2 , cast(b2 as UNSIGNED) as summ
			from (select distinct network 
				  from content_brand_network 
                  where (content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375,3205442,3212907,3213159,3191967) or brand_id in (2596, 3396, 300, 883, 248, 2618)) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05') ) as aggregate 
			left join 
				 (select network, sum(airings) as b2 
                  from content_brand_network 
                  where content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network
order by summ desc limit 2000;

select aggregate.network as network, 0 as b1, aggregate.b2, ifnull(content.b3, 0) as b3, 0 as b4 , cast(b1+b2+b3 as UNSIGNED) as summ
	  from (select aggregate.network as network, 0 as b1, ifnull(content.b2, 0) as b2 
			from (select distinct network 
				  from content_brand_network 
                  where (content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375,3205442,3212907,3213159,3191967) or brand_id in (2596, 3396, 300, 883, 248, 2618)) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05') ) as aggregate 
			left join 
				 (select network, sum(airings) as b2 
                  from content_brand_network 
                  where content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network) as aggregate 
	  left join 
		   (select network, sum(airings) as b3 
            from content_brand_network 
            where content_id in (3205442,3212907,3213159) and 
				  airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network
order by summ desc limit 2000;

select aggregate.network as network, 0 as b1, b2, b3, 0 as b4, ifnull(b5, 0) as b5, 0 as b6 , cast(b2+b3+b5 as UNSIGNED) as summ
from (select aggregate.network as network, 0 as b1, aggregate.b2, ifnull(content.b3, 0) as b3, 0 as b4 
	  from (select aggregate.network as network, 0 as b1, ifnull(content.b2, 0) as b2 
			from (select distinct network 
				  from content_brand_network 
                  where (content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375,3205442,3212907,3213159,3191967) or brand_id in (2596, 3396, 300, 883, 248, 2618)) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05') ) as aggregate 
			left join 
				 (select network, sum(airings) as b2 
                  from content_brand_network 
                  where content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375) and 
						airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network) as aggregate 
	  left join 
		   (select network, sum(airings) as b3 
            from content_brand_network 
            where content_id in (3205442,3212907,3213159) and 
				  airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network) as aggregate 
left join 
	 (select network, sum(airings) as b5 
      from content_brand_network 
      where content_id in (3191967) and 
			airing_date between Date('2016-01-01') and Date('2016-10-05')) as content on content.network = aggregate.network 
order by summ desc limit 2000;

select network, b1, b2, b3 , summ from
(
select aggregate.network as network, aggregate.b1, aggregate.b2, ifnull(content.b3, 0) as b3, (b1+b2+b3) as summ from (select aggregate.network as network, aggregate.b1, ifnull(content.b2, 0) as b2 from (select aggregate.network as network, ifnull(content.b1, 0) as b1 from (select distinct network from content_brand_network where (content_id in (3205442,3212907,3213159,3191967,2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375) or brand_id in (300, 248, 3396)) and airing_date between Date('2016-01-01') and Date('2016-10-06') ) as aggregate left join (select network, sum(airings) as b1 from content_brand_network where content_id in (3205442,3212907,3213159) and airing_date between Date('2016-01-01') and Date('2016-10-06')) as content on content.network = aggregate.network) as aggregate left join (select network, sum(airings) as b2 from content_brand_network where content_id in (3191967) and airing_date between Date('2016-01-01') and Date('2016-10-06')) as content on content.network = aggregate.network) as aggregate left join (select network, sum(airings) as b3 from content_brand_network where content_id in (2966913,3166710,3204734,3195977,3212040,3212403,3212528,3212375) and airing_date between Date('2016-01-01') and Date('2016-10-06')) as content on content.network = aggregate.network) as temp order by summ desc limit 2000;

