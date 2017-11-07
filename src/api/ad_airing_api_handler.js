//global
var dbHost = "dev-4";
var mysql = require('mysql');

var lookup_table = new Object();
var lookup_table_recent = new Object();
var lookup_cnt = 0;
var lookup_cnt_recent = 0;

function clear_lookup_table() {
  lookup_table = new Object();
  lookup_table_recent = new Object();
}

function add_to_lookup_table(ad_str, this_utime) {
  lookup_table[ad_str] = this_utime;
  lookup_table_recent[ad_str] = this_utime;

  if (lookup_cnt > 1000) {
    //hopefully shrink the table
    lookup_table = lookup_table_recent;
    lookup_cnt = 0;
  }

  if (lookup_cnt_recent > 200) {
    // clear
    lookup_table_recent = new Object();
    lookup_cnt_recent = 0;
  }
  lookup_cnt++;
  lookup_cnt_recent++;


}


function get_url_args(req_url) {
  var results = {};
  if (!req_url) return results;

  var splits = req_url.split("?");
  if (splits.length < 2) {
    return results;
  }

  var key_vals = splits[1].split("&");
  for (var i = 0; i < key_vals.length; i++) {
    var kvs = key_vals[i].split("=");
    var key = kvs[0];
    var val = kvs[1];
    results[key] = val;
  }
  //console.log ('DBG results:' , results);
  return results;

}


function query_latest_ad_airing(req_url, httpres) {

  var url_args = get_url_args(req_url);

  var mysql = require('mysql');
  var connection = mysql.createConnection({
    host: 'uac-lean1.alphonso.tv',
    user: 'alpha',
    password: 'DeadB33f',
    database: 'uac'
  });

  connection.connect();
  var params = [];
  //var query_base = 'SELECT ca.id, ca.start_dt as start_time, ca.content_id, content2.title, product.brand, product.id as brand_id, tv_stations.tms_stn_id as stations_id,  tv_stations.network_name as network FROM aired_ads as ca LEFT join content2 on ca.content_id = content2.id LEFT JOIN product on content2.product_id = product.id LEFT JOIN aired_ad_blocks on aired_ad_blocks.id = ca.ad_block_id LEFT JOIN tv_stations on tv_stations.id = aired_ad_blocks.tv_stn_id ';
  var query_base = 'SELECT ca.id, ca.start_dt as start_time, ca.content_id, content.title, content_brands.name as brand, content_brands.id as brand_id, tv_stations.tms_stn_id as stations_id,  tv_stations.network_name as network FROM aired_ads as ca LEFT join content on ca.content_id = content.id LEFT JOIN content_product on content.product_id = content_product.id LEFT JOIN content_brands on content_product.brand_id = content_brands.id LEFT JOIN aired_ad_blocks on aired_ad_blocks.id = ca.ad_block_id LEFT JOIN tv_stations on tv_stations.id = aired_ad_blocks.tv_stn_id ';
  var query = query_base + ' order by ca.id desc limit 250;';
  var stations_id = url_args['stations_id'];
  var brand_id = url_args['brand_id'];
  var since_id = url_args['since_id'];


  var query_base_since;
  if (since_id && since_id > 0) {
    query_base_since = query_base + 'where ca.id > ' + since_id;
  }

  if (req_url.indexOf('ad_airings') > -1) {
    //console.log ('processing ad_airings, stations_id:' + stations_id );
    if (stations_id && stations_id > 0) {
      if (query_base_since) {
        query = query_base_since + ' and stations.id =' + stations_id + ' order by ca.id desc limit 100;';
      } else {
        query = query_base + ' where stations.id =' + stations_id + ' order by ca.id desc limit 100;';
      }
    }

    if (brand_id && brand_id > 0) {
      if (query_base_since) {
        query = query_base_since + ' and product.id =' + brand_id + ' order by ca.id desc limit 100;';
      } else {
        query = query_base + ' where product.id =' + brand_id + ' order by ca.id desc limit 100;';
      }
    }
    //console.log ('DBG query:' + query );
    connection.query(query,
      function(err, res, fields) {
        if (err) throw err;
        var res_data = [];
        for (var i = 0; i < res.length; i++) {
          var res_item = {};
          res_item["id"] = res[i].id;
          //unclear why NY time is getting mixed up as GMT,hack fix
          var d1 = new Date(res[i].start_time);
          //var d2 = new Date (d1 - 4 * 60 * 60000);
          var d2 = new Date(d1);
          var moment = require('moment');
          var d3 = moment(d2).format();
          //res_item["air_time"] = res[i].start_time;
          res_item["air_time"] = d3;
          res_item["title"] = res[i].title;
          res_item["brand"] = res[i].brand;
          res_item["brand_id"] = res[i].brand_id;
          res_item["station"] = res[i].network;
          res_item["stations_id"] = res[i].stations_id;
          var content_id = res[i].content_id;
          res_item["content_id"] = content_id;
          res_item["thumbnail"] = 'http://assets.alphonso.tv/advt_db/' + content_id + '.jpg';
          res_item["mp4_clip"] = 'http://assets.alphonso.tv/advt_db/' + content_id + '.mp4';


          //check if the new entry is a dup or not, only push if not dup
          var date = res[i].start_time;
          var this_utime = new Date(date).getTime() / 1000;
          //var ad_str = res_item["title"] + '\t' + res_item["brand"] + '\t' + res_item["stations_id"] + '\t' + res_item["content_id"];
          var ad_str = res_item["title"] + '\t' + res_item["brand"] + '\t' + res_item["stations_id"];
          // check if there is an ad like this within 60 secs
          if (lookup_table.hasOwnProperty(ad_str)) {
            if (Math.abs(this_utime - lookup_table[ad_str]) > 60) {
              add_to_lookup_table(ad_str, this_utime);
              res_data.push(res_item);
            } else {
              //console.log('_DBG DUP:' + ad_str + ' date:' + date);
            }
          } else {
            //lookup_table[ad_str] = this_utime;
            add_to_lookup_table(ad_str, this_utime);
            res_data.push(res_item);
          }
          //end dup logic bloc

          //console.log('query result is: ',  res[i]);
        } //end look thru each items

        //clear lookup table after API processing
        clear_lookup_table()
          //respond with API results
        if (httpres) {
          return httpres.end(JSON.stringify(res_data, false, 6) + '\n');
        } else {
          console.log('DBG:' + JSON.stringify(res_data, false, 6));
        }
      });
  }


} // end func

function query_content_by_id(content_id, httpres) {
  var res_hash = {};
  res_hash['id'] = content_id;

  var connection = mysql.createConnection({
    host: dbHost,
    user: 'warehouseuser',
    password: '1973Warehouse1@',
    database: 'dashboard'
  });
  connection.connect();
  var query;
  query = 'select content.id, title, type, duration,genre,brand,categories.name as category,product.id as brand_id from content,product,categories  where content.product_id=product.id and product.category=categories.id  and  content.id=?';
  //console.log ('DBG query:' + query );
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        res_hash['content_id'] = content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "Alphonso Brands";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id + '.jpg';
        res_hash['mp4_clip'] = 'http://assets.alphonso.tv/advt_db/' + content_id + '.mp4';
      }
      if (httpres) {
        httpres.send(JSON.stringify(res_hash, "", 2));
      } else {
        console.log('DBG res_hash:' + JSON.stringify(res_hash, "", 2));
      }
    });

}

function util_func1(input) {
  console.log('> util_func1, input:' + input);
  return ("output1");
}

module.exports = {
  query_latest_ad_airing: query_latest_ad_airing,
  util_func1: util_func1
}
