load data local infile '/home/warehouseuser/dashboard-reports/dump/content_brand_network_show.tsv'
replace
into table dashboard.content_brand_network_show
ignore 1 lines;
