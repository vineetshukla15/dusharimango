
for f in `ls -tr *.updated `;
do
 echo "Processing $f"
 # do something on $f
 ./loadDataToDB.sh $f tv_airings ad_airings_all_tmp
done
