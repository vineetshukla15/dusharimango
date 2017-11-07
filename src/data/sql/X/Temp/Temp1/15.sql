SELECT WEEKOFYEAR('2015-01-01');
SELECT WEEKOFYEAR('2016-01-01');
SELECT WEEKOFYEAR('2017-01-01');

select ((DAYOFYEAR('2015-01-03') + (weekday('2015-01-01') +1)) DIV 7) as broadcastweek;

select (((DAYOFYEAR('2015-12-27') + (weekday('2015-01-01') - 1)) DIV 7) + 1) as broadcastweek;


SELECT WEEKDAY('2015-12-28'); # (0 = Monday, 1 = Tuesday, … 6 = Sunday)
SELECT (6 - WEEKDAY('2015-12-28'));
SELECT ADDDATE('2015-12-28', (6 - WEEKDAY('2015-12-28'))); # The last day / sunday of the week
SELECT WEEK(ADDDATE('2015-12-28', (6 - WEEKDAY('2015-12-28'))), 2) AS broadcast_week;
SELECT SUBSTR(MONTHNAME(ADDDATE('2015-12-28', (6 - WEEKDAY('2015-12-28')))), 1, 3) AS broadcast_month;
SELECT YEAR(ADDDATE('2015-12-28', (6 - WEEKDAY('2015-12-28')))) AS broadcast_year;
SELECT CONCAT('Q', QUARTER(ADDDATE('2015-12-28', (6 - WEEKDAY('2015-12-28'))))) AS broadcast_quarter;

SELECT WEEK(ADDDATE('2016-09-25', (6 - WEEKDAY('2016-09-25'))), 2) AS broadcast_week;
SELECT SUBSTR(MONTHNAME(ADDDATE('2016-09-25', (6 - WEEKDAY('2016-09-25')))), 1, 3) AS broadcast_month;
SELECT YEAR(ADDDATE('2016-09-25', (6 - WEEKDAY('2016-09-25')))) AS broadcast_year;
SELECT CONCAT('Q', QUARTER(ADDDATE('2016-09-25', (6 - WEEKDAY('2016-09-25'))))) AS broadcast_quarter;

drop table brands;
drop table categories;
drop table products;
drop table contents;
drop table content_product_brand_category;