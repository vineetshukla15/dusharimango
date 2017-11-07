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
    //console.log(brandURL);
    request(getRequestURL("/list_content_by_brand?id=" + brands[i].brand_id), function(error, response, body) {
        //console.log(body);
        if (typeof body !== 'undefined') {
            var contents = JSON.parse(body);
            for (var j = 0; j < contents.length; j++){
                /*var contentURL = getSEOurl (config.hosturl + '/commercial/', contents[j].id, contents[j].title);
                if (typeof contents[j].title === 'undefined' || contents[j].title == null || contents[j].title == 'null' || //contents[j].title == '' ||
                    typeof contents[j].brand === 'undefined' || contents[j].brand == null || contents[j].brand == 'null' || //contents[j].brand == '' ||
                    typeof contents[j].category === 'undefined' || contents[j].category == null || contents[j].category == 'null' || //contents[j].category == '' ||
                    typeof contents[j].brand_id === 'undefined' || contents[j].brand_id == null || contents[j].brand_id == 'null' || //contents[j].brand_id == '' ||
                    typeof contents[j].poster === 'undefined' || contents[j].poster == null || contents[j].poster == 'null' || //contents[j].poster == '' ||
                    typeof contents[j].mp4_clip === 'undefined' || contents[j].mp4_clip == null || contents[j].mp4_clip == 'null' || //contents[j].mp4_clip == '' ||
                    //typeof contents[j].share_of_voice === 'undefined' || contents[j].share_of_voice == null || contents[j].share_of_voice == 'null' || //contents[j].share_of_voice == '' ||
                    typeof contents[j].total_airings === 'undefined' || contents[j].total_airings == null || contents[j].total_airings == 'null' || //contents[j].total_airings == '' ||
                    typeof contents[j].uniq_show_cnt === 'undefined' || contents[j].uniq_show_cnt == null || contents[j].uniq_show_cnt == 'null' || //contents[j].uniq_show_cnt == '' ||
                    typeof contents[j].uniq_network_cnt === 'undefined' || contents[j].uniq_network_cnt == null || contents[j].uniq_network_cnt == 'null' || //contents[j].uniq_network_cnt == '' ||
                    typeof contents[j].total_spend === 'undefined' || contents[j].total_spend == null || contents[j].total_spend == 'null')// || contents[j].total_spend == '')
                console.log(contents[j]);
                //*/if (contents[j].id == '2990001' || contents[j].id == 2990001) console.log(brandURL + " " + contents[j]);
            }
        } else {
            console.log(brandURL);
        }
        var nextIndex = i + 1;
        if (nextIndex < brands.length) getBrandCommercials(nextIndex);
    });
}


