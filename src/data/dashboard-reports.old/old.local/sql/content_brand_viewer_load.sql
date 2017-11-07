load data local infile '/home/warehouseuser/dashboard-reports/dump/content_brand_viewer.tsv'
replace
into table dashboard.content_brand_viewer
ignore 1 lines;
