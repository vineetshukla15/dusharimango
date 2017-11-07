
function get_airing_stats_by_item(id,air_time, duration, viewership)
{
   //load the viewership data
   var viewershipMultiplier = 12024;
   var sb_viewership_tbl = "/home/joez/superbowl_2016/cbs_viewership.tbl";
   var fs = require("fs");
   var filedata = fs.readFileSync(sb_viewership_tbl);
   var viewershipTable = JSON.parse(filedata);

  //
  var this_ad_stats = [];
  var ad_start_datetime = new Date (air_time );
  var ad_duration = duration;
  var no_units = Math.ceil(ad_duration /10000);
  var coeff = 1000 * 10 * 1;
  var rounded = new Date(Math.floor(ad_start_datetime.getTime() /coeff) * coeff);
   var key1 = rounded.toISOString();

  for (i = 0 ; i <= no_units ; i ++ ) {
     var date1 = new Date (rounded.getTime() + i * 10 * 1000); // increment by 10 sec
     key1 = date1.toISOString();
     if ( viewershipTable.hasOwnProperty(key1) ) {
        var this_rec = {};
        this_rec[key1] = viewershipMultiplier * viewershipTable[key1];
        this_ad_stats.push(this_rec);
     }
  }
 // add a default point handler
  if ( this_ad_stats.length == 0 ) {
     var this_rec = {};
     key1 = rounded.toISOString();
     this_rec[key1] = viewership;
     this_ad_stats.push(this_rec);
  }

  return (this_ad_stats);
}




function get_url_args (req_url)
{
   var results = {};
   if (!req_url) return results;

   var splits = req_url.split("?");
   if (splits.length < 2 ) {
      return results;
   }

   var key_vals = splits[1].split("&");
   for (var i=0; i< key_vals.length; i++) {
       var kvs = key_vals[i].split("=");
       var key = kvs[0];
       var val = kvs[1];
       results[key] = val;
   }
   //console.log ('DBG results:' , results);
   return results;

}

function get_reports_ad_airing(url, res)
{
   
  var db_funcs = require ("./ad_airing_api_handler.js");
  db_funcs.query_latest_ad_airing(url, res);
}

//main
var server_port  = parseInt(process.argv[2]);
if (!server_port ) {
   server_port =  8000;
}

//console.log ('DBG server_port:' + server_port);

var cluster = require('cluster');
if (cluster.isMaster) {
  var numWorkers  = 5;
  // Fork workers.
  for (var i = 0; i < numWorkers ; i++) {
    cluster.fork();
  }

  cluster.on('online', function(worker) {
     console.log('Worker ' + worker.process.pid + ' is online');
  });

  cluster.on('exit', function(worker, code, signal) {
     console.log('Worker ' + worker.process.pid + ' died with code: ' + code + ', and signal: ' + signal);
     console.log('Starting a new worker');
     cluster.fork();
  });


} else { // logic for the app child process

var express = require('express');
var bodyParser = require('body-parser')

var app = express();

// create application/json parser
var jsonParser = bodyParser.json()

// create application/x-www-form-urlencoded parser
var urlencodedParser = bodyParser.urlencoded({ extended: false })


var basicAuth = require('basic-auth');

var auth = function (req, res, next) {
  function unauthorized(res) {
    res.set('WWW-Authenticate', 'Basic realm=Authorization Required');
    return res.sendStatus(401);
  };

  var user = basicAuth(req);

  if (!user || !user.name || !user.pass) {
    return unauthorized(res);
  };

  if (user.name === 'alpha' && user.pass === '@Lph0ns0') {
    return next();
  } else {
    return unauthorized(res);
  };
};



app.get('/', auth, function (req, res) {
  res.send('Hello World!');
});

app.get('/edit_campaign', function (req, res) {
  //res.send('Hello World!');
  res.render('edit_campaign.jade', { campaign_id: req.query.campaign_id, message: 'Hello there!'});
});

app.get('/fh1_views_new', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var fh1_views_new = fs.readFileSync('public/fh1_views_new.json', 'utf8');
  //console.log (' called fh1_views_new');
  res.send(fh1_views_new);

});

app.get('/fh1_views_head', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var fh1_views_head = fs.readFileSync('public/fh1_views_new_head.json', 'utf8');
  res.send(fh1_views_head);

});

app.get('/fh_views_head', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var fh1_views_head = fs.readFileSync('public/ravi_filtered_fh_head.json', 'utf8');
  res.send(fh1_views_head);

});

app.get('/fh_views_new', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var fh1_views_new = fs.readFileSync('public/ravi_filtered_fh_new.json', 'utf8');
  //console.log (' called fh1_views_new');
  res.send(fh1_views_new);

});

app.get('/reports_content_airing', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var fh1_views_head = fs.readFileSync('public/reports_content_airing.json', 'utf8');
  res.send(fh1_views_head);

});

app.get('/ad_airings', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  //console.log ('req:' , req.url);
  get_reports_ad_airing(req.url, res);

});

// new dashboard api
app.get('/dashapi/content_by_id', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_content_by_id(id, res);

});

app.get('/dashapi/raw_similar_by_id', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_raw_similar_by_id(id, res);

});

app.get('/dashapi/similar_by_id', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_similar_by_id(id, res);

});

app.get('/dashapi/share_of_voice_by_id', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_share_of_voice_by_id(id, res);

});

app.get('/dashapi/featured_content',auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  //var fs = require('fs');
  //var sb_ad_airings = fs.readFileSync('public/dashapi_featured_content.json', 'utf8');
  //res.send(sb_ad_airings);
  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_featured(res);


});

app.get('/dashapi/list_brands', auth,  function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  //var fs = require('fs');
  //var sb_ad_airings = fs.readFileSync('public/list_brands.json', 'utf8');
  //res.send(sb_ad_airings);

  var db_funcs = require ("./dashboard_api_handlers.js");
  db_funcs.query_list_brands(res);


});

app.get('/dashapi/hack_content_to_show_network_counts', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var mapping = fs.readFileSync('public/content_id-show-networ-count-map.json', 'utf8');
  res.send(mapping);

});

app.get('/dashapi/list_content_by_brand', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var brand_name = unescape(url_args['brand_name']);
  
  var db_funcs = require ("./dashboard_api_handlers.js");
  if (brand_name != 'undefined' &&  brand_name != null) {
     db_funcs.query_content_by_brand_name(brand_name, res);
  } else {
     db_funcs.query_content_by_brand_id(id, res);
  }


});

app.get('/dashapi/list_content_by_category', auth, function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var req_url = req.url;
  var url_args = get_url_args(req_url);
  //var flush_cache = url_args.hasOwnProperty('flush_cache') ? 1 : 0;
  var cache_key = url_args['category_name'];
  var category_name = unescape(url_args['category_name']);

  var fs = require('fs');
  var cache_file = 'public/cache-dir/' + cache_key + '.json';
  try {
     //console.log ('DBG reading cache_file:' + cache_file);
     var cache_result = fs.readFileSync(cache_file, 'utf8');
     res.send(cache_result);
  } catch (err) {
     var db_funcs = require ("./dashboard_api_handlers.js");
     db_funcs.query_content_by_category(category_name, res);
  }

});

// end new dash
app.get('/sb16_traffic_stats', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var sb_ad_airings = fs.readFileSync('public/sb16_traffic_stats.json', 'utf8');
  res.send(sb_ad_airings);

});

app.get('/sb_traffic_stats', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var sb_ad_airings = fs.readFileSync('public/sb_traffic_stats.json', 'utf8');
  res.send(sb_ad_airings);

});

app.get('/sb16_stats_by_id', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var air_time = url_args['air_time'];
  var duration = url_args['duration'];
  var viewership = url_args['viewership'];

   var this_ad_stats = [];
   if (air_time && duration && id && viewership ) {
      console.log ('DBG air_time:' + air_time );
      this_ad_stats = get_airing_stats_by_item(id,air_time,duration, viewership);
   }
  res.send(JSON.stringify(this_ad_stats, "", 2));
});

app.get('/sb_stats_by_id', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');

  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var id = url_args['id'];
  var air_time = url_args['air_time'];
  var duration = url_args['duration'];
  var viewership = url_args['viewership'];

   var this_ad_stats = [];
   if (air_time && duration && id && viewership ) {
      console.log ('DBG air_time:' + air_time );
      this_ad_stats = get_airing_stats_by_item(id,air_time,duration, viewership);
   }
  res.send(JSON.stringify(this_ad_stats, "", 2));
});


app.get('/sb16_ad_airings', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var initial = url_args['initial'];
  var incremental = url_args['incremental'];

  var fs = require('fs');
  var cache_file = "public/sb16_cbs_ad_airing_new.json";
  if ( initial == 1 || incremental ==1 ) {
     cache_file = "public/sb16_cbs_ad_airing_short_new.json";
  }
  var sb_ad_airings = fs.readFileSync(cache_file, 'utf8');
  res.send(sb_ad_airings);
  //sb16_cbs_ad_airing_short_new.json

});

app.get('/sb_ad_airings', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var req_url = req.url;
  var url_args = get_url_args(req_url);
  var initial = url_args['initial'];
  var incremental = url_args['incremental'];

  var fs = require('fs');
  var cache_file = "public/sb_cbs_ad_airing_new.json";
  if ( initial == 1 || incremental ==1 ) {
     cache_file = "public/sb_cbs_ad_airing_short_new.json";
  }
  var sb_ad_airings = fs.readFileSync(cache_file, 'utf8');
  res.send(sb_ad_airings);
  //sb16_cbs_ad_airing_short_new.json

});

app.get('/sb15_traffic_stats', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var sb_ad_airings = fs.readFileSync('public/sb15_traffic_stats.json', 'utf8');
  res.send(sb_ad_airings);

});

app.get('/sb15_ad_airings', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var sb_ad_airings = fs.readFileSync('public/2015_ad_airing_archive.json', 'utf8');
  res.send(sb_ad_airings);

});

app.get('/list_brands', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var list_brands = fs.readFileSync('public/list_brands.json', 'utf8');
  res.send(list_brands);

});

app.get('/list_stations', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var list_stations = fs.readFileSync('public/list_stations.json', 'utf8');
  res.send(list_stations);

});

app.get('/superbowl15_ads', function (req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader('content-type', 'application/json');
  var fs = require('fs');
  var list_stations = fs.readFileSync('public/superbowl15_ads.json', 'utf8');
  res.send(list_stations);

});



app.set('view engine', 'jade');

app.use(express.static(__dirname + '/public'));
var logger = require('express-logger');
app.use(logger({path: "./access.log"}));



//app.use(express.static(__dirname + '/../../react/react-0.13.3'));

var server = app.listen(server_port, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('app listening at http://%s:%s', host, port);
});

} // end else - logic for the app child process
