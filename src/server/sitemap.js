var config = require('./app-config');

// init request module for backend http API calls
var request = require("request");

function getRequestURL(url) {
    return config.backendapiurl + url;
}

function getSEOurl (baseurl, id, name) {
    return baseurl + id + '-' + name.replace(/\s/g, '-').replace(/\//g, '').replace(/\%/g, 'percent');
}

var brands;
request(getRequestURL("/list_brands"), function(error, response, body) {
    //console.log(body);
    brands = JSON.parse(body);
    /*for (var i = 0; i < brands.length; i++){
        var brandURL = getSEOurl (config.hosturl + '/brand/', brands[i].brand_id, brands[i].name);
        console.log(brandURL);
        request(getRequestURL("/list_content_by_brand?id=" + brands[i].brand_id), function(error, response, body) {
            //console.log(body);
            if (typeof body === 'undefined') {
                //console.log(body);
                return;
            }
            var contents = JSON.parse(body);
            for (var j = 0; j < contents.length; j++){
                var contentURL = getSEOurl (config.hosturl + '/commercial/', contents[j].id, contents[j].title);
                console.log(contentURL);
            }
        });
    }*/
    getBrandCommercials(0);
});

function getBrandCommercials(i){
    var brandURL = getSEOurl (config.hosturl + '/brand/', brands[i].brand_id, brands[i].name);
    console.log(brandURL);
    request(getRequestURL("/list_content_by_brand?id=" + brands[i].brand_id), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') {
            var contents = JSON.parse(body);
            for (var j = 0; j < contents.length; j++){
                var contentURL = getSEOurl (config.hosturl + '/commercial/', contents[j].id, contents[j].title);
                console.log(contentURL);
            }
        }
        var nextIndex = i + 1;
        if (nextIndex < brands.length) getBrandCommercials(nextIndex);
    });
}


