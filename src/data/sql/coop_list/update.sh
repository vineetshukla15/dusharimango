#!/bin/bash -x

dbusername=$1
dbpassword=$2
dbhost=$3
database=$4
tbl=$5

# Delete content that has been marked as deleted / discarded now.
mysql -u $dbusername -p$dbpassword --host=$dbhost $database -e "
DELETE FROM $tbl WHERE is_transient = FALSE; # Delete the previous set of data.
UPDATE $tbl SET is_transient = FALSE WHERE is_transient = TRUE;"