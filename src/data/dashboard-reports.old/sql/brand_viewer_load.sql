load data local infile '/home/warehouseuser/dashboard-reports/dump/brand_viewer.tsv'
replace
into table dashboard.brand_viewer
ignore 1 lines;
