//global
var dbHost = "dev-4";
var mysql = require('mysql');
var request = require('request');
var pending_query;
var async = require('async');


function format_mp4_url (content_id) {
   //var mp4_url =    'http://assets.alphonso.tv/advt_db/' + content_id + '.mp4';
   var mp4_url =    'http://cds.f2a7h7c4.hwcdn.net/advt_db/' + content_id + '.mp4';

   return mp4_url;
}

function format_poster_url (content_id) {
   //var poster_url = 'http://assets.alphonso.tv/advt_db/' + content_id + '/poster.jpg';
   var poster_url =  'http://cds.f2a7h7c4.hwcdn.net/advt_db/' + content_id + '/poster.jpg';

   return poster_url;
}

function attach_stats_from_cache(content_id) {
  var res_hash = {};
  var cache_file = 'public/cache-dir/content/' + content_id + '.json';
  var fs = require('fs');
  try {
    var cache_result = fs.readFileSync(cache_file, 'utf8');
    var cache_json = JSON.parse(cache_result);
    res_hash["share_of_voice"] = cache_json.hasOwnProperty("share_of_voice") ? parseFloat(cache_json["share_of_voice"]) : "";
    res_hash["viewership"] = cache_json.hasOwnProperty("viewership") ? parseFloat(cache_json["viewership"]) : "";
    res_hash["total_impressions"] = cache_json.hasOwnProperty("total_impressions") ? parseFloat(cache_json["total_impressions"]) : "";
  } catch (err) {
    //console.log ('DBG no share of voice for:' + content_id );
  }
  return res_hash;
}

function formatPercentage(v) {
  return v < 0.0001 ? "<0.01%" : "" + (v * 100).toFixed(2) + "%";
}

function getConnection(database) {
  var connection = mysql.createConnection({
    host: dbHost,
    user: 'warehouseuser',
    password: '1973Warehouse1@',
    database: database
  });
  connection.connect();
  return connection;
}

function query_for_id(content_id, arg, cb) {
  var connection = getConnection("dashmerge");
  var res_hash = {};
  var query;
  query = 'SELECT SUM(duration) AS duration, SUM(airings) AS airings, SUM(spend) AS spend, SUM(impressions) AS impressions, UNIX_TIMESTAMP(MIN(date)) AS campaign_begin, UNIX_TIMESTAMP(MAX(date)) AS campaign_end FROM group_statistics WHERE group_id = (SELECT COALESCE(dashboard.content_similar.group_id, a.content_id) FROM (SELECT ? AS content_id) AS a LEFT JOIN dashboard.content_similar ON a.content_id = dashboard.content_similar.content_id) GROUP BY group_id';
  //console.log('DBG group query1:' + query);
  connection.query(query, [content_id],
    function(err, res) {
      console.log(err, res);
      if (err || res == null || res.length == 0) {
        console.log("empty result");
        connection.end();
        cb(res_hash, arg);
      } else {
        query = 'CREATE TEMPORARY TABLE relevant_group_ids (source_group_id BIGINT, INDEX  (source_group_id) ) engine = MEMORY SELECT COALESCE(dashboard.content_similar.group_id, a.content_id) AS source_group_id FROM (SELECT cb.id AS content_id FROM dashboard.content_all AS ca JOIN dashboard.product AS pa ON pa.id=ca.product_id JOIN dashboard.product AS pb ON pb.category_id=pa.category_id JOIN dashboard.content_all AS cb ON cb.product_id=pb.id WHERE ca.id=? GROUP BY cb.id) AS a LEFT JOIN dashboard.content_similar ON a.content_id = dashboard.content_similar.content_id;';
        var category_spend = 0;
        var category_duration = 0;
        connection.query(query, [content_id],
          function(err, res2) {
            if (err) {
              console.log('Error creating temporary table', err);
              connection.end();
              return;
            }
            query = 'SELECT group_id, SUM(duration) AS duration, SUM(airings) AS airings, SUM(spend) AS spend, SUM(impressions) AS impressions FROM dashmerge.group_statistics JOIN relevant_group_ids ON source_group_id = group_id WHERE group_statistics.date >= FROM_UNIXTIME(?) AND group_statistics.date < FROM_UNIXTIME(?);';
            connection.query(query, [res[0].campaign_begin, res[0].campaign_end + 86400],
              function(err, res3) {
                console.log("query2 finished");
                if (err == null && res3 != null && res3.length > 0) {
                  category_spend += res3[0].spend;
                  category_duration += res3[0].duration;
                } else {
                  console.log(err, res3);
                }
                res_hash['share_of_voice'] = formatPercentage(res[0].duration / category_duration);
                res_hash['share_of_spend'] = formatPercentage(res[0].spend / category_spend);
                res_hash['total_airings'] = res[0].airings;
                res_hash['total_impressions'] = res[0].impressions * 625;
                res_hash['total_spend'] = res[0].spend;
                res_hash['duration'] = res[0].duration;
                connection.end();
                request.post('http://warehouse.alphonso.tv:5502/viewership', {
                  form: {
                    begin: res[0].campaign_begin,
                    end: res[0].campaign_end,
                    group1: content_id,
                    group2: content_id
                  }
                }, function(err, res, body) {
                  if (!err && res.statusCode == 200) {
                    console.log(body);
                    res_hash['viewership'] = JSON.parse(body).viewership * 625;
                  }
                  cb(res_hash, arg);
                });
              });
          });
      }
    });
}

function query_and_attach_group_stats(res_hash, httpres, callback) {
  var connection = getConnection("dashmerge");
  var content_id = res_hash['id'];
  var query;
  query = 'SELECT SUM(duration) AS duration, SUM(airings) AS airings, SUM(spend) AS spend, SUM(impressions) AS impressions, UNIX_TIMESTAMP(MIN(date)) AS campaign_begin, UNIX_TIMESTAMP(MAX(date)) AS campaign_end FROM group_statistics WHERE group_id = (SELECT COALESCE(dashboard.content_similar.group_id, a.content_id) FROM (SELECT ? AS content_id) AS a LEFT JOIN dashboard.content_similar ON a.content_id = dashboard.content_similar.content_id) GROUP BY group_id';
  connection.query(query, [content_id],
    function(err, res) {
      if (err || res == null || res.length == 0) {
        //query_and_attach_uniq_shows(res_hash,httpres);
        httpres.send(JSON.stringify(res_hash, "", 2));
        connection.end();
        return;
      } else {
        query = 'CREATE TEMPORARY TABLE relevant_group_ids (source_group_id BIGINT, INDEX  (source_group_id) ) engine = MEMORY SELECT COALESCE(dashboard.content_similar.group_id, a.content_id) AS source_group_id FROM (SELECT cb.id AS content_id FROM dashboard.content_all AS ca JOIN dashboard.product AS pa ON pa.id=ca.product_id JOIN dashboard.product AS pb ON pb.category_id=pa.category_id JOIN dashboard.content_all AS cb ON cb.product_id=pb.id WHERE ca.id=? GROUP BY cb.id) AS a LEFT JOIN dashboard.content_similar ON a.content_id = dashboard.content_similar.content_id;';
        var category_spend = 0;
        var category_duration = 0;
        connection.query(query, [content_id],
          function(err, res2) {
            if (err) {
              console.log('Error creating temporary table', err);
            } else {
              console.log('Creted temporary table');
            }
            query = 'SELECT group_id, SUM(duration) AS duration, SUM(airings) AS airings, SUM(spend) AS spend, SUM(impressions) AS impressions FROM dashmerge.group_statistics JOIN relevant_group_ids ON source_group_id = group_id WHERE group_statistics.date >= FROM_UNIXTIME(?) AND group_statistics.date < FROM_UNIXTIME(?);';
            connection.query(query, [res[0].campaign_begin, res[0].campaign_end + 86400],
              function(err, res3) {
                if (err == null && res3 != null && res3.length > 0) {
                  category_spend += res3[0].spend;
                  category_duration += res3[0].duration;
                } else {
                  console.log(err, res3);
                }
                res_hash['share_of_voice'] = formatPercentage(res[0].duration / category_duration);
                res_hash['share_of_spend'] = formatPercentage(res[0].spend / category_spend);
                res_hash['total_airings'] = res[0].airings;
                res_hash['total_impressions'] = res[0].impressions * 625;
                res_hash['total_spend'] = res[0].spend;
                res_hash['duration'] = res[0].duration;

                query = "SELECT COALESCE(GROUP_CONCAT(b.content_id SEPARATOR ','), ?) AS cids FROM dashboard.content_similar AS a JOIN dashboard.content_similar AS b ON b.group_id=a.group_id WHERE a.content_id=?";
                console.log(query);
                connection.query(query, [content_id, content_id],
                  function(err, res4) {
                    connection.end();
                    request.post('http://warehouse.alphonso.tv:5502/viewership', {
                      form: {
                        begin: res[0].campaign_begin,
                        end: res[0].campaign_end,
                        group1: res4[0].cids,
                        group2: content_id
                      }
                    }, function(err, res, body) {
                      if (!err && res.statusCode == 200) {
                        console.log(body);
                        res_hash['viewership'] = JSON.parse(body).viewership * 625;
                      }
                      //print this result - to result
                      httpres.send(JSON.stringify(res_hash, "", 2));
                    });
                });

              });
          });
      }
    });
}

function query_and_attach_group_stats_list(res_list, httpres, callback) {
  //get list of content_ids
  var params = [];
  for (var i = 0; i < res_list.length; i++) {
    var item = res_list[i];
    var content_id = item['content_id'];
    params.push(content_id);
  }
  console.log("params..", params);
  var all_res_hash = {};
  var nItemsInHash = 0;
  for (var i in params) {
    console.log("Queuing ", i);
    query_for_id(params[i], i, function(res_hash, i) {
      console.log("reshash2", i, res_hash);
      all_res_hash[params[i]] = {};
      for (var j in res_hash)
        all_res_hash[params[i]][j] = res_hash[j];
      nItemsInHash++;
      console.log("2GO", params.length, nItemsInHash)
      if (nItemsInHash == params.length) {
        // repackage the brand query results adding ad_airing and impressions
        var modified_res_list = [];
        for (var k = 0; k < res_list.length; k++) {
          var item = res_list[k];
          var content_id = item['content_id'];
          console.log("all res hash", all_res_hash);
          if (all_res_hash.hasOwnProperty(content_id)) {
            for (var l in all_res_hash[content_id]) {
              item[l] = all_res_hash[content_id][l];
            }
          }
          modified_res_list.push(item);
          console.log(modified_res_list);
        }
        //console.log ('DBG modified_res_list:' , modified_res_list );
        callback(null, modified_res_list, httpres)
      }
    });
  }
}


function query_share_of_voice_by_id(content_id, httpres, callback) {

  //console.log('DBG query_share_of_voice_by_id, content_id:' + content_id);
  var res_hash = {};
  console.log ('DBG content_id:' + content_id );
  var connection = getConnection("dashboard");
  var query;
  query = 'select ROUND ( (100*total_airings)/cat_airings, 2 ) as share_of_voice from cache_share_of_voice where content_id =? limit 1';
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        var res_hash = {};
        res_hash['id'] = content_id;
        res_hash['share_of_voice'] = res[i].share_of_voice;
      }
      connection.end();
      callback(null, res_hash, httpres);
    });




}



//end k func

function query_featured(httpres, callback) {
  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
  //query = 'select featured.content_id as content_id, title, type, duration, genre, brand,categories.name as category, product.id as brand_id from featured,content,product,categories where featured.content_id=content.id and content.product_id=product.id and product.id=categories.id;';
  query = 'select featured2.content_id as content_id, title, type, duration,  brands.name as brand,categories.name as category, brands.id as brand_id from featured2,content,product,brands,categories where featured2.content_id=content.id and content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id;';
  //console.log ('DBG qury:' + query );

  connection.query(query,
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        if (res[i].title ) {
           res_hash['poster'] = format_poster_url(content_id);
           res_hash['thumbnail'] = format_poster_url(content_id);
           res_hash['mp4_clip'] = format_mp4_url(content_id);
        }

        var cache_results = attach_stats_from_cache(content_id);
        res_hash['share_of_voice'] = cache_results['share_of_voice'];
        res_hash['viewership'] = cache_results['viewership'];
        res_hash['total_impressions'] = cache_results['total_impressions'];

        res_list.push(res_hash);
      }
      connection.end();
      //run another query to get ad_airings and then ad_views
      callback(null, res_list, httpres);
    });
}

function query_and_attach_uniq_shows(res_hash, httpres, callback) {
  //get list of content_ids
  var combined_res_hash = res_hash;
  var content_id = combined_res_hash['content_id'];

  var params = [];
  params.push(content_id);

  var connection = getConnection("dashboard");
  var query;
  query = 'SELECT content_id, count AS uniq_show_cnt FROM cache_ad_show_count WHERE content_id IN(?)';
  //console.log('DBG query:' + query);
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        combined_res_hash['uniq_show_cnt'] = res[i].uniq_show_cnt;
      }
      connection.end();
      callback(null, combined_res_hash, httpres);
      //if (httpres) {
      //   httpres.send(JSON.stringify(combined_res_hash, "", 2));
      // } else {
      //    console.log ('DBG combined_res_hash:' + JSON.stringify(combined_res_hash, "", 2) );
      // }
    });
}

function query_and_attach_uniq_shows_for_list(res_list, httpres, callback) {
  //get list of content_ids
  var params = [];
  for (var i = 0; i < res_list.length; i++) {
    var item = res_list[i];
    var content_id = item['content_id'];
    params.push(content_id);
  }

  var connection = getConnection("dashboard");
  var query;
  query = 'SELECT content_id, count AS uniq_show_cnt FROM cache_ad_show_count WHERE content_id IN(?)';
  //console.log ('DBG query:' + query);
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        var res_hash = {};
        res_hash['uniq_show_cnt'] = res[i].uniq_show_cnt;
        all_res_hash[res[i].content_id] = res_hash;
      }

      // repackage the brand query results adding ad_airing and impressions
      var modified_res_list = [];
      for (var i = 0; i < res_list.length; i++) {
        var item = res_list[i];
        var content_id = item['content_id'];
        if (all_res_hash.hasOwnProperty(content_id)) {
          item['uniq_show_cnt'] = all_res_hash[content_id]['uniq_show_cnt'];
        }
        modified_res_list.push(item);
      }
      connection.end();
      callback(null, modified_res_list, httpres);
      //if (httpres) {
      //   httpres.send(JSON.stringify(modified_res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(modified_res_list, "", 2) );
      //}
    });
}

function query_and_attach_uniq_network_for_list(res_list, httpres, callback) {
  //get list of content_ids
  var params = [];
  for (var i = 0; i < res_list.length; i++) {
    var item = res_list[i];
    var content_id = item['content_id'];
    params.push(content_id);
  }

  var connection = getConnection("dashboard");
  var query;
  query = 'SELECT content_id, count AS uniq_network_cnt FROM cache_ad_network_count WHERE content_id IN(?)';
  //console.log ('DBG query:' + query);
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        var res_hash = {};
        res_hash['uniq_network_cnt'] = res[i].uniq_network_cnt;
        all_res_hash[res[i].content_id] = res_hash;
      }

      // repackage the brand query results adding ad_airing and impressions
      var modified_res_list = [];
      for (var i = 0; i < res_list.length; i++) {
        var item = res_list[i];
        var content_id = item['content_id'];
        if (all_res_hash.hasOwnProperty(content_id)) {
          item['uniq_network_cnt'] = all_res_hash[content_id]['uniq_network_cnt'];
        }
        modified_res_list.push(item);
      }
      connection.end();
      callback(null, modified_res_list, httpres);
      //console.log ('DBG modified_res_list:' , modified_res_list );
      //if (httpres) {
      //   httpres.send(JSON.stringify(modified_res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(modified_res_list, "", 2) );
      //}
    });
}

function query_and_attach_ad_spend_for_list(res_list, httpres, callback) {
  //get list of content_ids
  var params = [];
  for (var i = 0; i < res_list.length; i++) {
    var item = res_list[i];
    var content_id = item['content_id'];
    params.push(content_id);
  }

  var connection = getConnection("dashboard");
  var query;
  query = 'select content_id,sum(total_spend) as ad_spend from cache_ad_spend where content_id IN(?)  group by content_id;';
  //console.log ('DBG query:' + query);
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        var res_hash = {};
        res_hash['total_spend'] = res[i].ad_spend;
        all_res_hash[res[i].content_id] = res_hash;
      }

      // repackage the brand query results adding ad_airing and impressions
      var modified_res_list = [];
      for (var i = 0; i < res_list.length; i++) {
        var item = res_list[i];
        var content_id = item['content_id'];
        if (all_res_hash.hasOwnProperty(content_id)) {
          item['total_spend'] = all_res_hash[content_id]['total_spend'];
        }
        modified_res_list.push(item);
      }
      connection.end();
      //console.log ('DBG modified_res_list:' , modified_res_list );
      if (httpres) {
        httpres.send(JSON.stringify(modified_res_list, "", 2));
      } else {
        console.log('DBG res_list:' + JSON.stringify(modified_res_list, "", 2));
      }
      callback(null, res_list, httpres);
    });
}

function query_and_attach_ad_spend(res_hash, httpres, callback) {
  //get list of content_ids
  var combined_res_hash = res_hash;
  var content_id = combined_res_hash['content_id'];

  var params = [];
  params.push(content_id);

  var connection = getConnection("dashboard");
  var query;
  query = 'select content_id,sum(total_spend) as ad_spend from cache_ad_spend where content_id IN(?)  group by content_id;';
  //console.log ('DBG query:' + query);
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        combined_res_hash['total_spend'] = res[i].ad_spend;
      }
      connection.end();
      //console.log ('DBG modified_res_list:' , modified_res_list );
      if (httpres) {
        httpres.send(JSON.stringify(combined_res_hash, "", 2));
      } else {
        console.log('DBG combined_res_hash:' + JSON.stringify(combined_res_hash, "", 2));
      }
    });
}

function query_and_attach_uniq_network(res_hash, httpres, callback) {
  //get list of content_ids
  var combined_res_hash = res_hash;
  var content_id = combined_res_hash['content_id'];

  var connection = getConnection("dashboard");
  var query;
  query = 'SELECT count AS uniq_network_cnt FROM cache_ad_network_count WHERE content_id=?';
  //console.log ('DBG query:' + query);
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        combined_res_hash['uniq_network_cnt'] = res[i].uniq_network_cnt;
      }
      connection.end();
      callback(null, combined_res_hash, httpres);
      //console.log ('DBG modified_res_list:' , modified_res_list );
      //if (httpres) {
      //   httpres.send(JSON.stringify(combined_res_hash, "", 2));
      // } else {
      //    console.log ('DBG combined_res_hash:' + JSON.stringify(combined_res_hash, "", 2) );
      //}
    });
}

function query_and_attach_stats(res_list, httpres, callback) {
  //get list of content_ids
  var params = [];
  for (var i = 0; i < res_list.length; i++) {
    var item = res_list[i];
    var content_id = item['content_id'];
    params.push(content_id);
  }

  var connection = getConnection("dashboard");
  var query;
   //query = 'select cache_ad_airings.content_id,SUM(cache_ad_airings.count) as total_airings, SUM(ad_views.impressions) as total_impressions from cache_ad_airings, ad_views where cache_ad_airings.content_id=ad_views.content_id and cache_ad_airings.content_id IN(' + params.join(',') + ') group by cache_ad_airings.content_id;';
  query = 'select cache_ad_airings.content_id,SUM(cache_ad_airings.count) as total_airings from cache_ad_airings where cache_ad_airings.content_id IN (?) group by cache_ad_airings.content_id;';
  connection.query(query, [params],
    function(err, res, fields) {
      if (err) throw err;
      var all_res_hash = {};
      for (var i = 0; i < res.length; i++) {
        var res_hash = {};
        res_hash['id'] = res[i].content_id;
        res_hash['total_airings'] = res[i].total_airings;
        all_res_hash[res[i].content_id] = res_hash;
      }
      connection.end();
      // repackage the brand query results adding ad_airing and impressions
      var modified_res_list = [];
      for (var i = 0; i < res_list.length; i++) {
        var item = res_list[i];
        var content_id = item['content_id'];
        if (all_res_hash.hasOwnProperty(content_id)) {
          item['total_airings'] = all_res_hash[content_id]['total_airings'];
        }
        modified_res_list.push(item);
      }
      callback(null, modified_res_list, httpres);
      //console.log ('DBG modified_res_list:' , modified_res_list );
      //if (httpres) {
      //   httpres.send(JSON.stringify(modified_res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(modified_res_list, "", 2) );
      //}
    });
}

function query_list_brands(httpres, callback) {
  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
  //query = 'select distinct(content.product_id) as brand_id,product.brand as name from product,content where content.product_id=product.id order by name;';
  query = 'select distinct(brands.name) as name ,brands.id as brand_id  from brands,product,content,cache_ad_airings where content.product_id=product.id and product.brand_id=brands.id and cache_ad_airings.content_id=content.id group by brands.name order by name;';
  //console.log ('DBG qury:' + query );
  connection.query(query,
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        res_hash['brand_id'] = res[i].brand_id;
        res_hash['name'] = res[i].name;
        res_list.push(res_hash);
      }
      connection.end();
      if (httpres) {
        httpres.send(JSON.stringify(res_list, "", 2));
      } else {
        console.log('DBG res_list:' + JSON.stringify(res_list, "", 2));
      }
    });
    callback(null, httpres);
}

function query_content_by_category(cat_name, httpres, callback) {

  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
   //query = 'select  content.id as content_id, title, type, duration, brands.name as brand,categories.name as category, brands.id as brand_id from content,product,brands,categories, cache_ad_airings  where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id  and content.id=cache_ad_airings.content_id and categories.name="' + cat_name + '" group by content.id limit 500;';
  query = 'select content.id as content_id, title, type, duration, brands.name as brand,categories.name as category, brands.id as brand_id from content,product,brands,categories,cache_ad_airings  where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id and cache_ad_airings.content_id=content.id  and categories.name=? group by content.id limit 500';

  connection.query(query, [cat_name],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        //res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id  + '.jpg';
        if (res[i].title ) {
           res_hash['thumbnail'] = format_poster_url(content_id);
           res_hash['poster'] = format_poster_url(content_id);
           res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        //res_hash['total_spend'] = 120000;
        //res_hash['total_airings'] = res[i].total_airings;
        var cache_results = attach_stats_from_cache(content_id);
        res_hash['share_of_voice'] = cache_results['share_of_voice'];
        res_hash['viewership'] = cache_results['viewership'];
        res_hash['total_impressions'] = cache_results['total_impressions'];
        res_list.push(res_hash);
      }
      connection.end();
      //run another query to get ad_airings and then ad_views
      if (res_list.length > 0) {
        callback(null, res_list, httpres);
      } else {
        console.log('DBG no match for category query str:' + cat_name);
        httpres.send(JSON.stringify(res_list, "", 2));
      }
      //if (httpres) {
      //   httpres.send(JSON.stringify(res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(res_list, "", 2) );
      //}
    });
}

function query_content_by_brand(brand_id, httpres, callback) {
  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
  query = 'select content.id as content_id, title, type, duration, brands.name as brand, categories.name as category, brands.id as brand_id from content,product,brands,categories  where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id  and brands.id=? limit 500';
  //console.log ('DBG qury:' + query );
  connection.query(query, [brand_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        //res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id  + '.jpg';
        if (res[i].title ) {
           res_hash['poster'] = format_poster_url(content_id);
           res_hash['thumbnail'] = format_poster_url(content_id);
           res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        //from cache
        var cache_results = attach_stats_from_cache(content_id);
        res_hash['share_of_voice'] = cache_results['share_of_voice'];
        res_hash['viewership'] = cache_results['viewership'];
        res_hash['total_impressions'] = cache_results['total_impressions'];
        //res_hash['total_spend'] = 120000;
        //res_hash['total_airings'] = res[i].total_airings;
        res_list.push(res_hash);
      }
      connection.end();
      callback(null, res_list, httpres);
      //if (httpres) {
      //   httpres.send(JSON.stringify(res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(res_list, "", 2) );
      //}
    });
}

function query_content_by_brand_id(brand_id, httpres, callback) {
  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
  query = 'select brands.name as brand from brands where  brands.id=? limit 1';
  //console.log ('DBG qury:' + query );
  var brand_name = "";
  connection.query(query, [brand_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        brand_name = res[i].brand;
      }
      connection.end();
      if (brand_name == "") {
        //return empty
        httpres.send(JSON.stringify([], "", 2));
      }
      callback(null, brand_name, httpres);
    });
}

function query_content_by_brand_name(brand_name, httpres, callback) {
  var res_list = [];
  var connection = getConnection("dashboard");
  var query;
  query = 'select content.id as content_id, title, type, duration,brands.name as brand,categories.name as category, brands.id as brand_id from content,product,brands,categories,cache_ad_airings  where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id and cache_ad_airings.content_id=content.id  and brands.name=? group by content.id limit 500';
  //console.log ('DBG1 qury:' + query );
  connection.query(query, [brand_name],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        //res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id  + '.jpg';
        if (res[i].title ) {
        res_hash['thumbnail'] = format_poster_url(content_id);
        res_hash['poster'] = format_poster_url(content_id);
        res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        //res_hash['total_spend'] = 120000;
        //res_hash['total_airings'] = res[i].total_airings;
        var cache_results = attach_stats_from_cache(content_id);
        res_hash['share_of_voice'] = cache_results['share_of_voice'];
        res_hash['viewership'] = cache_results['viewership'];
        res_hash['total_impressions'] = cache_results['total_impressions'];
        res_list.push(res_hash);
      }
      connection.end();
      callback(null, res_list, httpres);
      //if (httpres) {
      //   httpres.send(JSON.stringify(res_list, "", 2));
      //} else {
      //   console.log ('DBG res_list:' + JSON.stringify(res_list, "", 2) );
      //}
    });
}


function query_raw_similar_by_id(content_id, httpres, callback) {
  var res_list = [];

  var connection = getConnection("dashboard");
  var query;
  query = 'select content_all.id as content_id, title, type, duration, brands.name as brand, categories.name as category, brands.id as brand_id from content_all,product,brands,categories  where content_all.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id  and content_all.id IN (select content_id from content_similar where group_id IN (select group_id from content_similar where content_id=? ));  ';
  //console.log ('DBG query:' + query);
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        //res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id  + '.jpg';
        if (res[i].title ) {
        res_hash['poster'] = format_poster_url(content_id);
        res_hash['thumbnail'] = format_poster_url(content_id);
        res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        res_list.push(res_hash);
      }
      connection.end();

      //send response
      httpres.send(JSON.stringify(res_list, "", 2));

      callback();
    });
}


function query_similar_by_id(content_id, httpres, callback) {
  var res_list = [];

  var connection = getConnection("dashboard");
  var query;
  //query = 'select content_id from content_similar where group_id IN (select group_id from content_similar where content_id= ' + content_id  + ') ; ';
  query = 'select content.id as content_id, title, type, duration, brands.name as brand, categories.name as category, brands.id as brand_id from content,product,brands,categories  where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id  and content.id IN (select content_id from content_similar where group_id IN (select group_id from content_similar where content_id=? ));  ';
  //console.log ('DBG query:' + query);
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        var res_hash = {};
        var content_id = res[i].content_id;
        res_hash['id'] = res[i].content_id;
        res_hash['content_id'] = res[i].content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        //res_hash['thumbnail'] = 'http://assets.alphonso.tv/advt_db/' + content_id  + '.jpg';
        if (res[i].title ) {
           res_hash['poster'] = format_poster_url(content_id);
           res_hash['thumbnail'] = format_poster_url(content_id);
           res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        res_list.push(res_hash);
      }
      connection.end();
      //jz1
      if (httpres) {
        httpres.send(JSON.stringify(res_list, "", 2));
      } else {
        console.log('DBG res_hash:' + JSON.stringify(res_list, "", 2));
      }
      callback();
    });
}



function query_content_by_id(content_id, httpres, callback) {
  var res_hash = {};
  res_hash['id'] = content_id;

  var connection = getConnection("dashboard");
  var query;
  query = 'select content.id, title, type, duration,brands.name as brand,categories.name as category,brands.id as brand_id, SUM(cache_ad_airings.count) as total_airings from content,product,brands,categories,cache_ad_airings where content.product_id=product.id and product.brand_id=brands.id and product.category_id=categories.id  and content.id=cache_ad_airings.content_id  and  content.id=?';
  //console.log ('DBG query:' + query );
  connection.query(query, [content_id],
    function(err, res, fields) {
      if (err) throw err;
      for (var i = 0; i < res.length; i++) {
        //console.log ('DBG i:' + i + ' res i:' , res[i] );
        res_hash['content_id'] = content_id;
        res_hash['title'] = res[i].title;
        res_hash['brand'] = res[i].brand;
        res_hash['brand_id'] = res[i].brand_id;
        res_hash['duration'] = res[i].duration;
        var category = res[i].category;
        if (category == "name") {
          category = "";
        }
        res_hash['category'] = category;
        res_hash['brand_id'] = res[i].brand_id;
        if (res[i].title ) {
           res_hash['poster'] = format_poster_url(content_id);
           res_hash['thumbnail'] = format_poster_url(content_id);
           res_hash['mp4_clip'] = format_mp4_url(content_id);
        }
        res_hash['total_airings'] = res[i].total_airings;
        var cache_results = attach_stats_from_cache(content_id);
        //console.log ('DBG cache_results:', cache_results);
        res_hash['share_of_voice'] = cache_results['share_of_voice'];
        res_hash['viewership'] = cache_results['viewership'];
        res_hash['total_impressions'] = cache_results['total_impressions'];
      }
      connection.end();
      callback(null, res_hash, httpres);
      //if (httpres) {
      //   httpres.send(JSON.stringify(res_hash, "", 2));
      //} else {
      //   console.log ('DBG res_hash:' + JSON.stringify(res_hash, "", 2) );
      //}
    });
}

function util_func1(input) {
  console.log('> util_func1, input:' + input);
  return ("output1");
}

module.exports = {
  query_content_by_id: function(content_id, httpres) {
    async.waterfall([
      async.apply(query_content_by_id, content_id, httpres),
      query_and_attach_uniq_shows,
      query_and_attach_uniq_network,
      query_and_attach_ad_spend,
    ]);
  },
  query_raw_similar_by_id: function(content_id, httpres) {
    async.waterfall([
      async.apply(query_raw_similar_by_id, content_id, httpres),
    ]);
  },
  query_similar_by_id: function(content_id, httpres) {
    async.waterfall([
      async.apply(query_similar_by_id, content_id, httpres),
    ]);
  },
  query_share_of_voice_by_id: function(content_id, httpres) {
    async.waterfall([
      async.apply(query_share_of_voice_by_id, content_id, httpres),
      query_and_attach_group_stats,
    ]);
  },
  query_content_by_brand: function(brand_id, httpres) {
    async.waterfall([
      async.apply(query_content_by_brand, brand_id, httpres),
      query_and_attach_stats,
      query_and_attach_uniq_shows_for_list,
      query_and_attach_uniq_network_for_list,
      query_and_attach_ad_spend_for_list,
    ]);
  },
  query_content_by_brand_id: function(brand_id, httpres) {
    async.waterfall([
      async.apply(query_content_by_brand_id, brand_id, httpres),
      query_content_by_brand_name,
      query_and_attach_stats,
      query_and_attach_uniq_shows_for_list,
      query_and_attach_uniq_network_for_list,
      query_and_attach_ad_spend_for_list,
    ]);
  },
  query_content_by_brand_name: function(brand_name, httpres) {
    async.waterfall([
      async.apply(query_content_by_brand_name, brand_name, httpres),
      query_and_attach_stats,
      query_and_attach_uniq_shows_for_list,
      query_and_attach_uniq_network_for_list,      query_and_attach_ad_spend_for_list,
    ]);
  },
  query_content_by_category: function(cat_name, httpres) {
    async.waterfall([
      async.apply(query_content_by_category, cat_name, httpres),
      query_and_attach_stats,
      query_and_attach_uniq_shows_for_list,
      query_and_attach_uniq_network_for_list,
      query_and_attach_ad_spend_for_list,
    ]);
  },
  query_list_brands: function(httpres) {
    async.waterfall([
      async.apply(query_list_brands, httpres),
    ]);
  },
  query_featured: function(httpres) {
    async.waterfall([
      async.apply(query_featured, httpres),
      query_and_attach_stats,
      query_and_attach_uniq_shows_for_list,
      query_and_attach_uniq_network_for_list,
      query_and_attach_ad_spend_for_list,
    ]);
  },
  util_func1: util_func1
}
