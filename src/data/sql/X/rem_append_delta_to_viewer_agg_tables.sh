# aggregation from sling tables
mysql -u warehouseuser -p1973Warehouse1@ < /home/warehouseuser/dashboard-reports/sql/content_brand_viewer_out.sql > /home/warehouseuser/dashboard-reports/dump/content_brand_viewer.tsv
mysqlimport -u warehouseuser -p1973Warehouse1@ --replace --local --ignore-lines 1 dashboard /home/warehouseuser/dashboard-reports/dump/content_brand_viewer.tsv

mysql -u warehouseuser -p1973Warehouse1@ < /home/warehouseuser/dashboard-reports/sql/brand_viewer_out.sql > /home/warehouseuser/dashboard-reports/dump/brand_viewer.tsv
mysqlimport -u warehouseuser -p1973Warehouse1@ --replace --local --ignore-lines 1 dashboard /home/warehouseuser/dashboard-reports/dump/brand_viewer.tsv
