load data local infile '/home/warehouseuser/dashboard-reports/dump/content_brand_network.tsv'
replace
into table dashboard.content_brand_network
ignore 1 lines;