#!/bin/bash -x

basedir=$(dirname $(readlink -f "$0"))
now=$(date +"%Y%m%d%H%M%S")
# Log file
LOG_FILE=$basedir/logs/populate_content_tables.$now.log
# Load master config
source $basedir/config

sourcedbusername=$uacdbusername
sourcedbpassword=$uacdbpassword
sourcedbhost=$uacdbhost
sourcedbname=$uacdbname

# $1 -> update the prod table (boolean true/false defaults to false)
if [ "$1" = true ]; then
  tblsuffix=
fi
echo $tblsuffix
# Load this script config
source $basedir/populate_content_config$tblsuffix

sourcetblname=content_brands
insightstblname=brands
if [ "$brands" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --columns=brand_id,brand_name --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix
echo $(date)
fi

sourcetblname=content_categories
insightstblname=categories
if [ "$categories" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --columns=category_id,category_name --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix
echo $(date)
fi

sourcetblname=content_product
insightstblname=products
if [ "$products" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --columns=product_id,product_name,brand_id,category_id --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix
echo $(date)
fi

sourcetblname=content
insightstblname=contents
if [ "$contents" = true ]; then
$sqlDir/$insightstblname"/out.sh" $sourcedbusername $sourcedbpassword $sourcedbhost $sourcedbname $sourcetblname > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --columns=content_id,content_title,content_duration,alphonso_owned,publish_status,product_id,content_group_id --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
$sqlDir/$insightstblname"/update.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $insightstblname$tblsuffix
echo $(date)
fi

# Now populate the denormalized content-product-brand-category table
<<"COMMENT"
insightstblname=content_product_brand_category
if [ "$content_product_brand_category" = true ]; then
$sqlDir/$insightstblname"/out.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $tblsuffix > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi
COMMENT

insightstblname=content_productl_brandg_category
if [ "$content_productl_brandg_category" = true ]; then
$sqlDir/$insightstblname"/out.sh" $insightsdbusername $insightsdbpassword $insightsdbhost $insightsdbname $tblsuffix > $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mysqlimport -u $insightsdbusername -p$insightsdbpassword --host=$insightsdbhost --replace --local --ignore-lines 1 $insightsdbname $dumpDir/$insightstblname$tblsuffix.tsv
echo $(date)
mv $dumpDir/$insightstblname$tblsuffix.tsv $dumpDir/$insightstblname.$now.tsv
echo $(date)
fi