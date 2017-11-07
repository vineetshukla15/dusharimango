#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/push_to_prod.$now.log
# Load other config
source $basedir/config

tblname=brands
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=categories
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=products
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=contents
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

<<"COMMENT"
tblname=content_product_brand_category
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"
COMMENT

tblname=content_productl_brandg_category
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=airings_master
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=airings_stage
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=content_network_show_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=content_network_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=contentg_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=content_list
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=product_network_show_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=product_network_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=category_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=brand_network_show_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=brand_network_airings
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=brand_list
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=coop_list
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

<<"COMMENT"
tblname=viewers_master
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=content_viewers
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"

tblname=brand_viewers
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname to $tblname""_$now;"
mysql -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost $insightsdbname -e "rename table $tblname$tblsuffix to $tblname;"
COMMENT