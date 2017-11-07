var config = require('./app-config');

/* log4j module */
var log4js = require('log4js');
// This call will replace the console.log to a log4j logging
log4js.replaceConsole();

/*
    Ref: http://rowanmanning.com/posts/node-cluster-and-express/
        https://nodejs.org/api/cluster.html
        http://expressjs.com/en/4x/api.html
*/
/*var cluster = require('cluster');

if (cluster.isMaster) {
    // In real life, you'd probably use more than just 2 workers,
    // and perhaps not put the master and worker in the same file.
    //
    // You can also of course get a bit fancier about logging, and
    // implement whatever custom logic you need to prevent DoS
    // attacks and other bad behavior.
    //
    // See the options in the cluster documentation.
    //
    // The important thing is that the master does very little,
    // increasing our resilience to unexpected errors.

    cluster.fork();
    cluster.fork();

    // Listen for dying workers
    cluster.on('exit', function(worker, code, signal) {

        // Replace the dead worker,
        // we're not sentimental
        console.log('Worker %d died :( will create new worker.', worker.id);
        cluster.fork();

    });

} else {*/

// init express module
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

// set the view engine to ejs
app.set('view engine', 'ejs');

// init request module for backend http API calls
var request = require("request");

app.use(express.static('static'));

function getRequestURL(url) {
    return config.backendapiurl + url;
}

function logUserAction (url, req, isPostReq)
{
    if (!isPostReq)
        console.log("USER ACTION " + url + " | " + JSON.stringify(req.query) + " | " + getIPString(req));
    else
        console.log("USER ACTION " + url + " | " + JSON.stringify(req.body) + " | " + getIPString(req));
}

function getIPString (req) {
    return req.headers['x-forwarded-for'] + ' / ' + 
           req.connection.remoteAddress + ' / ' + 
           req.socket.remoteAddress + ' / ' + 
           //req.connection.socket.remoteAddress + ' / ' + 
           req.ip;
}

app.get('/hb', function (req, res){ // heartbeat
    console.log('request received: ' + JSON.stringify(req.query));
    var queryStr = "select 'success' as status from dual";
    console.log(queryStr);
    handle_database(queryStr, res);
});

app.get('/ad_brand_network', function (req, res) {
    logUserAction("/ad_brand_network", req);
    //handle_database(res, get_ad_brand_network_query (req));
    execute_ad_brand_network_query (req, res, handle_database);
});


app.get('/ad_brand_network_show', function (req, res) {
    logUserAction("/ad_brand_network_show", req);
    //handle_database(res, get_ad_brand_network_show_query (req));
    execute_ad_brand_network_show_query (req, res, handle_database);
});

app.get('/brand_network', function (req, res) {
    logUserAction("/brand_network", req);
    handle_database(get_brand_network_query (req), res);
});

app.get('/brand_network_show', function (req, res) {
    logUserAction("/brand_network_show", req);
    handle_database(get_brand_network_show_query (req), res);
});

app.get('/ad_viewer', function (req, res) {

        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/ad_viewer', req);
        var reqQ = req.query;

        var brand = (typeof reqQ.paramB === 'undefined'? '':reqQ.paramB.replace(/'/g, "\\'"));
        //var ad_title = (typeof reqQ.paramAdTitle === 'undefined'? '':reqQ.paramAdTitle.replace(/'/g, "\\'"));
        var content_id = (typeof reqQ.contentId === 'undefined'? '': reqQ.contentId);

        var queryStr = 'select lat, lng, sum(viewers) as vws from content_viewers ' + 
                        'where content_id = ' + content_id + ' and ' +
                              'airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                        'group by lat, lng';
        console.log(queryStr);
        handle_database(queryStr, res);
});

app.get('/brand_viewer', function (req, res) {

        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/brand_viewer', req);
        var reqQ = req.query;

        var brand_id = (typeof reqQ.paramB === 'undefined'? '':reqQ.paramB);
        
        var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
        var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
        var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
        var qryCriteria = "brand_id = " + brand_id + " ";
        if (onlyCoOp) qryCriteria = "coop_brand_id = " + brand_id + " ";
        else if (includeCoOp) qryCriteria = "(" + qryCriteria + "or coop_brand_id = " + brand_id + ") ";
        else if (specificCoOp) qryCriteria = "((brand_id = " + brand_id + " and coop_brand_id = " + reqQ.paramCO + ") or (coop_brand_id = " + brand_id + " and brand_id = " + reqQ.paramCO + ")) ";

        var queryStr = 'select lat, lng, sum(viewers) as vws from brand_viewers ' +
                        'where ' + qryCriteria + ' and ' +
                              'airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                        'group by lat, lng';
        console.log(queryStr);
        handle_database(queryStr, res);
});

app.get('/brand_spend', function (req, res) {
    /*var data = [{
        "brand": "brand1",
        "spend": "202"
        }, {
        "brand": "brand2",
        "spend": "215"
        }];*/
    //console.log('request received: ' + JSON.stringify(req.query));
    logUserAction('/brand_spend', req);
    var reqQ = req.query;
    /*
    select brand, sum(spend) as spend
    from brand_network
    where brand in ('Ford', 'Toyota')
    and airing_date between Date('2015-06-01') and Date('2015-06-30')
    group by brand;
    */
    //var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
    //var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
    var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
    //var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
    var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
    //var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
    var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
    //var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
    var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
    //var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
    var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);

    //var brands = [brand1, brand2, brand3, brand4, brand5, brand6];
    var brands = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
    var numBrands = 0;
    var brandAggrInStr = '';
    for (brandIdx in brands) {
        var brand = brands[brandIdx];
        
        if (brand == '') break;
        
        numBrands++; // add to the number of Brands in the request query
        if (numBrands > 1) // add a comma from 2nd brands onwards
                brandAggrInStr = brandAggrInStr + ', ';
        brandAggrInStr = brandAggrInStr + brand;
    }
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id in (' + brandAggrInStr + ') ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id in (' + brandAggrInStr + ') ';
    else if (includeCoOp) qryCriteria = '(brand_id = ' + brand_id1 + ' or coop_brand_id = ' + brand_id1 + ') ';
    else if (specificCoOp) qryCriteria = '((brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select brand_name as brand, sum(spend) as spend ';
    if (onlyCoOp) queryStr = 'select coop_brand_name as brand, sum(spend) as spend ';
    //else if (includeCoOp) queryStr = 'select (CASE WHEN(brand_id = ' + brand_id1 + ')THEN brand_name ELSE coop_brand_name END) as brand, sum(spend) as spend ';
    else if (specificCoOp) queryStr = 'select (CASE WHEN(brand_id in (' + brandAggrInStr + '))THEN brand_name ELSE coop_brand_name END) as brand, sum(spend) as spend ';

    queryStr = queryStr + 'from brand_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by brand';
    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/brand_coop_airings', function (req, res) {
    logUserAction('/brand_coop_airings', req);
    var reqQ = req.query;

    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
        
    var qryCriteria = '(brand_id = ' + brand_id1 + ' or coop_brand_id = ' + brand_id1 + ') ';
    
    var queryStr = 'select brand_name as brand, sum(airings) as airings ';
    
    queryStr = queryStr + 'from brand_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by brand';
    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/product_coop_airings', function (req, res) {
    logUserAction('/product_coop_airings', req);
    var reqQ = req.query;
    
    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    //else if (specificCoOp) qryCriteria = '(' + qryCriteria + 'or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    else if (specificCoOp) qryCriteria = '((brand_id = ' + brand_id1 + ' and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select product_name as product, brand_name as brand, sum(airings) as airings ';
    if (onlyCoOp) queryStr = 'select coop_product_name as product, brand_name as brand, sum(airings) as airings ';
    else if (includeCoOp || specificCoOp) queryStr = 'select (CASE WHEN(brand_id = ' + brand_id1 + ')THEN product_name ELSE coop_product_name END) as product, brand_name as brand, sum(airings) as airings ';
        
    queryStr = queryStr + 'from product_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by brand, product order by sum(airings) desc';
    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/content_coop_airings', function (req, res) {
    logUserAction('/content_coop_airings', req);
    var reqQ = req.query;
    
    //var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
    //var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
    var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
    //var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
    var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
    //var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
    var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
    //var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
    var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
    //var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
    var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);

    //var brands = [brand1, brand2, brand3, brand4, brand5, brand6];
    var brands = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
    var numBrands = 0;
    var brandAggrInStr = '';
    for (brandIdx in brands) {
        var brand = brands[brandIdx];
        
        if (brand == '') break;
        
        numBrands++; // add to the number of Brands in the request query
        if (numBrands > 1) // add a comma from 2nd brands onwards
            brandAggrInStr = brandAggrInStr + ', ';
        brandAggrInStr = brandAggrInStr + brand;
    }
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id in (' + brandAggrInStr + ') ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(brand_id = ' + brand_id1 + ' or coop_brand_id = ' + brand_id1 + ') ';
    else if (specificCoOp) qryCriteria = '((brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select content_duration AS duration, content_title as title, sum(airings) as airings, brand_name as brand ';
        
    queryStr = queryStr + 'from content_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by title, duration order by duration asc, airings desc';// limit 20';
    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/product_network_coop_airings', function (req, res) {
    logUserAction('/product_network_coop_airings', req);
    var reqQ = req.query;
    
    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    //else if (specificCoOp) qryCriteria = '(' + qryCriteria + 'or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    else if (specificCoOp) qryCriteria = '((brand_id = ' + brand_id1 + ' and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select product, d.network, d.airings ';
    var detailSubQry = 'select product_name as product, tv_network as network, sum(airings) as airings ';
    var aggSubQry = 'select tv_network as network, sum(airings) as airings ';
    if (onlyCoOp) detailSubQry = 'select coop_product_name as product, tv_network as network, sum(airings) as airings ';
    else if (includeCoOp || specificCoOp) detailSubQry = 'select (CASE WHEN(brand_id = ' + brand_id1 + ')THEN product_name ELSE coop_product_name END) as product, tv_network as network, sum(airings) as airings ';

    detailSubQry = detailSubQry + 'from product_network_airings where ' + qryCriteria;
    aggSubQry = aggSubQry + 'from product_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            detailSubQry = detailSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            detailSubQry = detailSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    detailSubQry = detailSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by network, product';// order by airings desc';// limit 20';
    aggSubQry = aggSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by network';// order by airings desc';// limit 20';

    queryStr = queryStr + "from (" + detailSubQry + ") as d " +
                          "left join (" + aggSubQry + ") as a " +
                          "on d.network = a.network order by a.airings desc, d.airings desc";

    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/brand_network_coop_airings', function (req, res) {
    logUserAction('/brand_network_coop_airings', req);
    var reqQ = req.query;
    
    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    else if (specificCoOp) qryCriteria = '(' + qryCriteria + 'or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select brand, d.network, d.airings ';
    var detailSubQry = 'select brand_name as brand, tv_network as network, sum(airings) as airings ';
    var aggSubQry = 'select tv_network as network, sum(airings) as airings ';

    detailSubQry = detailSubQry + 'from brand_network_airings where ' + qryCriteria;
    aggSubQry = aggSubQry + 'from brand_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            detailSubQry = detailSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            detailSubQry = detailSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    detailSubQry = detailSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by brand, network';// order by airings desc';// limit 20';
    aggSubQry = aggSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by network';// order by airings desc';// limit 20';

    queryStr = queryStr + "from (" + detailSubQry + ") as d " +
                          "left join (" + aggSubQry + ") as a " +
                          "on d.network = a.network order by a.airings desc, d.airings desc";

    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/brand_show_coop_airings', function (req, res) {
    logUserAction('/brand_show_coop_airings', req);
    var reqQ = req.query;
    
    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    else if (specificCoOp) qryCriteria = '(' + qryCriteria + 'or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select brand, d.show_title as showT, d.airings ';
    var detailSubQry = 'select brand_name as brand, show_title, sum(airings) as airings ';
    var aggSubQry = 'select show_title, sum(airings) as airings ';

    detailSubQry = detailSubQry + 'from brand_network_show_airings where ' + qryCriteria;
    aggSubQry = aggSubQry + 'from brand_network_show_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            detailSubQry = detailSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            detailSubQry = detailSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            aggSubQry = aggSubQry + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    detailSubQry = detailSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by brand, show_title';// order by airings desc';// limit 20';
    aggSubQry = aggSubQry + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') '+
                            'group by show_title';// order by airings desc';// limit 20';

    queryStr = queryStr + "from (" + detailSubQry + ") as d " +
                          "left join (" + aggSubQry + ") as a " +
                          "on d.show_title = a.show_title order by a.airings desc, d.airings desc";

    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/product_coop_airings_weekly', function (req, res) {
    logUserAction('/product_coop_airings_weekly', req);
    var reqQ = req.query;
    
    var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    else if (specificCoOp) qryCriteria = '((brand_id = ' + brand_id1 + ' and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = 'select product_name as product, ';
    if (onlyCoOp) queryStr = 'select coop_product_name as product, ';
    else if (includeCoOp || specificCoOp) queryStr = 'select (CASE WHEN(brand_id = ' + brand_id1 + ')THEN product_name ELSE coop_product_name END) as product, ';

    queryStr = queryStr + "date_format(subdate(airing_date, WEEKDAY(airing_date)), '%M %e, %Y') as weekof, sum(airings) as airings " + 
                          'from product_network_airings where ' + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + "and airing_date between subdate('" + reqQ.startDate + "', WEEKDAY('" + reqQ.startDate + "'))  and adddate('" + reqQ.endDate + "', (6 - WEEKDAY('" + reqQ.endDate + "'))) " +
                          'group by product, broadcast_week order by airing_date desc, product';// order by airings desc';// limit 20';

    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/brand_coop_airings_weekly', function (req, res) {
    logUserAction('/brand_coop_airings_weekly', req);
    var reqQ = req.query;
    
    //var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
    //var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
    var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
    //var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
    var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
    //var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
    var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
    //var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
    var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
    //var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
    var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);

    //var brands = [brand1, brand2, brand3, brand4, brand5, brand6];
    var brands = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
    var numBrands = 0;
    var brandAggrInStr = '';
    for (brandIdx in brands) {
        var brand = brands[brandIdx];
        
        if (brand == '') break;
        
        numBrands++; // add to the number of Brands in the request query
        if (numBrands > 1) // add a comma from 2nd brands onwards
            brandAggrInStr = brandAggrInStr + ', ';
        brandAggrInStr = brandAggrInStr + brand;
    }
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id in (' + brandAggrInStr + ') ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '( brand_id = ' + brand_id1 + ' or coop_brand_id = ' + brand_id1 + ') ';
    //else if (specificCoOp) qryCriteria = '( brand_id = ' + brand_id1 + ' or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    else if (specificCoOp) qryCriteria = '((brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + reqQ.paramCO + ')) ';
    
    var queryStr = "select brand_name as brand, ";
    if (specificCoOp) queryStr = "select (CASE WHEN(brand_id in (" + brandAggrInStr + "))THEN brand_name ELSE coop_brand_name END) as brand, ";
    queryStr = queryStr + "date_format(subdate(airing_date, WEEKDAY(airing_date)), '%M %e, %Y') as weekof, sum(airings) as airings " +
                   "from brand_network_airings where " + qryCriteria;
    switch (reqQ.paramN){
        case 'b': // Broadcast only
            queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
        
    }
    queryStr = queryStr + "and airing_date between subdate('" + reqQ.startDate + "', WEEKDAY('" + reqQ.startDate + "')) and adddate('" + reqQ.endDate + "', (6 - WEEKDAY('" + reqQ.endDate + "'))) " +
                          'group by brand, broadcast_week order by airing_date desc, brand';// order by airings desc';// limit 20';

    console.log(queryStr);
    handle_database(queryStr,res);
});

app.get('/product_daypart_coop_airings', function (req, res) {
    logUserAction('/product_daypart_coop_airings', req);
    var reqQ = req.query;
    
    var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
       
    var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
    var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
    var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
    var qryCriteria = 'brand_id = ' + brand_id1 + ' ';
    if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id1 + ' ';
    else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id = ' + brand_id1 + ') ';
    //else if (specificCoOp) qryCriteria = '(' + qryCriteria + 'or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    else if (specificCoOp) qryCriteria = '((brand_id = ' + brand_id1 + ' and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
    qryCriteria = qryCriteria + 'AND airing_date BETWEEN Date(\'' + reqQ.startDate + '\') AND Date(\'' + reqQ.endDate + '\') ';
    
    var subQueryStr = 'select product_name as product, ';
    if (onlyCoOp) subQueryStr = 'select coop_product_name as product, ';
    else if (includeCoOp || specificCoOp) subQueryStr = 'select (CASE WHEN(brand_id = ' + brand_id1 + ')THEN product_name ELSE coop_product_name END) as product, ';

    subQueryStr = subQueryStr + 'daypart, SUM(airings) AS airings ' +
                                'FROM product_network_airings WHERE ' + qryCriteria;

    var groupByClause = "GROUP BY product, daypart";
    var aggSubQry = subQueryStr + groupByClause;
    var broadcastSubQry = subQueryStr + 'AND tv_network IN (' + broadcastChannels + ') ' + groupByClause;

    var queryStr = 'SELECT a.product, a.daypart, ' +
                          '(CASE WHEN(b.airings IS NULL)THEN 0 ELSE b.airings END) AS broadcast, '  +
                          '(a.airings - (CASE WHEN(b.airings IS NULL)THEN 0 ELSE b.airings END)) AS cable ' +
                          'FROM (' + aggSubQry + ') AS a ' +
                          'LEFT JOIN (' + broadcastSubQry + ') AS b ON a.product = b.product AND a.daypart = b.daypart ' +
                          'ORDER BY a.daypart';

    console.log(queryStr);
    handle_database(queryStr,res);
});


var json2xlsx = require('json2xlsx');
//var excel = require('exceljs');

var emailClient = require('./util/email')(config.email);

app.get('/access_request', function (req, res){ // heartbeat
        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/access_request', req);
        var queryStr = "select 'Your request has been logged.' as status from dual";
        console.log(queryStr);
        handle_database(queryStr, res); // TODO: log the request in db
});

app.get('/report_video', function (req, res){ // heartbeat
        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/report_video', req);
        var queryStr = "select 'Your request has been logged.' as status from dual";
        console.log(queryStr);
        handle_database(queryStr, res); // TODO: log the request in db
        
        var mailDetails = {};
        mailDetails.video = {};
        mailDetails.video.contentid = req.query.content;
        //mailDetails.video.contenttitle = req.query.title;
        //mailDetails.video.videourl = req.query.videourl;
        mailDetails.video.dashboardurl = config.hosturl + '/commercial/' + req.query.content;
        mailDetails.reportedby = {};
        mailDetails.reportedby.name = req.query.name;
        mailDetails.reportedby.email = req.query.email;
        mailDetails.reportedby.company = req.query.company;
        mailDetails.reportedby.phone = req.query.phone;
        mailDetails.reportedby.desc = req.query.desc;
        mailDetails.signininfo = require('./util/linkedin').signinInfo(req);
        mailDetails.reqIP = getIPString(req);

        emailClient.reportVideo(mailDetails);
});

app.get('/requestFT', function (req, res){ // heartbeat
        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/requestFT', req);
        var queryStr = "select 'Your request has been logged.' as status from dual";
        console.log(queryStr);
        handle_database(queryStr, res); // TODO: log the request in db
        
        var mailDetails = {};
        mailDetails.email = req.query.email;
        mailDetails.brands = req.query.brands;
        mailDetails.signininfo = require('./util/linkedin').signinInfo(req);
        mailDetails.reqIP = getIPString(req);

        emailClient.requestFT(mailDetails);
});

app.get('/email_request', function (req, res){
        //console.log('request received: ' + JSON.stringify(req.query));
        logUserAction('/email_request', req);
        var reqQ = req.query;
        var toAddress = reqQ.email;
        
        var date = Math.floor((new Date()).getTime() /1000); // Time elapsed since midnight of 1st Jan, 1970 in seconds
        var reportFileName = 'alphonso-' + date + ".xlsx";
        var cbArgs = {};
        cbArgs.reportFileName = reportFileName;
        cbArgs.dataTransformer = [];
        //cbArgs.dataTransformer['cat'] = 'Network';
        /*if (typeof reqQ.paramAdTitle === 'undefined' && typeof reqQ.brand_id2 !== 'undefined') // at least 2 brands to compare
        executeQuery(get_brand_network_query (req, cbArgs.dataTransformer), cbArgs, function(rows, cbArgs){
            console.log(cbArgs);
            var data = [];
            var header = ["Network", cbArgs.dataTransformer['b1']];
            if (typeof cbArgs.dataTransformer['b2'] !== 'undefined') header.push(cbArgs.dataTransformer['b2']);
            if (typeof cbArgs.dataTransformer['b3'] !== 'undefined') header.push(cbArgs.dataTransformer['b3']);
            if (typeof cbArgs.dataTransformer['b4'] !== 'undefined') header.push(cbArgs.dataTransformer['b4']);
            if (typeof cbArgs.dataTransformer['b5'] !== 'undefined') header.push(cbArgs.dataTransformer['b5']);
            if (typeof cbArgs.dataTransformer['b6'] !== 'undefined') header.push(cbArgs.dataTransformer['b6']);
            data.push(header);
            rows.forEach (function (row) {
                var brandData = [];
                brandData.push(row.cat);
                brandData.push(row.b1);
                if (typeof row.b2 !== 'undefined') brandData.push(row.b2);
                if (typeof row.b3 !== 'undefined') brandData.push(row.b3);
                if (typeof row.b4 !== 'undefined') brandData.push(row.b4);
                if (typeof row.b5 !== 'undefined') brandData.push(row.b5);
                if (typeof row.b6 !== 'undefined') brandData.push(row.b6);
                
                data.push(brandData);
            });
            
            console.log("Writing " + cbArgs.reportFileName);// + " with data :" + data);
            json2xlsx.write('./static/reports/' + reportFileName, 'Brand-Network', data);
            
            executeQuery(get_brand_network_show_query (req, cbArgs.dataTransformer), cbArgs, function(rows, cbArgs){
                console.log(cbArgs);
                var data = [];
                var header = ["Show", cbArgs.dataTransformer['b1']];
                if (typeof cbArgs.dataTransformer['b2'] !== 'undefined') header.push(cbArgs.dataTransformer['b2']);
                if (typeof cbArgs.dataTransformer['b3'] !== 'undefined') header.push(cbArgs.dataTransformer['b3']);
                if (typeof cbArgs.dataTransformer['b4'] !== 'undefined') header.push(cbArgs.dataTransformer['b4']);
                if (typeof cbArgs.dataTransformer['b5'] !== 'undefined') header.push(cbArgs.dataTransformer['b5']);
                if (typeof cbArgs.dataTransformer['b6'] !== 'undefined') header.push(cbArgs.dataTransformer['b6']);
                data.push(header);
                rows.forEach (function (row) {
                    var brandData = [];
                    brandData.push(row.cat);
                    brandData.push(row.b1);
                    if (typeof row.b2 !== 'undefined') brandData.push(row.b2);
                    if (typeof row.b3 !== 'undefined') brandData.push(row.b3);
                    if (typeof row.b4 !== 'undefined') brandData.push(row.b4);
                    if (typeof row.b5 !== 'undefined') brandData.push(row.b5);
                    if (typeof row.b6 !== 'undefined') brandData.push(row.b6);
                    
                    data.push(brandData);
                });
            
                console.log("Writing " + cbArgs.reportFileName);// + " with data :" + data);
                json2xlsx.write('./static/reports/' + reportFileName, 'Brand-Show', data);

                attachments  = [{
                                fileName : reportFileName,
                                filePath : './static/reports/' + reportFileName
                            }];
                var mailDetails = {};
                mailDetails.toAddress = toAddress;
                mailDetails.attachments = attachments;
                mailDetails.header = cbArgs.dataTransformer['b1'];
                mailDetails.signininfo = require('./util/linkedin').signinInfo(req);
                mailDetails.extraMessage = "This report compares the airings across brands. If you are interested in receiving an airing report for a particular brand, you should select only one brand on the filter and then click on ‘Get Report’.<br /><br />";
                mailDetails.reqIP = getIPString(req);
                mailDetails.reportsurl = config.hosturl + '/reports/' + reportFileName;
                emailClient.sendReport(mailDetails);
            },cbArgs);
        }, cbArgs);
        
        else*/ if (typeof reqQ.paramAdTitle === 'undefined') {
            var reqQ = req.query;

            var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
            var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
            var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
            var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
            var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
            var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
            var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
            var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
            var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
            var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
            var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
            var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);

            var brandIds = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
            var brands = [brand1, brand2, brand3, brand4, brand5, brand6];
            var numBrands = 0;
            var brandAggrInStr = '';
            for (brandIdx in brandIds) {
                var brandId = brandIds[brandIdx];
                if (brandId == '')
                    break;
                
                var isDup = false;
                for (var j = 0; j < numBrands; j++) {
                    if (brandId == brandIds[j]) { // if duplicate found
                        isDup = true;
                        brandIds[brandIdx] = ''; // Empty brand id will result in 0 rows returned in the Brand Query later.
                        break;
                    }
                }
                
                numBrands++; // add to the number of Brands in the request query
                
                if (isDup) continue; // Adding the brand in the SQL IN statement can be avoided
                
                if (numBrands > 1) // add a comma from 2nd brands onwards
                    brandAggrInStr = brandAggrInStr + ', ';
                brandAggrInStr = brandAggrInStr +  brandId;
            }

            var brand = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
            var brand_id = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
            var includeCoOp = false; if (reqQ.paramCO == 'i') includeCoOp = true; // i(include co-op commercials)
            var onlyCoOp = false; if (reqQ.paramCO == 'o') onlyCoOp = true; // o (only co-op commercials)
            var specificCoOp = false; if (!isNaN(reqQ.paramCO)) specificCoOp = true;
            cbArgs.dtlrpt = reqQ.dtlrpt;
            //var qryCriteria = "brand_id = " + brand_id + " ";
            var qryCriteria = "brand_id in (" + brandAggrInStr + ") ";
            if (onlyCoOp) qryCriteria = 'coop_brand_id = ' + brand_id + ' ';
            else if (includeCoOp) qryCriteria = '(' + qryCriteria + 'or coop_brand_id in (' + brandAggrInStr + ')) ';
            //else if (specificCoOp) qryCriteria = '((brand_id = ' + brand_id1 + ' and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id = ' + brand_id1 + ' and brand_id = ' + reqQ.paramCO + ')) ';
            else if (specificCoOp) qryCriteria = '((brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + reqQ.paramCO + ') or (coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + reqQ.paramCO + ')) ';

            var queryStr =  "select content_id, content_title, content_duration, (content_duration/30) as eq_units, brand_name, tv_network, show_title, " +
                                    "(case when(tv_network in (" + broadcastChannels + ")) then 'Broadcast' else 'Cable' end) as network_type, " +
                                    //"category_name, pod_position, (case when(coop_brand_id = " + brand_id + ") then coop_product_name else product_name end) as product_name, " +
                                    "category_name, pod_position, (case when(coop_brand_name is null) then '' else coop_brand_name end) as coop_brand_name, " +
                                    "airing_time, daypart, daypart2, getStarcomDaypart(airing_time, tv_network, show_title, show_genres) as tags, " +
                                    "broadcast_year, broadcast_quarter, broadcast_month, broadcast_week, (WEEKDAY(airing_time) + 1) as day_of_week, HOUR(airing_time) as hour_of_day, ";
            if (reqQ.dtlrpt) queryStr = queryStr + "product_name, (case when(coop_product_name is null) then '' else coop_product_name end) as coop_product_name ";
            else queryStr = queryStr + "(case when(coop_brand_id in (" + brandAggrInStr + ")) then coop_product_name else product_name end) as product_name ";
            queryStr = queryStr + "from airings " +
                            //"where brand_id = " + brand_id + " and show_name not in ('undefined', 'Paid Programming') " +
                            "where " + qryCriteria + "and DATE(airing_time) between Date('" + reqQ.startDate + "') and Date('" + reqQ.endDate + "') ";                                    
            switch (reqQ.paramN) {
                case 'b': // Broadcast only
                    queryStr = queryStr + "and tv_network in (" + broadcastChannels + ") ";
                    // not required for the subQueryBrand1 as we are using left join.
                    break;
                case 'c': // Cable only
                    queryStr = queryStr + "and tv_network not in (" + broadcastChannels + ") ";
                    break;
                default: // All Networks
                    // No criteria required
            }

            queryStr = queryStr +
                        "order by airing_time desc";// limit ' + numRecToFetch;
            
            console.log(queryStr);
            
            executeQuery(queryStr, cbArgs, function(rows, cbArgs){
                //console.log(cbArgs);
                var data = [];
                var header = ["Id", "Title", "Brand", "Category", "Network", "Show", "Date", "Time", "Pod Position", "Dayparts", "Tags", "Co-Op Brand", "Product",
                              "Duration", "EQ Units", "Broadcast Year", "Broadcast Quarter", "Broadcast Month", "Broadcast Week"];
                if (cbArgs.dtlrpt) header = ["Id", "Title", "Brand", "Product", "Category", "Network", "Network Type", "Show", "Date", "Time", "Pod Position", "Dayparts", "Tags", "Co-Op Brand", "Co-Op Product",
                              "Duration", "EQ Units", "Broadcast Year", "Broadcast Quarter", "Broadcast Month", "Broadcast Week", "Day of Week", "Hour of Day"];
                data.push(header);
                rows.forEach (function (row) {
                    var brandData = [];
                    var date = new Date(row.airing_time);
                    //console.log(date.toLocaleDateString() + " ::: " + date.toLocaleTimeString());
                    brandData.push(row.content_id);
                    brandData.push(row.content_title);
                    brandData.push(row.brand_name);
                    if (cbArgs.dtlrpt) brandData.push(row.product_name);
                    brandData.push(row.category_name == 'undefined'? 'n/a': row.category_name);
                    brandData.push(row.tv_network);
                    if (cbArgs.dtlrpt) brandData.push(row.network_type);
                    brandData.push((row.show_title == 'undefined' || row.show_title == 'null')? 'n/a': row.show_title);
                    brandData.push(new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate())));
                    brandData.push(date.toLocaleTimeString());
                    brandData.push(row.pod_position == '0'? 'n/a': row.pod_position);
                    //brandData.push(row.daypart);
                    brandData.push(row.daypart2); // Without weekend consideration
                    brandData.push(row.tags);
                    brandData.push(row.coop_brand_name);
                    if (cbArgs.dtlrpt) brandData.push(row.coop_product_name);
                    else brandData.push(row.product_name);
                    brandData.push(row.content_duration);
                    brandData.push(row.eq_units);
                    brandData.push(row.broadcast_year);
                    brandData.push(row.broadcast_quarter);
                    brandData.push(row.broadcast_month);
                    brandData.push(row.broadcast_week);
                    if (cbArgs.dtlrpt) {
                        brandData.push(row.day_of_week);
                        brandData.push(row.hour_of_day);
                    }
                    
                    data.push(brandData);
                });
                
                console.log("Writing " + cbArgs.reportFileName);// + " with data :" + data);
                json2xlsx.write('./static/reports/' + reportFileName, 'Brand-Campaign-Details', data);

                attachments  = [{
                                fileName : reportFileName,
                                filePath : './static/reports/' + reportFileName
                            }];
                var mailDetails = {};
                mailDetails.toAddress = toAddress;
                mailDetails.attachments = attachments;
                mailDetails.header = brand;
                mailDetails.signininfo = require('./util/linkedin').signinInfo(req);
                mailDetails.extraMessage = '';
                mailDetails.reqIP = getIPString(req);
                mailDetails.reportsurl = config.hosturl + '/reports/' + reportFileName;
                emailClient.sendReport(mailDetails);
            });
        }
        
        else {
            
            var reqQ = req.query;
            //var brand = (typeof reqQ.paramB === 'undefined'? '':reqQ.paramB.replace(/'/g, "\\'"));
            var brand_id = (typeof reqQ.brand_id === 'undefined'? '': reqQ.brand_id);
            var ad_title = (typeof reqQ.paramAdTitle === 'undefined'? '':reqQ.paramAdTitle.replace(/'/g, "\\'"));
            var content_id = (typeof reqQ.contentId === 'undefined'? '': reqQ.contentId);
            
            /*request(getRequestURL("/raw_similar_by_id?id=" + content_id), function(error, response, body) {
                console.log(body);
                var content_id_str = content_id;
                if(body != 'undefined' && body != null && body.length > 0) {
                    var similarContents = JSON.parse(body);
                    for (var i = 0; i < similarContents.length; i++){
                        content_id_str = content_id_str + ', ' + similarContents[i].content_id;
                    }
                }*/
                
                var queryStr =  "select " + content_id + " as content_id, content_title, content_duration, (content_duration/30) as eq_units, brand_name, tv_network, show_title, " +
                                    "category_name, pod_position, (case when(coop_brand_id = " + brand_id + ") then coop_product_name else product_name end) as product_name, " +
                                    "(case when(coop_brand_name is null) then '' else coop_brand_name end) as coop_brand_name, " +
                                    "airing_time, daypart, daypart2, broadcast_year, broadcast_quarter, broadcast_month, broadcast_week " +
                                "from airings " +
                                //"where content_id in (" + content_id_str + ") and show_name not in ('undefined', 'Paid Programming') " +
                                //"where content_id in (" + content_id_str + ") ";
                                "where content_group_id = (SELECT content_group_id FROM content_productl_brandg_category WHERE content_id = " + content_id + ") ";
                if (brand_id.length > 0) queryStr = queryStr + "and brand_id = " + brand_id + " ";
                queryStr = queryStr + "and DATE(airing_time) between Date('" + reqQ.startDate + "') and Date('" + reqQ.endDate + "') ";                                    
                switch (reqQ.paramN) {
                    case 'b': // Broadcast only
                        queryStr = queryStr + "and tv_network in (" + broadcastChannels + ") ";
                        // not required for the subQueryBrand1 as we are using left join.
                        break;
                    case 'c': // Cable only
                        queryStr = queryStr + "and tv_network not in (" + broadcastChannels + ") ";
                        break;
                    default: // All Networks
                        // No criteria required
                }


                queryStr = queryStr + "order by airing_time desc";// limit ' + numRecToFetch;
                
                console.log(queryStr);
                //return queryStr;
                executeQuery(queryStr, cbArgs, function(rows, cbArgs){
                    console.log(cbArgs);
                    var data = [];
                    var header = ["Id", "Title", "Brand", "Category", "Network", "Show", "Date", "Time", "Pod Position", "Dayparts", "Co-Op Brand", "Product",
                                  "Duration", "EQ Units", "Broadcast Year", "Broadcast Quarter", "Broadcast Month", "Broadcast Week"];
                    data.push(header);
                    rows.forEach (function (row) {
                        var brandData = [];
                        var date = new Date(row.airing_time);

                        brandData.push(row.content_id);
                        brandData.push(row.content_title);
                        brandData.push(row.brand_name);
                        brandData.push(row.category_name == 'undefined'? 'n/a': row.category_name);
                        brandData.push(row.tv_network);
                        brandData.push((row.show_title == 'undefined' || row.show_title == 'null')? 'n/a': row.show_title);
                        brandData.push(new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate())));
                        brandData.push(date.toLocaleTimeString());
                        brandData.push(row.pod_position == '0'? 'n/a': row.pod_position);
                        //brandData.push(row.daypart);
                        brandData.push(row.daypart2); // Without weekend consideration
                        brandData.push(row.coop_brand_name);
                        brandData.push(row.product_name);
                        brandData.push(row.content_duration);
                        brandData.push(row.eq_units);
                        brandData.push(row.broadcast_year);
                        brandData.push(row.broadcast_quarter);
                        brandData.push(row.broadcast_month);
                        brandData.push(row.broadcast_week);
                        
                        data.push(brandData);
                    });
                    
                    console.log("Writing " + cbArgs.reportFileName);// + " with data :" + data);
                    json2xlsx.write('./static/reports/' + reportFileName, 'Campaign-Details', data);

                    /*var workbook = new excel.Workbook();
                    var worksheet = workbook.addWorksheet('Campaign-Details');
                    worksheet.columns = [
                                            { header: 'Title' },
                                            { header: 'Brand' },
                                            { header: 'Category' },
                                            { header: 'Network' },
                                            { header: 'Show' },
                                            { header: 'Date'},
                                            { header: 'Time'},
                                            { header: 'Pod Position' },
                                        ];
                    rows.forEach (function (row) {
                        var brandData = [];
                        var date = new Date(row.airing_time);
                        //console.log(date.toLocaleDateString() + " ::: " + date.toLocaleTimeString());
                        brandData.push(row.title);
                        brandData.push(row.brand);
                        brandData.push(row.brand_cat == 'undefined'? 'n/a': row.brand_cat);
                        brandData.push(row.network);
                        brandData.push(row.show_name == 'undefined'? 'n/a': row.show_name);
                        brandData.push(date);
                        brandData.push(date.toLocaleTimeString());
                        brandData.push(row.seq_no == '-1'? 'n/a': row.seq_no);
                        
                        data.push(brandData);
                    });
                    worksheet.addRows(data);
                    workbook.xlsx.writeFile('./reports/' + reportFileName);*/

                    attachments  = [{
                                    fileName : reportFileName,
                                    filePath : './static/reports/' + reportFileName
                                }];
                    var mailDetails = {};
                    mailDetails.toAddress = toAddress;
                    mailDetails.attachments = attachments;
                    mailDetails.header = ad_title;
                    mailDetails.signininfo = require('./util/linkedin').signinInfo(req);
                    mailDetails.extraMessage = '';
                    mailDetails.reqIP = getIPString(req);
                    mailDetails.reportsurl = config.hosturl + '/reports/' + reportFileName;
                    emailClient.sendReport(mailDetails);
                });
            //});
            
        }
        
        var queryStr = "select 'You will soon receive the report in your Inbox.' as status from dual";
        console.log(queryStr);
        handle_database(queryStr, res);
});

// index page
app.get('/index', function(req, res) {
    //console.log("serving /index");
    logUserAction('/index', req);
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    var linkedin = require('./util/linkedin');
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken'] || (req.query.state && req.query.code)){
        linkedin.OAuthValidation(req, res, 'index', renderIndexPage, config.hosturl + '/');
    }
    else renderIndexPage(req, res);
});
app.get('/', function(req, res) {
    //console.log("serving /");
    logUserAction('/', req);
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    var linkedin = require('./util/linkedin');
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken'] || (req.query.state && req.query.code)){
        linkedin.OAuthValidation(req, res, 'index', renderIndexPage, config.hosturl + '/');
    }
    else renderIndexPage(req, res);
});
function renderIndexPage(req, res) {

    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req);
    var signedInUserFullName = linkedin.getUserFullName(req);
    var showPremimumReports;

    //var pageInputs = {featuredContent: [], brands: [], config: config};
    var pageInputs = {brands: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName};
    //pageInputs.brands = JSON.stringify(require('./util/brands'));
    //console.log("1" + JSON.stringify(renderVals));
    request(getRequestURL("/featured_content"), function(error, response, body) {
        //console.log('featured_content: ' + body);
        if (typeof body !== 'undefined') pageInputs.featuredContent = body;
        else pageInputs.featuredContent = "[]";
        //console.log("2" + renderVals.featuredContent);
        if (pageInputs.brands.length > 0) {
            res.render('pages/index', pageInputs);
            console.log("1: rendering pages/index")
        }
    });
    /*request(getRequestURL("/list_brands"), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.brands = body;
        else pageInputs.brands = JSON.stringify(require('./util/brands'));
        //console.log("2" + renderVals.featuredContent);
        if (typeof pageInputs.featuredContent !== 'undefined') {
            res.render('pages/index', pageInputs);
            console.log("2: rendering pages/index")
        }
    });*/
    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        if (typeof cbArgs.featuredContent !== 'undefined') {
            res.render('pages/index', cbArgs);
            console.log("2: rendering pages/index")
        }
    });
}

// category page 
app.get('/category/', function(req, res) {
    logUserAction("/category/" , req);
    var linkedin = require('./util/linkedin');
    linkedin.OAuthValidation(req, res, null, serveCategoryPage, config.hosturl + '/category/');
});
app.get('/category/:category_id', function(req, res) {
    var category_id = req.params.category_id;
    logUserAction("/category/" + category_id , req);
    
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken']){
        var linkedin = require('./util/linkedin');
        linkedin.OAuthValidation(req, res, category_id, serveCategoryPage, config.hosturl + '/category/');
    }
    else
        serveCategoryPage(req, res, category_id);
});

var serveCategoryPage = function (req, res, category_id, category_name, rescookies) {

    var category = '';
    if (typeof category_id === 'undefined' || category_id == null) {
        res.redirect('/');
        return;
    }
    else
        category = category_id.replace(/-/g, " ");
    //category = category.replace(/n p/g, "n-p"); //TODO: temp hack for 'Government & Non-profits'
    //console.log(category);
    var pageTitle = category;

    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req, rescookies);
    var signedInUserFullName = linkedin.getUserFullName(req, rescookies);
    
    var pageInputs = {title: pageTitle, brands: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName};
    //pageInputs.brands = JSON.stringify(require('./util/brands'));
    /*request(getRequestURL("/list_content_by_category?category_name=" + escape(category)), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.catAdList = body;
        else pageInputs.catAdList = "[]";
        if (pageInputs.brands.length > 0) {
            res.render('pages/category', pageInputs);
            console.log("1: rendering pages/category/" + category_id);
        }
    });*/
    var contentlistQuery = "SELECT content_id, content_title AS title, category_name AS category, airings AS total_airings, spend AS total_spend, " +
	                              "CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', content_id, '/poster.jpg') AS thumbnail " +
                           "FROM content_list " +
                           "WHERE category_name = '" + category + "' " +
                           "ORDER BY airing_end DESC, airing_start DESC, airings DESC";
    //console.log(contentlistQuery);
    executeQuery(contentlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('content_list: ' + JSON.stringify(rows));
        if (rows.length > 0) {
            cbArgs.catAdList = JSON.stringify(rows);
            if (cbArgs.brands.length > 0) {
                res.render('pages/category', cbArgs);
                console.log("1: rendering pages/category/" + category_id);
            }
        }
        else //cbArgs.catAdList = "[]";
            res.redirect('/');
    });
    /*request(getRequestURL("/list_brands"), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.brands = body;
        else pageInputs.brands = JSON.stringify(require('./util/brands'));
        if (typeof pageInputs.catAdList !== 'undefined') {
            res.render('pages/category', pageInputs);
            console.log("2: rendering pages/category/" + category_id);
        }
    });*/
    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        if (typeof cbArgs.catAdList !== 'undefined') {
            res.render('pages/category', cbArgs);
            console.log("2: rendering pages/category/" + category_id);
        }
    });
}

// brand page 
app.get('/brand/', function(req, res) {
    logUserAction("/brand/" , req);
    var linkedin = require('./util/linkedin');
    linkedin.OAuthValidation(req, res, null, serveBrandPage, config.hosturl + '/brand/');
});
app.get('/brand/:brand_id', function(req, res) {
    var brand_id = req.params.brand_id;
    logUserAction("/brand/" + brand_id , req);
    
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken']){
        var linkedin = require('./util/linkedin');
        linkedin.OAuthValidation(req, res, brand_id, serveBrandPage, config.hosturl + '/brand/');
    }
    else
        serveBrandPage(req, res, brand_id);
});

var serveBrandPage = function (req, res, brand_id, brand_name, rescookies) {
    var brandInfo = '';
    if (typeof brand_id === 'undefined' || brand_id == null) {
        res.redirect('/');
        return;
    }
    else {
        brandInfo = brand_id.split("-");
        if(isNaN(brandInfo[0])) {
            res.redirect('/');
            return;
        }
    }
    
    var pageTitle = '';
    if (brandInfo.length > 1){
        var brandName = '';
        for (var i = 1; i < (brandInfo.length - 1); i++)
            brandName = brandName + brandInfo[i] + ' ';
        
        brandName = brandName + brandInfo[brandInfo.length - 1];
        
        if (brandName.length > 0)    
            pageTitle = brandName;
    }

    var responseLock = 5;
    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req, rescookies);
    var signedInUserFullName = linkedin.getUserFullName(req, rescookies);
    var showPremimumReports;

    var pageInputs = {title: pageTitle, brands: [], ccb: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName, showPremimumReports: showPremimumReports, loc_attr_rpt: {}, sinceStart: false};

    if (isSignedIn) {
        console.log("isSignedIn : " + isSignedIn);
        getBrandLarReport(brandInfo[0], pageInputs, function(report, cbArgs){
            cbArgs.loc_attr_rpt = report;
            responseLock--;
            //console.log("5 : " + responseLock);
            if (responseLock == 0) {
                res.render('pages/brand', cbArgs);
                console.log("5: rendering pages/brand/" + brand_id);
            }
        });
    }
    else { 
        responseLock--;
        //console.log("5 : " + responseLock);
    }

    var brandCatQuery = "select brand_id, brand_name, category_name from content_list where brand_id = " + brandInfo[0] + " group by category_id order by sum(airings) desc limit 1;";
    executeQuery(brandCatQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brandCat = JSON.stringify(rows[0]);
        else cbArgs.brandCat = "{}";
        responseLock--;
        //console.log("1 : " + responseLock);
        if (responseLock == 0) {
            res.render('pages/brand', cbArgs);
            console.log("1: rendering pages/brand/" + brand_id);
        }
    });
    pageInputs.brandAdList = "{}";
    /*var contentlistQuery = getBrandContentsQryStr(brandInfo[0]);
    executeQuery(contentlistQuery, pageInputs, function(rows, cbArgs){
        if (rows.length > 0) {
            cbArgs.brandAdList = JSON.stringify(rows);
            responseLock--;
            console.log("1a : " + responseLock);
            if (responseLock == 0) {
                res.render('pages/brand', cbArgs);
                console.log("1a: rendering pages/brand/" + brand_id);
            }
        } else {
            //pageInputs.brandAdList = "[]";
            //res.redirect('/');
            cbArgs.sinceStart = true;
            contentlistQuery = getBrandContentsQryStr(brandInfo[0], '2016-01-01');
            executeQuery(contentlistQuery, pageInputs, function(rows, cbArgs){
                if (rows.length > 0) {
                    cbArgs.brandAdList = JSON.stringify(rows);
                    responseLock--;
                    console.log("1b : " + responseLock);
                } else {
                    pageInputs.brandAdList = "[]";
                    res.redirect('/');
                }
                
                if (responseLock == 0) {
                    res.render('pages/brand', cbArgs);
                    console.log("1b: rendering pages/brand/" + brand_id);
                }
            });
        }
    });*/

    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        responseLock--;
        //console.log("2 : " + responseLock);
        if (responseLock == 0) {
            res.render('pages/brand', cbArgs);
            console.log("2: rendering pages/brand/" + brand_id);
        }
    });

    var cooplistQuery = "SELECT brand_id, brand_name FROM coop_list WHERE coop_brand_id = " + brandInfo[0];
    executeQuery(cooplistQuery, pageInputs, function(rows, cbArgs){
        //console.log('coop_brands: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.coop_brands = rows;
        else cbArgs.coop_brands = [];
        responseLock--;
        //console.log("2 : " + responseLock);
        if (responseLock == 0) {
            res.render('pages/brand', cbArgs);
            console.log("6: rendering pages/brand/" + brand_id);
        }
    });

    if (isSignedIn) pageInputs.showPremimumReports = true;
    else pageInputs.showPremimumReports = false;
    /*var authQuery = "select count(*) as authorized from brand_auth where (brand_id = " + brandInfo[0] + " or brand_id = 0) and username = '" + linkedin.getUserId(req) + "'";
    executeQuery(authQuery, pageInputs, function(rows, cbArgs){
        //console.log('rows[0].authorized: ' + rows[0].authorized);
        if (rows[0].authorized == 1) cbArgs.showPremimumReports = true;
        else cbArgs.showPremimumReports = false;
        //console.log("showPremimumReports: " + showPremimumReports);

        //if (cbArgs.brands.length > 0 && typeof cbArgs.brandAdList !== 'undefined') {
        responseLock--;
        console.log("3 : " + responseLock);
        if (responseLock == 0) {
            res.render('pages/brand', cbArgs);
            console.log("3: rendering pages/brand/" + brand_id);
        }
    });*/

    var ccbQuery =  "SELECT DISTINCT a.brand_id, a.brand_name FROM " +
                    "(SELECT ccb.brand_id, (CASE WHEN(brands.brand_display_name IS NULL) THEN brands.brand_name ELSE brands.brand_display_name END) AS brand_name FROM " +
                    "cc_brands AS ccb, " +
                    "brands AS brands, " +
                    "(SELECT cc_brand_group_id FROM cc_brands WHERE brand_id = " + brandInfo[0] + ") AS ccbg " +
                    "WHERE ccb.cc_brand_group_id = ccbg.cc_brand_group_id AND ccb.brand_id =  brands.brand_id) AS a " +
                    "WHERE a.brand_id <> " + brandInfo[0] + " ";
                    "ORDER BY brand_name";
    executeQuery(ccbQuery, pageInputs, function(rows, cbArgs){
        //console.log('rows : ' + JSON.stringify(rows));
        if (rows.length > 1) cbArgs.ccb = rows;

        responseLock--;
        //console.log("4 : " + responseLock);
        if (responseLock == 0) {
            res.render('pages/brand', cbArgs);
            console.log("4: rendering pages/brand/" + brand_id);
        }
    });
}

// advertisement/content page 
app.get('/commercial/', function(req, res) {
    logUserAction("/commercial/" , req);
    var linkedin = require('./util/linkedin');
    linkedin.OAuthValidation(req, res, null, serveContentPage, config.hosturl + '/commercial/');
});
app.get('/commercial/:ad_id', function(req, res) {
    var ad_id = req.params.ad_id;
    logUserAction("/commercial/" + ad_id , req);
    var adInfo = ad_id.split("-");
    
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken']){
        var linkedin = require('./util/linkedin');
        //linkedin.OAuthValidation(req, res, adInfo[0], serveContentPage);
        linkedin.OAuthValidation(req, res, ad_id, serveContentPage, config.hosturl + '/commercial/');
    }
    else
        //serveContentPage(req, res, adInfo[0]);
        serveContentPage(req, res, ad_id);
});

var serveContentPage = function (req, res, content_id, content_title, rescookies) {
    var contentInfo = '';
    if (typeof content_id === 'undefined' || content_id == null) {
        res.redirect('/');
        return;
    }
    else {
        contentInfo = content_id.split("-");
        if(isNaN(contentInfo[0])) {
            res.redirect('/');
            return;
        }
    }

    var pageTitle = '';
    if (contentInfo.length > 1){
        var contentTitle = '';
        for (var i = 1; i < (contentInfo.length - 1); i++)
            contentTitle = contentTitle + contentInfo[i] + ' ';
        
        contentTitle = contentTitle + contentInfo[contentInfo.length - 1];
        
        if (contentTitle.length > 0)    
            pageTitle = contentTitle;
    }

    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req, rescookies);
    var signedInUserFullName = linkedin.getUserFullName(req, rescookies);
    
    //var pageInputs = {adDetails: {}, brands: [], similarAds: []};
    var pageInputs = {title: pageTitle, adDetails: {}, brands: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName};
    //pageInputs.brands = JSON.stringify(require('./util/brands'));
    //console.log(JSON.stringify(pageInputs));
    //request(getRequestURL("/content_by_id?id=" + content_id), function(error, response, body) {
    /*request(getRequestURL("/content_by_id?id=" + contentInfo[0]), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.adDetails = JSON.parse(body);
        else { pageInputs.adDetails.id = -1;}
        if (pageInputs.brands.length > 0 && typeof pageInputs.similarAds !== 'undefined') {
            res.render('pages/advertisement', pageInputs);
            console.log("1: rendering pages/commercial/" + content_id);
        }
    });*/
    var contentDetailsQuery = getContentDetailsQryStr(contentInfo[0]);
    executeQuery(contentDetailsQuery, pageInputs, function(rows, cbArgs){
        //console.log('content_details: ' + JSON.stringify(rows));
        if (rows.length > 0) {
            cbArgs.adDetails = rows[0];
            //console.log('content_details: ' + JSON.stringify(cbArgs.adDetails));
            if (cbArgs.brands.length > 0 && typeof cbArgs.similarAds !== 'undefined') {
                res.render('pages/advertisement', cbArgs);
                console.log("1: rendering pages/commercial/" + content_id);
            }
        }
        else {
            //pageInputs.adDetails.content_id = -1;
            res.redirect('/');
        }
    });
    /*request(getRequestURL("/list_brands"), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.brands = body;
        else pageInputs.brands = JSON.stringify(require('./util/brands'));
        //console.log("[" + pageInputs.adDetails.id + "]" + " : " + (typeof pageInputs.adDetails.id !== 'undefined') + " : " + (pageInputs.adDetails.id != 'undefined'));
        if (typeof pageInputs.adDetails.id !== 'undefined' && typeof pageInputs.similarAds !== 'undefined') {
            res.render('pages/advertisement', pageInputs);
            console.log("2: rendering pages/advertisement")
        }
    });*/
    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        if (typeof cbArgs.adDetails.content_id !== 'undefined' && typeof cbArgs.similarAds !== 'undefined') {
            res.render('pages/advertisement', cbArgs);
            console.log("2: rendering pages/commercial/" + content_id);
        }
    });

    //request(getRequestURL("/similar_by_id?id=" + content_id), function(error, response, body) {
    /*request(getRequestURL("/similar_by_id?id=" + contentInfo[0]), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') pageInputs.similarAds = body;
        else pageInputs.similarAds = "[]";
        if (pageInputs.brands.length > 0 && typeof pageInputs.adDetails.content_id !== 'undefined') {
            res.render('pages/advertisement', pageInputs);
            console.log("3: rendering pages/commercial/" + content_id);
        }
    });*/

    var similarContentQry = "SELECT content_id AS id, content_title AS title, " +
                                    "CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', content_id, '/poster.jpg') AS thumbnail, " +
                                    "CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', content_id, '.mp4') AS mp4_clip " +
                            "FROM content_list " +
                            "WHERE content_group_id = (SELECT content_group_id FROM content_productl_brandg_category WHERE content_id = " + contentInfo[0] + ")";
    executeQuery(similarContentQry, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.similarAds = JSON.stringify(rows);
        else cbArgs.similarAds = "[]";
        if (cbArgs.brands.length > 0 && typeof cbArgs.adDetails.content_id !== 'undefined') {
            res.render('pages/advertisement', cbArgs);
            console.log("3: rendering pages/commercial/" + content_id);
        }
    });
        
}

app.get('/brandscontent', function (req, res) {
    logUserAction("/brandscontent/", req);
    
    var reqQ = req.query;
    var brand_id = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
    handle_database(getBrandContentsQryStr(brand_id, reqQ.startDate, reqQ.endDate, reqQ.contents, reqQ.allcontents), res);
});

function getBrandContentsQryStr (brand_id, startDate, endDate, contentsFilter, allcontents) {

    if (typeof startDate === 'undefined')
        startDate = "MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER";//"'2016-01-01'";
    else
        startDate = "'" + startDate + "'";

    if (typeof endDate === 'undefined')
        endDate = "CURDATE()";
    else
        endDate = "'" + endDate + "'";

    var contentFilterStr = ' ';
    if (typeof contentsFilter !== 'undefined' && contentsFilter != null && contentsFilter.length > 0)
        contentFilterStr = ' AND content_id in (' + contentsFilter + ') '
        
    var queryStr =  "SELECT c.content_id, c.content_title AS title, c.brand_id, c.brand_name AS brand, c.category_name AS category, " +
	                        "cga.total_airings, cga.total_spend, CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', c.content_id, '/poster.jpg') AS thumbnail " +
                    "FROM " +
                    "(SELECT * FROM content_list " +
                    "WHERE brand_id = " + brand_id + contentFilterStr;
        if (!allcontents)
            queryStr = queryStr + "AND (airing_start BETWEEN DATE(" + startDate + ") AND DATE(" + endDate + ") OR " +
                                       "airing_end BETWEEN DATE(" + startDate + ") AND DATE(" + endDate + ") OR " +
                                       "DATE(" + startDate + ") BETWEEN airing_start AND airing_end OR " +
                                       "DATE(" + endDate + ") BETWEEN airing_start AND airing_end)";
        queryStr = queryStr + ") AS c, " +
                    "(SELECT content_group_id, SUM(airings) AS total_airings, SUM(spend) AS total_spend " +
                    "FROM contentg_airings ";
        if (!allcontents)
            queryStr = queryStr + "WHERE airing_date BETWEEN DATE(" + startDate + ") AND DATE(" + endDate + ") ";
        queryStr = queryStr + "GROUP BY content_group_id) AS cga " +
                    "WHERE c.content_group_id = cga.content_group_id " +
                    "ORDER BY c.airing_end DESC, c.airing_start DESC";

    //console.log(queryStr);
    return queryStr;
}

app.get('/content', function (req, res) {
    logUserAction("/content", req);
    
    var reqQ = req.query;
    var content_id = (typeof reqQ.contentId === 'undefined'? '': reqQ.contentId);
    
    handle_database(getContentDetailsQryStr(content_id, reqQ.paramN, reqQ.startDate, reqQ.endDate), res);
});

function getContentDetailsQryStr (content_id, paramN, startDate, endDate) {

    if (typeof startDate === 'undefined')
        startDate = "MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER";//"'2016-01-01'";
    else
        startDate = "'" + startDate + "'";

    if (typeof endDate === 'undefined')
        endDate = "CURDATE()";
    else
        endDate = "'" + endDate + "'";
        
    var queryStr =  "SELECT * from " +
                    "(SELECT content_id as id, content_id, content_title AS title, brand_id, brand_name AS brand, category_name as category, " +
                            "CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', content_id, '/poster.jpg') as thumbnail, " +
                            "CONCAT('http://cds.f2a7h7c4.hwcdn.net/advt_db/', content_id, '.mp4') as mp4_clip " +
                    "FROM content_productl_brandg_category " +
                    "WHERE content_id = " + content_id + ") as m, " +
                    "(SELECT SUM(airings) AS total_airings, COUNT(DISTINCT(tv_network)) AS uniq_network_cnt, " +
                            "COUNT(DISTINCT(show_title)) AS uniq_show_cnt, SUM(spend) AS total_spend, " +
                            "ROUND((SUM(airings)/getCategoryAirings((SELECT category_id FROM content_productl_brandg_category WHERE content_id = " + content_id + "), " +
                                                                    "GREATEST(Date(" + startDate + "), MIN(airing_date)), " +
                                                                    "LEAST(Date(" + endDate + "), MAX(airing_date)), false)) * 100, 2) as share_of_voice, " +
                            "GREATEST(Date(" + startDate + "), MIN(airing_date)) AS airing_start, LEAST(Date(" + endDate + "), MAX(airing_date)) AS airing_end " +
                    "FROM content_network_show_airings " +
                    "WHERE content_group_id = (SELECT content_group_id FROM content_productl_brandg_category WHERE content_id = " + content_id + ") " +
                          "AND airing_date BETWEEN DATE(" + startDate + ") AND Date(" + endDate + ") ";
                              
    switch (paramN) {
        case 'b': // Broadcast only
            queryStr = queryStr + 'AND tv_network IN (' + broadcastChannels + ') ';
            // not required for the subQueryBrand1 as we are using left join.
            break;
        case 'c': // Cable only
            queryStr = queryStr + 'AND tv_network NOT IN (' + broadcastChannels + ') ';
            break;
        default: // All Networks
            // No criteria required
    }
    queryStr = queryStr + ") as d";

    console.log(queryStr);
    return queryStr;
}

// reports page 
app.get('/reports', function(req, res) {
    logUserAction("/reports" , req);
    console.log("get action");
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    var linkedin = require('./util/linkedin');
    
    if (req.query.authenticate === 'true' || cookies['LIAccessToken'] || (req.query.state && req.query.code)){
        linkedin.OAuthValidation(req, res, '', serveReportsPage, config.hosturl + '/reports/');
    }
    else serveReportsPage(req, res);
});

var base64url = require('base64-url');
app.post('/reports', function(req, res) {
    logUserAction("/reports" , req, true);
    console.log("post action");
    console.log("req.body : " + JSON.stringify(req.body));
    var linkedin = require('./util/linkedin');
    var loggedinuser = linkedin.getUserId(req);
    lar = {};
    lar.id = 0;
    if (!isNaN(req.body.report_id)) lar.id = req.body.report_id;
    lar.brand_id = req.body.brand_id;
    lar.brand = req.body.brand_name;
    lar.ad_start_dt = req.body.airing_start_date;
    lar.ad_end_dt = req.body.airing_end_date;
    lar.contents = req.body.contents;
    lar.loc_start_dt = req.body.visit_start_date;
    lar.loc_end_dt = req.body.visit_end_date;
    lar.report_name = req.body.report_name;
    if (typeof loggedinuser === 'undefined') lar.created_by = '';
    else lar.created_by = loggedinuser;
    if (req.body.user_action == 'save') lar.status = "'draft'";
    else lar.status = "checkLARDraftOrNew('" + lar.created_by + "')";
    console.log(JSON.stringify(lar));
    createorSaveReport(lar, {"req":req, "res": res}, function(report_id, cbArgs){
        //console.log('report created with Id: ' + report_id); 
        //serveReportsPage(req, res, "Your report is being created. We'll mail you at " + loggedinuser + " when it's ready.");
        if (report_id < 1) {
            res.redirect('/reports/?um=' + base64url.encode("Error while creating report. Sorry about it. Please retry."));
        } else {
            getReportState(report_id, cbArgs, function(state, cbArgs){
                //console.log('state: ' + state);
                if (lar.status == "'draft'") // save request
                    res.redirect('/reports/?um=' + base64url.encode("Your report has been saved."));
                else if (state == 'draft')
                    res.redirect('/reports/?um=' + base64url.encode("You have exceeded the max number of location attribution reports queued for creation. Your report request have been saved. Please submit it later for processing."));
                else { // state == 'new'
                    if (typeof loggedinuser === 'undefined') res.redirect('/reports/?um=' + base64url.encode("Your report is being created. Please check back in a while."));
                    else res.redirect('/reports/?um=' + base64url.encode("Your report is being created. We'll mail you at " + loggedinuser + " when it's ready."));
                }
            });
            
        }
    });
});

var serveReportsPage = function (req, res, message) {
    //console.log(message + " : " + req.query.um);
    if ((typeof message === 'undefined' || message.length == 0) && req.query.um) {
        message = base64url.decode(req.query.um);
        //console.log(message);
    }
    var responseLock = 3;
    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req);
    var signedInUserFullName = linkedin.getUserFullName(req);
    var loggedinuser = linkedin.getUserId(req);

    var pageInputs = {brands: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName, usermsg: message, userid: loggedinuser};
    getReportList(false, pageInputs, function(rows, cbArgs){
        //console.log('reports: ' + JSON.stringify(rows));
        cbArgs.userreports = rows;
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/reports', cbArgs);
            console.log("1: rendering pages/reports/");
        }
    });
    
    getReportList(true, pageInputs, function(rows, cbArgs){
        //console.log('reports: ' + JSON.stringify(rows));
        cbArgs.precannedreports = rows;
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/reports', cbArgs);
            console.log("2: rendering pages/reports/");
        }
    });

    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/reports', cbArgs);
            console.log("3: rendering pages/reports/");
        }
    });
}

app.get('/reports/lar', function(req, res) {
    logUserAction("/reports/lar", req);
    
    // Check to see if authorization for end user has already been made
    var cookies = require('./util/cookie')(req);
    
    //console.log(req.query.authenticate);
    if (req.query.authenticate === 'true' || cookies['LIAccessToken']){
        var linkedin = require('./util/linkedin');
        linkedin.OAuthValidation(req, res, 'lar', serveCreateLARPage, config.hosturl + '/reports/');
    }
    else
        serveCreateLARPage(req, res);
});

var serveCreateLARPage = function (req, res, report_id) {
    var responseLock = 2;
    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req);
    var signedInUserFullName = linkedin.getUserFullName(req);

    var pageInputs = {brands: [], template: {}, config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName, report_id: 0};
    //pageInputs.larBrands = [191, 378, 681, 122, 1141, 245, 1179, 177, 332, 404, 213, 946, 624, 564, 600, 277, 205];
    pageInputs.larBrands = [3563,595,191,27666,20520,437,524,2089,3873,55897,378,550,681,20430,122,1318,1141,3207,245,50914,21309,2751,177,332,3601,46962,
                            1214,2434,404,213,1064,3938,7647,1827,224,21018,2662,624,32731,21726,20764,3036,1315,898,8672,726,1810,564,964,2269,3164,63816,
                            4178,395,941,436,63321,333,3040,34401,4673,719,675,372,8098,248,36784,832,2181,600,3333,277,26532,206,601,2591,205,22241,9203,7591];
    var lar_template_id = req.query.t;
    if (!isNaN(report_id)) { // This is an edit report request
        lar_template_id = report_id;
        pageInputs.report_id = report_id;
    }
    if (isNaN(lar_template_id)) responseLock--;
    else getReportTemplate(lar_template_id, pageInputs, function(report, cbArgs){
            cbArgs.template = report;
            responseLock--;
            if (responseLock == 0) {
                res.render('pages/createlar', cbArgs);
                console.log("1: rendering pages/createlar");
            }
        });

    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";// where brand_id in (191, 378, 681, 122, 1141, 245, 1179, 177, 332, 404, 213, 946, 624, 564, 600, 277, 205)";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/createlar', cbArgs);
            console.log("2: rendering pages/createlar");
        }
    });
}

app.get('/reports/lar/:report_id', function(req, res) {
    var report_id = req.params.report_id;
    logUserAction("/reports/lar/" + report_id , req);

    var linkedin = require('./util/linkedin');
    var loggedinuser = linkedin.getUserId(req);
    
    getReportState(report_id, report_id, function(state, cbArgs){
        //console.log('state: ' + state); console.log('report_id: ' + cbArgs);
        if (state == 'done')
            serveLARReportPage(req, res, cbArgs, null);
        else if (state == 'draft') // state == 'new'
            serveCreateLARPage(req, res, cbArgs);
        else
            res.redirect('/reports/');
    });
    
});

var serveLARReportPage = function (req, res, report_id, message) {
    
    var responseLock = 2;
    var linkedin = require('./util/linkedin');
    var isSignedIn = linkedin.isSignedIn(req);
    var signedInUserFullName = linkedin.getUserFullName(req);

    var pageInputs = {brands: [], config: config, isSignedIn: isSignedIn, signininfo: signedInUserFullName, usermsg: message, lar_id: report_id};
    
    getReport(report_id, pageInputs, function(report, cbArgs){
        cbArgs.report = JSON.stringify(report);
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/lar', cbArgs);
            console.log("1: rendering pages/reports/lar");
        }
    });
    
    var brandlistQuery = "SELECT brand_id, brand_name AS name FROM brand_list";
    executeQuery(brandlistQuery, pageInputs, function(rows, cbArgs){
        //console.log('brand_list: ' + JSON.stringify(rows));
        if (rows.length > 0) cbArgs.brands = JSON.stringify(rows);
        else cbArgs.brands = JSON.stringify(require('./util/brands'));
        responseLock--;
        if (responseLock == 0) {
            res.render('pages/lar', cbArgs);
            console.log("2: rendering pages/reports/lar");
        }
    });
}

//var server = app.listen(8000, function () {
var server = app.listen(config.serverport, function () {
    var host = server.address().address
    var port = server.address().port
    //console.log('Worker %d created listening at http://%s:%s.', cluster.worker.id, host, port);
    console.log('Worker created listening at http://%s:%s.', host, port);
})

//} // if (cluster.isMaster) else


/* Reporting services */
// TODO read from config file
var broadcastChannels = "'NBC', 'ABC', 'CBS', 'FOX', 'CW', 'Univision', 'Telemundo', 'Unimas', 'Telefutura', 'PBS', 'MyNetworkTV', 'ION'";
var coopbrands = require('./util/co-op-brands');
function getCoOpContentIds(brandId){
    var coopcontents = coopbrands[brandId];
    if (typeof coopcontents !== 'undefined' && coopcontents.length > 0)
        return coopcontents;
    else
        return [];
}

var coopcontents = require('./util/co-op-contents');
function getCoOpBrand(contentId){
    var coopbrand = coopcontents[contentId];
    //console.log(contentId + " : " + coopbrand);
    if (typeof coopbrand === 'undefined') coopbrand = '';
    return coopbrand;
}

/*
    Ref: https://codeforgeek.com/2015/01/nodejs-mysql-tutorial/
*/
var mysql = require('mysql');
/*var pool      =    mysql.createPool({
    connectionLimit : 10, //important
    //host     : 'localhost',
    host     : 'warehouse.alphonso.tv',
    port     : '3306',
    user     : 'warehouseuser',
    password : '1973Warehouse1@',
    database : 'dashboard'
});*/
var pool = mysql.createPool(config.mysql);

function handle_database(query, res) {

    pool.getConnection(function(err,connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          res.json({"code" : 100, "status" : "Error in connection database"});
          return;
        }   

        console.log('connected as id ' + connection.threadId);
        
        connection.query(query,function(err,rows){
            connection.release();
            if(!err) {
                console.log('Returning response of size: %d', rows.length);
                res.json(rows);
            }
            else console.log(err.stack);
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              res.json({"code" : 100, "status" : "Error in connection database"});
              return;     
        });
    });
}

function executeQuery(query, cbArgs, cb) {
    
    //console.log(query);
    pool.getConnection(function(err,connection){
        if (err) {
          console.log(err.stack);
          connection.release();
          throw err;
        }   

        console.log('connected as id ' + connection.threadId);
        
        connection.query(query,function(err,rows){
            connection.release();
            if(!err) {
                console.log('Returning response of size: %d', rows.length);
                //console.log(rows);
                if (typeof(cb) !== 'undefined' && cb !== null) cb(rows, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
            console.log(err.stack);
            throw err;
        });
    });
}

//function get_ad_brand_network_query (req, transformer){
function execute_ad_brand_network_query (req, cbargs, cb1, cb2){
        //console.log('request received: ' + JSON.stringify(req.query));
        var reqQ = req.query;

        var brand = (typeof reqQ.paramB === 'undefined'? '':reqQ.paramB.replace(/'/g, "\\'"));
        var ad_title = (typeof reqQ.paramAdTitle === 'undefined'? '':reqQ.paramAdTitle.replace(/'/g, "\\'"));
        var content_id = (typeof reqQ.contentId === 'undefined'? '': reqQ.contentId);
        
        var numRecToFetch = 1000;
        if (!isNaN(reqQ.limit)) {
            try {
                numRecToFetch = parseInt(reqQ.limit);
            } catch (err) {
                console.log("The limit param is not a valid number: " + err.message); // Not sure if this code block is reachable at all
            }
        }
        
        //if (typeof transformer !== 'undefined' && transformer != null){
        if (typeof cbargs.dataTransformer !== 'undefined' && cbargs.dataTransformer != null){
            numRecToFetch = 1000;
            if (brand != '') cbargs.dataTransformer['b1'] = brand;
            else cbargs.dataTransformer['b1'] = ad_title;
        }
        
    /*request(getRequestURL("/raw_similar_by_id?id=" + content_id), function(error, response, body) {
        console.log(body);
        var content_id_str = content_id;
        if(body != 'undefined' && body != null && body.length > 0) {
            var similarContents = JSON.parse(body);
            for (var i = 0; i < similarContents.length; i++){
                content_id_str = content_id_str + ', ' + similarContents[i].content_id;
            }
        }*/
        
        var queryStr =  'select tv_network as cat, sum(airings) as b1 ' +
                        'from content_network_airings ' +
                        //'where content_title = \'' + ad_title + '\' AND brand = \'' + brand + '\' ' +
                        //'where content_id in (' + content_id_str + ') ' +
                        'where content_group_id = (SELECT content_group_id FROM content_productl_brandg_category WHERE content_id = ' + content_id + ') ' +
                              'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ';                                    
        switch (reqQ.paramN) {
            case 'b': // Broadcast only
                queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
                // not required for the subQueryBrand1 as we are using left join.
                break;
            case 'c': // Cable only
                queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
                break;
            default: // All Networks
                // No criteria required
        }


	    queryStr = queryStr + 'group by tv_network order by b1 desc limit ' + numRecToFetch;
        
        console.log(queryStr);
        //return queryStr;
        cb1(queryStr, cbargs, cb2);
    //});
}

//function get_ad_brand_network_show_query (req, transformer){
function execute_ad_brand_network_show_query (req, cbargs, cb1, cb2){
        /*var data = [{
         "cat": "Today",
         "b1": "202"
         }];*/
        //console.log('request received: ' + JSON.stringify(req.query));
        var reqQ = req.query;

        var brand = (typeof reqQ.paramB === 'undefined'? '':reqQ.paramB.replace(/'/g, "\\'"));
        var ad_title = (typeof reqQ.paramAdTitle === 'undefined'? '': reqQ.paramAdTitle.replace(/'/g, "\\'"));
        var content_id = (typeof reqQ.contentId === 'undefined'? '': reqQ.contentId);
        var numRecToFetch = 1000;
        if (!isNaN(reqQ.limit)) {
            try {
                numRecToFetch = parseInt(reqQ.limit);
            } catch (err) {
                console.log("The limit param is not a valid number: " + err.message); // Not sure if this code block is reachable at all
            }
        }
        
        //if (typeof transformer !== 'undefined' && transformer != null){
        if (typeof cbargs.dataTransformer !== 'undefined' && cbargs.dataTransformer != null){
            numRecToFetch = 1000;
            if (brand != '') cbargs.dataTransformer['b1'] = brand;
            else cbargs.dataTransformer['b1'] = ad_title;
        }
        
    /*request(getRequestURL("/raw_similar_by_id?id=" + content_id), function(error, response, body) {
        console.log(body);
        var content_id_str = content_id;
        if(body != 'undefined' && body != null && body.length > 0) {
            var similarContents = JSON.parse(body);
            for (var i = 0; i < similarContents.length; i++){
                content_id_str = content_id_str + ', ' + similarContents[i].content_id;
            }
        }*/
        
        var queryStr =  'select show_title as cat, sum(airings) as b1 ';
        
        queryStr =  queryStr + 'from content_network_show_airings ' +
                               //'where content_title = \'' + ad_title + '\' AND brand = \'' + brand + '\' and show_name not in (\'undefined\', \'Paid Programming\') ' +
                               //'where content_id in (' + content_id_str + ') and show_title not in (\'undefined\', \'Paid Programming\') ' +
                               'where content_group_id = (SELECT content_group_id FROM content_productl_brandg_category WHERE content_id = ' + content_id + ') ' +
                               //'and show_title not in (\'undefined\', \'Paid Programming\', \'null\', \'sign off\') ' +
                                   'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ';                                    
        switch (reqQ.paramN) {
            case 'b': // Broadcast only
                queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
                // not required for the subQueryBrand1 as we are using left join.
                break;
            case 'c': // Cable only
                queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
                break;
            default: // All Networks
                // No criteria required
        }

	    queryStr = queryStr + 'group by show_title order by b1 desc limit ' + numRecToFetch;
        
        console.log(queryStr);
        //return queryStr;
        cb1(queryStr, cbargs, cb2);
    //});
}


function get_brand_network_query (req, transformer){
        /*var data = [{
         "cat": "ABC",
         "b1": "202",
         "b2": "189",
         "b3": "25"
         }];*/
        //console.log('request received: ' + JSON.stringify(req.query));
        var reqQ = req.query;
        /*
        select aggregateData.network as cat, aggregateData.b1 as b1, aggregateData.b2 as b2, ifnull(brand.airings, 0) as b3, (aggregateData.airings - ifnull(brand.airings, 0)) as b4 
        from (	select aggregateData.network as network, aggregateData.b1 as b1, ifnull(brand.airings, 0) as b2, (aggregateData.airings - ifnull(brand.airings, 0)) as airings 
                from (	select aggregateData.network as network, ifnull(brand.airings, 0) as b1, (aggregateData.airings - ifnull(brand.airings, 0)) as airings 
                        from (	select network, sum(airings) as airings 
                                from brand_network_tmp 
                                where 	brand in ('Audi', 'BMW', 'Ford', 'Hyundai') 
                                    and airing_date between Date('2015-12-01') and Date('2015-12-31') 
                                group by network order by airings desc limit 10) as aggregateData 
                            left join 
                            (	select network, sum(airings) as airings 
                                from brand_network_tmp 
                                where 	brand = 'Audi' 
                                    and airing_date between Date('2015-12-01') and Date('2015-12-31') 
                                group by network) as brand 
                            on aggregateData.network = brand.network) as aggregateData 
                    left join 
                    (	select network, sum(airings) as airings 
                        from brand_network_tmp 
                        where 	brand = 'BMW' 
                            and airing_date between Date('2015-12-01') and Date('2015-12-31') 
                        group by network) as brand 
                    on aggregateData.network = brand.network) as aggregateData 
            left join 
            (	select network, sum(airings) as airings 
                from brand_network_tmp 
                where 	brand = 'Ford' 
                    and airing_date between Date('2015-12-01') and Date('2015-12-31') 
                group by network) as brand 
            on aggregateData.network = brand.network;
        */
        var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
        var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
        var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
        var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
        var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
        var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
        var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
        var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
        var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
        var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
        var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
        var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);
        var numRecToFetch = 1000;
        var paramCO = reqQ.paramCO;
        var specificCoOp = false; if (!isNaN(paramCO)) specificCoOp = true;
        
        if (!isNaN(reqQ.limit)) {
            try {
                numRecToFetch = parseInt(reqQ.limit);
            } catch (err) {
                console.log("The limit param is not a valid number: " + err.message); // Not sure if this code block is reachable at all
            }
        }
        
        if (typeof transformer !== 'undefined' && transformer != null){
            numRecToFetch = 1000;
            if (brand1 != '') transformer['b1'] = brand1;
            if (brand2 != '') transformer['b2'] = brand2;
            if (brand3 != '') transformer['b3'] = brand3;
            if (brand4 != '') transformer['b4'] = brand4;
            if (brand5 != '') transformer['b5'] = brand5;
            if (brand6 != '') transformer['b6'] = brand6;
        }
        
        var brands = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
        var numBrands = 0;
        var brandAggrInStr = '';
        for (brandIdx in brands) {
            var brand = brands[brandIdx];
            if (brand == '')
                break;
            
            var isDup = false;
            for (var j = 0; j < numBrands; j++) {
                if (brand == brands[j]) { // if duplicate found
                    isDup = true;
                    brands[brandIdx] = ''; // Empty brand name will result in 0 rows returned in the Brand Query later.
                    break;
                }
            }
            
            numBrands++; // add to the number of Brands in the request query
            
            if (isDup) continue; // Adding the brand in the SQL IN statement can be avoided
            
            if (numBrands > 1) // add a comma from 2nd brands onwards
                 brandAggrInStr = brandAggrInStr + ', ';
            brandAggrInStr = brandAggrInStr +  brand;
        }
        
        var queryStr =  'select tv_network as network, sum(airings) as airings ';
        var orderByClause = ' order by (';
        if (numBrands == 1) {
            queryStr =  'select tv_network as cat, sum(airings) as b1 ';
            orderByClause = '';
        }
        
        queryStr =  queryStr + 'from brand_network_airings ';
        if (specificCoOp)
        queryStr =  queryStr + 'where ((coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + paramCO + ') or ' +
                                      '(brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + paramCO + ')) ';
        else 
        queryStr =  queryStr + 'where brand_id in (' + brandAggrInStr + ') ';
        queryStr =  queryStr +     'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ';

        switch (reqQ.paramN) {
            case 'b': // Broadcast only
                queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
                break;
            case 'c': // Cable only
                queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
                break;
            default: // All Networks
                // No criteria required
        }

        if (numBrands == 1){
            queryStr = queryStr + 'group by tv_network order by b1 desc limit ' + numRecToFetch;
        } else {
            queryStr = queryStr + 'group by network order by airings desc limit ' + numRecToFetch;
        }

        var subQueryAggregateData = queryStr;
        for (var i = 0; (numBrands - i) > 1; i++) { // for 2 and more brands, loop only till 2nd last brand
            var brand = brands[i];
            var networkColNameOut = 'network';
            var numAiringsColNameOut = 'airings';
           
            orderByClause = orderByClause + 'b' + (i+1) + ' + ';
            
            if((numBrands - i) == 2) { // we are on the 2nd last brand
                networkColNameOut = 'cat';
                numAiringsColNameOut = 'b' + numBrands;
                orderByClause = orderByClause + 'b' + numBrands + ') desc';
            }
            
            var subQueryBrand = 'select tv_network as network, sum(airings) as airings ' +
                    'from brand_network_airings ';
            if (specificCoOp)
            subQueryBrand = subQueryBrand + 'where ((coop_brand_id = ' + brand + ' and brand_id = ' + paramCO + ') or ' +
                                                   '(brand_id = ' + brand + ' and coop_brand_id = ' + paramCO + ')) ';
            else
            subQueryBrand = subQueryBrand + 'where brand_id = ' + brand + ' ';
            subQueryBrand = subQueryBrand + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ' +
                    'group by network';
            
            queryStr = 'select aggregateData.network as ' + networkColNameOut + ', ';// select aggregateData.network as network(or cat),
            
            for (var j = 0; j < i; j++) {
                queryStr = queryStr + 'aggregateData.b' + (j+1) + ' as b' + (j+1) + ', ';//aggregateData.b1 as b1
            }
            
            queryStr = queryStr + 'ifnull(brand.airings, 0) as b' + (i+1) + ', ';//ifnull(brand.airings, 0) as b2
            
            queryStr = queryStr + '(aggregateData.airings - ifnull(brand.airings, 0)) as ' + numAiringsColNameOut + ' ' +
                       'from (' + subQueryAggregateData + ') as aggregateData left join (' + subQueryBrand + ') as brand on aggregateData.network = brand.network';
            
            subQueryAggregateData = queryStr;    
        }

        queryStr = queryStr + orderByClause;

        console.log(queryStr);
        return queryStr;
}

function get_brand_network_show_query (req, transformer){
        /*var data = [{
         "cat": "Today",
         "b1": "202",
         "b2": "189"
         }];*/
        //console.log('request received: ' + JSON.stringify(req.query));
        var reqQ = req.query;
        /*
        select aggregateData.show_name as cat, ifnull(brand1.airings, 0) as b1, (aggregateData.airings - ifnull(brand1.airings, 0)) as b2
        from	(select show_name, sum(airings) as airings
                from brand_network_show_tmp
                where 	brand in ('Audi', 'BMW')
                    and show_name not in ('undefined', 'Paid Programming')
                    and airing_date between Date('2015-12-01') and Date('2015-12-31')
                group by show_name) as aggregateData
            left join
                (select show_name, sum(airings) as airings
                from brand_network_show_tmp
                where 	brand = 'Audi'
                    and airing_date between Date('2015-12-01') and Date('2015-12-31')
                group by show_name) as brand1
            on aggregateData.show_name = brand1.show_name
        order by aggregateData.airings desc limit 10;
        */
        var brand1 = (typeof reqQ.param1 === 'undefined'? '':reqQ.param1.replace(/'/g, "\\'"));
        var brand_id1 = (typeof reqQ.brand_id1 === 'undefined'? '': reqQ.brand_id1);
        var brand2 = (typeof reqQ.param2 === 'undefined'? '':reqQ.param2.replace(/'/g, "\\'"));
        var brand_id2 = (typeof reqQ.brand_id2 === 'undefined'? '': reqQ.brand_id2);
        var brand3 = (typeof reqQ.param3 === 'undefined'? '':reqQ.param3.replace(/'/g, "\\'"));
        var brand_id3 = (typeof reqQ.brand_id3 === 'undefined'? '': reqQ.brand_id3);
        var brand4 = (typeof reqQ.param4 === 'undefined'? '':reqQ.param4.replace(/'/g, "\\'"));
        var brand_id4 = (typeof reqQ.brand_id4 === 'undefined'? '': reqQ.brand_id4);
        var brand5 = (typeof reqQ.param5 === 'undefined'? '':reqQ.param5.replace(/'/g, "\\'"));
        var brand_id5 = (typeof reqQ.brand_id5 === 'undefined'? '': reqQ.brand_id5);
        var brand6 = (typeof reqQ.param6 === 'undefined'? '':reqQ.param6.replace(/'/g, "\\'"));
        var brand_id6 = (typeof reqQ.brand_id6 === 'undefined'? '': reqQ.brand_id6);
        var numRecToFetch = 1000;
        var paramCO = reqQ.paramCO;
        var specificCoOp = false; if (!isNaN(paramCO)) specificCoOp = true;
        if (!isNaN(reqQ.limit)) {
            try {
                numRecToFetch = parseInt(reqQ.limit);
            } catch (err) {
                console.log("The limit param is not a valid number: " + err.message); // Not sure if this code block is reachable at all
            }
        }
        
        if (typeof transformer !== 'undefined' && transformer != null){
            numRecToFetch = 1000;
            if (brand1 != '') transformer['b1'] = brand1;
            if (brand2 != '') transformer['b2'] = brand2;
            if (brand3 != '') transformer['b3'] = brand3;
            if (brand4 != '') transformer['b4'] = brand4;
            if (brand5 != '') transformer['b5'] = brand5;
            if (brand6 != '') transformer['b6'] = brand6;
        }
        
        //var brands = [brand1, brand2, brand3, brand4, brand5, brand6];
        var brands = [brand_id1, brand_id2, brand_id3, brand_id4, brand_id5, brand_id6];
        var numBrands = 0;
        var brandAggrInStr = '';
        for (brandIdx in brands) {
            var brand = brands[brandIdx];
            if (brand == '')
                break;
            
            var isDup = false;
            for (var j = 0; j < numBrands; j++) {
                if (brand == brands[j]) { // if duplicate found
                    isDup = true;
                    brands[brandIdx] = ''; // Empty brand name will result in 0 rows returned in the Brand Query later.
                    break;
                }
            }
            
            numBrands++; // add to the number of Brands in the request query
            
            if (isDup) continue; // Adding the brand in the SQL IN statement can be avoided
            
            if (numBrands > 1) // add a comma from 2nd brands onwards
                 brandAggrInStr = brandAggrInStr + ', ';
            //brandAggrInStr = brandAggrInStr + '\'' + brand  + '\'';
            brandAggrInStr = brandAggrInStr +  brand;
        }
        
        var queryStr =  'select show_title, sum(airings) as airings ';
        var orderByClause = ' order by (';
        if (numBrands == 1) {
            queryStr =  'select show_title as cat, sum(airings) as b1 ';
            orderByClause = '';
        }
        
        queryStr =  queryStr + 'from brand_network_show_airings ';
        if (specificCoOp)
        //queryStr =  queryStr + 'where coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + paramCO + ' ';
        queryStr =  queryStr + 'where ((coop_brand_id in (' + brandAggrInStr + ') and brand_id = ' + paramCO + ') or ' +
                                      '(brand_id in (' + brandAggrInStr + ') and coop_brand_id = ' + paramCO + ')) ';
        else 
        queryStr =  queryStr + 'where brand_id in (' + brandAggrInStr + ') ';
        queryStr =  queryStr +     'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ';

        switch (reqQ.paramN) {
            case 'b': // Broadcast only
                queryStr = queryStr + 'and tv_network in (' + broadcastChannels + ') ';
                // not required for the subQueryBrand1 as we are using left join.
                break;
            case 'c': // Cable only
                queryStr = queryStr + 'and tv_network not in (' + broadcastChannels + ') ';
                break;
            default: // All Networks
                // No criteria required
        }
        if (numBrands ==1) {
            queryStr = queryStr + 'group by show_title order by b1 desc limit ' + numRecToFetch;
        } else {
            queryStr = queryStr + 'group by show_title order by airings desc limit ' + numRecToFetch;
        }

        var subQueryAggregateData = queryStr;
        for (var i = 0; (numBrands - i) > 1; i++) { // for 2 and more brands
            var brand = brands[i];
            var showColNameOut = 'show_title';
            var numAiringsColNameOut = 'airings';
            
            orderByClause = orderByClause + 'b' + (i+1) + ' + ';
            
            if((numBrands - i) == 2) { // we are on the 2nd last brand
                showColNameOut = 'cat';
                numAiringsColNameOut = 'b' + numBrands;
                orderByClause = orderByClause + 'b' + numBrands + ') desc';
            }
            
            var subQueryBrand = 'select show_title, sum(airings) as airings ' +
                    'from brand_network_show_airings ';
            if (specificCoOp)
            //subQueryBrand = subQueryBrand + 'where coop_brand_id = ' + brand + ' and brand_id = ' + paramCO + ' ';
            subQueryBrand = subQueryBrand + 'where ((coop_brand_id = ' + brand + ' and brand_id = ' + paramCO + ') or ' +
                                                   '(brand_id = ' + brand + ' and coop_brand_id = ' + paramCO + ')) ';
            else
            subQueryBrand = subQueryBrand + 'where brand_id = ' + brand + ' ';
            subQueryBrand = subQueryBrand + 'and airing_date between Date(\'' + reqQ.startDate + '\') and Date(\'' + reqQ.endDate + '\') ';
                        
            switch (reqQ.paramN) {
                case 'b': // Broadcast only
                    subQueryBrand = subQueryBrand + 'and tv_network in (' + broadcastChannels + ') ';
                    // not required for the subQueryBrand1 as we are using left join.
                    break;
                case 'c': // Cable only
                    subQueryBrand = subQueryBrand + 'and tv_network not in (' + broadcastChannels + ') ';
                    break;
                default: // All Networks
                    // No criteria required
            }
                        
            subQueryBrand = subQueryBrand + 'group by show_title';
            
            queryStr = 'select aggregateData.show_title as ' + showColNameOut + ', ';// select aggregateData.network as network(or cat),
            
            for (var j = 0; j < i; j++) {
                queryStr = queryStr + 'aggregateData.b' + (j+1) + ' as b' + (j+1) + ', ';//aggregateData.b1 as b1
            }
            
            queryStr = queryStr + 'ifnull(brand.airings, 0) as b' + (i+1) + ', ';//ifnull(brand.airings, 0) as b2
            
            queryStr = queryStr + '(aggregateData.airings - ifnull(brand.airings, 0)) as ' + numAiringsColNameOut + ' ' +
                       'from (' + subQueryAggregateData + ') as aggregateData left join (' + subQueryBrand + ') as brand on aggregateData.show_title = brand.show_title';
            
            subQueryAggregateData = queryStr;    
        }
        
        queryStr = queryStr + orderByClause;
        
        console.log(queryStr);
        return queryStr;
}


var reportsDB = mysql.createPool(config.mysql.reports);

function sendReportsNotification (){

    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching reports");
          throw err;
        }

        console.log('connected as id ' + connection.threadId);
        var queryStr = "SELECT q.id as report_id, q.report_name, q.created_by, UPPER(q.brand) as brand_name, isStasticallySignificant(q.id) AS isValid, " +
                              "CONCAT(DATE_FORMAT(q.ad_start_dt,'%b %e, %Y'), ' - ', DATE_FORMAT(q.ad_end_dt,'%b %e, %Y')) as airing_dates, " +
                              "CONCAT(DATE_FORMAT(q.loc_start_dt,'%b %e, %Y'), ' - ', DATE_FORMAT(q.loc_end_dt,'%b %e, %Y')) as visit_dates " +
                       "FROM queue_location_attrib_query as q, results_of_location_attrib_query as r " +
                       "WHERE q.id = r.queue_id AND q.env = '" + config.env + "' AND q.notified IS FALSE  AND q.created_by <> '' AND q.created_by <> 'system'";

        //console.log(queryStr);
        connection.query(queryStr, [], function(err,results,field){
            if(!err) {
                console.log('Num new reports: %d', results.length);
                if (results.length > 0) {
                    var reports = results;
                    var idStr = '';
                    for (var i = 0; i < reports.length; i++){
                        var report = reports[i];
                        var mailDetails = {};
                        mailDetails.toAddress = report.created_by;
                        mailDetails.report_name = report.report_name;
                        mailDetails.brand_name = report.brand_name;
                        mailDetails.airing_dates = report.airing_dates;
                        mailDetails.visit_dates = report.visit_dates;
                        mailDetails.isValid = report.isValid;
                        mailDetails.reportsurl = config.hosturl + '/reports/lar/' + report.report_id;
                        emailClient.sendLARReportNotification(mailDetails);
                        if (i > 0) idStr = idStr + "," + report.report_id;
                        else idStr = report.report_id;
                    }
                    queryStr = "UPDATE queue_location_attrib_query SET notified = TRUE WHERE id IN (" + idStr + ")";
                    console.log(queryStr);
                    connection.query(queryStr, [], function(err,results,field){
                        connection.release();
                        if (err) {
                            console.log(err.stack);
                            throw err;
                        }
                    });
                } else {
                    connection.release();
                }
            } else {
                connection.release();
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching reports");
              throw err;
        });
    });
}

setInterval(sendReportsNotification, 60000); // Check for new reports every 1 min = 60 sec

function createorSaveReport(lar, cbArgs, cb) { // Location attribution report

    var report_id = -1;
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error creating report: " + JSON.stringify(lar));
          throw err;
        }

        console.log('connected as id ' + connection.threadId);

        if (lar.id > 0) {
            var updateStmt = "UPDATE queue_location_attrib_query SET brand_id = " + lar.brand_id + ", brand = '" + lar.brand.replace(/'/g, "\\'") + "', " +
                                                                        "ad_start_dt = '" + lar.ad_start_dt + "', ad_end_dt = '" + lar.ad_end_dt + "', " +
                                                                        "loc_start_dt = '" + lar.loc_start_dt + "', loc_end_dt = '" + lar.loc_end_dt + "', " +
                                                                        "`status` = " + lar.status + ", report_name = '" + lar.report_name.replace(/'/g, "\\'") + "', " +
                                                                        "contents = '" + lar.contents + "' WHERE id = " + lar.id;
            console.log(updateStmt);
            connection.query(updateStmt, function(err,results,field){
                connection.release();
                if(!err) {
                    var numRowChanged = results.changedRows;
                    console.log('Report updated with id: %d , status: %d', lar.id, numRowChanged);
                    if (typeof cb !== 'undefined' && cb !== null) cb(lar.report_id, cbArgs);
                }
                else {
                    console.log(err.stack);
                    throw err;
                }
            });

        } else {
            //connection.query('INSERT INTO queue_location_attrib_query SET ?', lar, function(err,results,field){
            var insertStmt = "INSERT INTO queue_location_attrib_query SET id = 0, brand_id = " + lar.brand_id + ", brand = '" + lar.brand.replace(/'/g, "\\'") + "', " +
                                                                        "ad_start_dt = '" + lar.ad_start_dt + "', ad_end_dt = '" + lar.ad_end_dt + "', " +
                                                                        "loc_start_dt = '" + lar.loc_start_dt + "', loc_end_dt = '" + lar.loc_end_dt + "', " +
                                                                        //"`status` = checkLARDraftOrNew('" + lar.created_by + "'), report_name = '" + lar.report_name + "', " +
                                                                        "`status` = " + lar.status + ", report_name = '" + lar.report_name.replace(/'/g, "\\'") + "', " +
                                                                        "contents = '" + lar.contents + "', created_by = '" + lar.created_by + "', env = '" + config.env + "'";
            console.log(insertStmt);
            connection.query(insertStmt, function(err,results,field){
                connection.release();
                if(!err) {
                    report_id = results.insertId;
                    console.log('Report created with id: %d', report_id);
                    if (typeof cb !== 'undefined' && cb !== null) cb(report_id, cbArgs);
                }
                else {
                    console.log(err.stack);
                    throw err;
                }
            });
        }

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error creating report: " + JSON.stringify(lar));
              throw err;
        });
    });
}

function getReportTemplate(report_id, cbArgs, cb) { // Location attribution report

    var report = {};
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching report: " + report_id);
          throw err;
        }

        console.log('connected as id ' + connection.threadId);

        connection.query('SELECT report_name, brand_id, brand as brand_name, DATE_FORMAT(ad_start_dt, "%m/%d/%Y") as airing_start, DATE_FORMAT(ad_end_dt, "%m/%d/%Y") as airing_end, ' +
                                'DATE_FORMAT(loc_start_dt, "%m/%d/%Y") as visit_start, DATE_FORMAT(loc_end_dt, "%m/%d/%Y") as visit_end, contents FROM queue_location_attrib_query WHERE id = ?',
                        [report_id], function(err,results,field){
            connection.release();
            if(!err) {
                //console.log('Report obtained: ', JSON.stringify(results));
                if (results.length > 0) report = results[0];
                if (typeof(cb) !== 'undefined' && cb !== null) cb(report, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching report: " + report_id);
              throw err;    
        });
    });
}

function getReport(report_id, cbArgs, cb) { // Location attribution report

    var report = {};
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching report: " + report_id);
          throw err;
        }

        console.log('connected as id ' + connection.threadId);

        connection.query('SELECT r.brand_id, r.brand as brand_name, DATE_FORMAT(r.ad_start_dt, "%m/%d/%Y") as airing_start, DATE_FORMAT(r.ad_end_dt, "%m/%d/%Y") as airing_end, ' +
                                'DATE_FORMAT(r.loc_start_dt, "%m/%d/%Y") as visit_start, DATE_FORMAT(r.loc_end_dt, "%m/%d/%Y") as visit_end, r.visit_rate_exposed, r.visit_rate_unexposed, ' +
                                'r.lift, q.report_name, q.contents FROM results_of_location_attrib_query as r, queue_location_attrib_query as q WHERE r.queue_id = ? and q.id = ?',
                        [report_id, report_id], function(err,results,field){
            connection.release();
            if(!err) {
                //console.log('Report obtained: ', JSON.stringify(results));
                if (results.length > 0) report = results[0];
                if (typeof(cb) !== 'undefined' && cb !== null) cb(report, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching report: " + report_id);
              throw err;    
        });
    });
}

function getReportState(report_id, cbArgs, cb) { // Location attribution report

    var state = '';
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching report: " + report_id);
          throw err;
        }

        console.log('connected as id ' + connection.threadId);

        connection.query('SELECT `status` AS state FROM queue_location_attrib_query WHERE id = ?',
                        [report_id], function(err,results,field){
            connection.release();
            if(!err) {
                //console.log('Report obtained: ', JSON.stringify(results));
                if (results.length > 0) state = results[0].state;
                if (typeof(cb) !== 'undefined' && cb !== null) cb(state, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching report: " + report_id);
              throw err;    
        });
    });
}

function getReportList(precanned, cbArgs, cb) { // Location attribution report

    var reports = [];
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching reports");
          throw err;
        }

        console.log('connected as id ' + connection.threadId);
        var queryStr = "SELECT q.id as report_id, q.report_name, q.brand_id, UPPER(q.brand) as brand_name, DATE_FORMAT(q.created_on,'%b %e, %Y') as create_date, " +
                                "CONCAT(DATE_FORMAT(q.ad_start_dt,'%b %e, %Y'), ' - ', DATE_FORMAT(q.ad_end_dt,'%b %e, %Y')) as airing_dates, " +
                                "CONCAT(DATE_FORMAT(q.loc_start_dt,'%b %e, %Y'), ' - ', DATE_FORMAT(q.loc_end_dt,'%b %e, %Y')) as visit_dates, q.status AS report_status, " +
                                "(CASE WHEN(r.lift > 0)THEN CONCAT(ROUND(r.lift, 2), '%') ELSE '' END) as lift, isStasticallySignificant(q.id) AS isValid " +
                         "FROM queue_location_attrib_query as q left join results_of_location_attrib_query as r on q.id = r.queue_id ";

        if (precanned) {
                queryStr = queryStr + "WHERE q.created_by = 'system' and isStasticallySignificant(q.id) IS TRUE " +
                                      "ORDER BY q.ad_start_dt desc, brand_name";
        } else {
            if (typeof cbArgs.userid !== 'undefined' && cbArgs.userid != null)
                queryStr = queryStr + "where q.created_by = '" + cbArgs.userid + "' ";
            else
                queryStr = queryStr + "where q.created_by ='' ";
            queryStr = queryStr + "AND q.env = '" + config.env + "' ORDER BY report_id desc";
        }
        console.log(queryStr);
        connection.query(queryStr, [], function(err,results,field){
            connection.release();
            if(!err) {
                //console.log('Report obtained: ', JSON.stringify(results));
                if (results.length > 0) reports = results;
                if (typeof(cb) !== 'undefined' && cb !== null) cb(reports, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching reports");
              throw err;
        });
    });
}

function getBrandLarReport(brand_id, cbArgs, cb) { // Location attribution report

    var report = {};
    reportsDB.getConnection(function(err, connection){
        if (err) {
          console.log(err.stack);
          if (typeof connection !== 'undefined') connection.release();
          console.log("Error fetching reports");
          throw err;
        }

        console.log('connected as id ' + connection.threadId);
        var queryStr = "SELECT q.id AS report_id, q.report_name, q.brand_id, q.brand AS brand_name, " +
                              "DATE_FORMAT(q.ad_start_dt, '%m/%d/%Y') as airing_start, DATE_FORMAT(q.ad_end_dt, '%m/%d/%Y') as airing_end, " +
                              "DATE_FORMAT(q.loc_start_dt, '%m/%d/%Y') as visit_start, DATE_FORMAT(q.loc_end_dt, '%m/%d/%Y') as visit_end, " +
                              "ROUND(r.lift, 2) AS lift, r.visit_rate_exposed, r.visit_rate_unexposed " +
                       "FROM queue_location_attrib_query AS q, results_of_location_attrib_query AS r " +
                       "WHERE q.id = r.queue_id AND q.created_by = 'system' AND q.brand_id = " + brand_id + " AND " +
                       "isStasticallySignificant(q.id) IS TRUE " +
                       "ORDER BY report_id desc";
        //console.log(queryStr);
        connection.query(queryStr, [], function(err,results,field){
            connection.release();
            if(!err) {
                //console.log('Report obtained: ', JSON.stringify(results));
                if (results.length > 0) report = results[0];
                if (typeof(cb) !== 'undefined' && cb !== null) cb(report, cbArgs);
            } else {
                console.log(err.stack);
                throw err;
            }
        });

        connection.on('error', function(err) {
              console.log(err.stack);
              console.log("Error fetching reports");
              throw err;
        });
    });
}