load data local infile '/home/warehouseuser/dashboard-reports/dump/brand_network_show.tsv'
replace
into table dashboard.brand_network_show
ignore 1 lines;
