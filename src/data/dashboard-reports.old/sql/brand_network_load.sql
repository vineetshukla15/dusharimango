load data local infile '/home/warehouseuser/dashboard-reports/dump/brand_network.tsv'
replace
into table dashboard.brand_network
ignore 1 lines;
