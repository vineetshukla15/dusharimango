// For LinkedIn OAuth validation calls
var https = require('https');
var base64url = require('base64-url');
var config = require('../app-config');

// API keys received from developer.linkedin.com
var APIKey = config.linkedin.apikey;
var APIKeySecret = config.linkedin.apikeysecrect;
var callbackURL = config.linkedin.callbackurl;
var APIVersion = config.linkedin.apiversion;
var APIScope = config.linkedin.apiscope;

// Custom cookies to save LinkedIn profile information
const LinkedInAccessTokenCookie = 'LIAccessToken';
const LinkedInFirstNameCookie = 'LIFirstName';
const LinkedInLastNameCookie = 'LILastName';
const LinkedInEmailAddressCookie = 'LIEmailAddress';

module.exports.isSignedIn = function (req, resCookies) {
    
    var cookies = require('../util/cookie')(req);
    
    if (cookies[LinkedInAccessTokenCookie] || (typeof resCookies !== 'undefined' && resCookies[LinkedInAccessTokenCookie]))
        return true;
    else
        return false;
}

module.exports.signinInfo = function (req) {
    
    var cookies = require('../util/cookie')(req);
    
    if (cookies[LinkedInAccessTokenCookie])
        return decodeURIComponent(cookies[LinkedInFirstNameCookie] + ' ' +  
                                  cookies[LinkedInLastNameCookie] + ' (' +
                                  cookies[LinkedInEmailAddressCookie] + ')');
    else
        return 'N.A.';
}

module.exports.getUserId = function (req) {
    
    var cookies = require('../util/cookie')(req);
    
    if (cookies[LinkedInAccessTokenCookie])
        return decodeURIComponent(cookies[LinkedInEmailAddressCookie]);
    else
        return;
}

module.exports.getUserFullName = function (req, resCookies) {
    
    var cookies = require('../util/cookie')(req);
    var fullname = '';
    
    if (cookies[LinkedInAccessTokenCookie]) {
        fullname = decodeURIComponent(cookies[LinkedInFirstNameCookie] + ' ' + cookies[LinkedInLastNameCookie]).trim();
        if (fullname.length == 0) fullname = decodeURIComponent(cookies[LinkedInEmailAddressCookie]);
    } else if (typeof resCookies!== 'undefined' && resCookies[LinkedInAccessTokenCookie]) {
        fullname = decodeURIComponent(resCookies[LinkedInFirstNameCookie] + ' ' + resCookies[LinkedInLastNameCookie]).trim();
        if (fullname.length == 0) fullname = decodeURIComponent(resCookies[LinkedInEmailAddressCookie]);
    }
    
    if (fullname.length == 0) fullname = 'Sign Out';
    
    return fullname;
}

module.exports.OAuthValidation = function (req, res, state, cb, returnURL) {
    
    // Check to see if authorization for end user has already been made
    var cookies = require('../util/cookie')(req);
    console.log(cookies);
    // If we have the access_token in the cookie jump to Step 3
    if (cookies[LinkedInAccessTokenCookie]) {
        // STEP 3 - Get LinkedIn API Data
        console.log('Serving [' + returnURL + state + '] to: ' + 
                    decodeURIComponent(cookies[LinkedInFirstNameCookie] + ' ' +  
                                       cookies[LinkedInLastNameCookie] + ' <' + 
                                       cookies[LinkedInEmailAddressCookie] + '>'));
        cb(req, res, state);
        //OauthStep3(cookies[LinkedInAccessTokenCookie], APICalls['myProfile'], req, res, state, cb);
    } else {
        var queryObject = req.query;
        
        if (!queryObject.code) {
            // STEP 1 - If this is the first run redirect to LinkedIn for Auth
            var encodedstate = base64url.encode(JSON.stringify({id: state}));
            OauthStep1(req, res, encodedstate, returnURL);
        } else {
            // STEP 2 - Post LinkedIn consent, at the callback to do the final token request
            var decodedState = JSON.parse(base64url.decode(req.query.state));
            console.log('[' + decodedState + ']' + JSON.stringify(decodedState));
            OauthStep2(req, res, decodedState.id, returnURL, cb);
        }
    }
}

// Oauth Step 1 - Redirect end-user for authorization
var OauthStep1 = function (request, response, state, returnURL) {
	
	console.log("OauthStep1");
	
	response.writeHead(302, {
		'Location': 'https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=' + APIKey + '&scope=' + APIScope + '&state=' + state + '&redirect_uri=' + returnURL
	});
	response.end();
};

//////////////////////////////////////////////////////////////
// Oauth Step 2 - The callback post authorization
var OauthStep2 = function (request, response, state, returnURL, callback) {
	
	console.log("OauthStep2");
    console.log(state);
	var code = request.query.code;
	var options = {
		host: 'api.linkedin.com',
		port: 443,
		path: "/uas/oauth2/accessToken?grant_type=authorization_code&code=" + code + "&redirect_uri=" + returnURL + "&client_id=" + APIKey + "&client_secret=" + APIKeySecret
	};
	
	var req = https.request(options, function (res) {
		//console.log("statusCode: ", res.statusCode);
		//console.log("headers: ", res.headers);
		
		res.on('data', function (d) {
			// STEP 3 - Get LinkedIn API Data
			// We have successfully completed Oauth and have received our access_token.
			// Now let's make a real API call (Example API call referencing APICalls['myProfile'] below)
			
			var access_token = JSON.parse(d).access_token;
            var expires_in = JSON.parse(d).expires_in;
            console.log("access_token[" + access_token + "] : expires_in [" + expires_in + "]");
			
			var date = new Date();
			date.setDate(date.getDate() + 59); // TODO: fix this hardcoding, done as the default LI expiry is 60 days
            response.cookie(LinkedInAccessTokenCookie, access_token, { expires: date});
			
			OauthStep3(access_token, APICalls['myProfile'], request, response, state, returnURL, callback, true);
		});
	});
	
	req.on('error', function (e) {
		console.error("There was an error with our Oauth Call in Step 2: " + e);
        callback(request, response, state);
	});
    
    req.end();
};

//////////////////////////////////////////////////////////////
// Oauth Step 3 - Now you can make a real API call
// Get some real LinkedIn data below
var OauthStep3 = function (access_token, APICall, request, response, state, returnURL, callback, sendmail) {
	
	console.log("OauthStep3");
    //console.log("LI Access Token: [" + access_token + "]");
	
	if (APICall.indexOf("?") >= 0) {
		var JSONformat = "&format=json";
	} else {
		var JSONformat = "?format=json";
	}
	
	var options = {
		host: 'api.linkedin.com',
		port: 443,
		path: '/' + APIVersion + '/' + APICall + JSONformat + "&oauth2_access_token=" + access_token
	};
	
	var req = https.request(options, function (res) {
		//console.log("statusCode: ", res.statusCode);
		//console.log("headers: ", res.headers);
		
		res.on('data', function (d) {
			// We have LinkedIn data!  Process it and continue with your application here
			apiResponse = JSON.parse(d)
			console.log('LinkedIn profile: ' + apiResponse.firstName + ' ' +  apiResponse.lastName + ' <' + apiResponse.emailAddress + '>, ' + apiResponse.pictureUrl);			
			var cookieExpiryDate = new Date();
			cookieExpiryDate.setDate(cookieExpiryDate.getDate() + 365); // One year validity
            if (typeof apiResponse.firstName !== 'undefined' && apiResponse.firstName != '')
                response.cookie(LinkedInFirstNameCookie, apiResponse.firstName, { expires: cookieExpiryDate});
            if (typeof apiResponse.lastName !== 'undefined' && apiResponse.lastName != '')
                response.cookie('LILastName', apiResponse.lastName, { expires: cookieExpiryDate});
            if (typeof apiResponse.emailAddress !== 'undefined' && apiResponse.emailAddress != '')
                response.cookie('LIEmailAddress', apiResponse.emailAddress, { expires: cookieExpiryDate});
            
            console.log("Redirect to: " + returnURL + state);
            //response.redirect('back');
            //response.redirect(request.get('referer'));
            //response.redirect(returnURL + state);
            if (typeof state == 'undefined' || state == null)
                response.redirect('/');
            else
                response.send("Sign-in successful. Loading Insights .... <script> window.location.href = '" + returnURL + state.replace(/'/g, "\\'") + "' </script>")
/*
            //console.log(response._headers); console.log(response._headers['set-cookie']);
            var rescookies = {};
            response._headers['set-cookie'] && response._headers['set-cookie'].forEach(function (cookie) {
                var parts = cookie.split(';');
                parts = parts[ 0 ].split('=');
                rescookies[ parts[ 0 ].trim() ] = (parts[ 1 ] || '').trim();
            });
            //console.log(rescookies);

            callback(request, response, state, null, rescookies);
*/            
            if (sendmail){
                var emailClient = require('../util/email')(config.email);
                
                var mailDetails = {};
                mailDetails.reqIP = getIPString(request);
                mailDetails.signininfo = {};
                mailDetails.signininfo.firstname = apiResponse.firstName;
                mailDetails.signininfo.lastname = apiResponse.lastName;
                mailDetails.signininfo.email = apiResponse.emailAddress;
                mailDetails.signininfo.picture = apiResponse.pictureUrl;
                mailDetails.content = {};
                mailDetails.content.dashboardurl = returnURL + state;

                emailClient.signInAlert(mailDetails);
            }
            
		});
	});
	
	req.on('error', function (e) {
		console.error("There was an error with our LinkedIn API Call in Step 3: " + e);
        callback(request, response, state);
	});
    
	req.end();
};

// Some Example LinkedIn API Calls - Change in Step 3 accordingly
// More information can be found here: http://developer.linkedin.com/rest
var APICalls = [];

// My Profile and My Data APIS
APICalls['myProfile'] = 'people/~:(first-name,last-name,headline,email-address,picture-url)';
APICalls['myConnections'] = 'people/~/connections';
APICalls['myNetworkShares'] = 'people/~/shares';
APICalls['myNetworksUpdates'] = 'people/~/network/updates';
APICalls['myNetworkUpdates'] = 'people/~/network/updates?scope=self';

// PEOPLE SEARCH APIS
// Be sure to change the keywords or facets accordingly
APICalls['peopleSearchWithKeywords'] = 'people-search:(people:(id,first-name,last-name,picture-url,headline),num-results,facets)?keywords=Hacker+in+Residence';
APICalls['peopleSearchWithFacets'] = 'people-search:(people,facets)?facet=location,us:84';

// GROUPS APIS
// Be sure to change the GroupId accordingly
APICalls['myGroups'] = 'people/~/group-memberships?membership-state=member';
APICalls['groupSuggestions'] = 'people/~/suggestions/groups';
APICalls['groupPosts'] = 'groups/12345/posts:(title,summary,creator)?order=recency';
APICalls['groupDetails'] = 'groups/12345:(id,name,short-description,description,posts)';

// COMPANY APIS
// Be sure to change the CompanyId or facets accordingly
APICalls['myFollowingCompanies'] = 'people/~/following/companies';
APICalls['myFollowCompanySuggestions'] = 'people/~/suggestions/to-follow/companies';
APICalls['companyDetails'] = 'companies/1337:(id,name,description,industry,logo-url)';
APICalls['companySearch'] = 'company-search:(companies,facets)?facet=location,us:84';

// JOBS APIS
// Be sure to change the JobId or facets accordingly
APICalls['myJobSuggestions'] = 'people/~/suggestions/job-suggestions';
APICalls['myJobBookmarks'] = 'people/~/job-bookmarks';
APICalls['jobDetails'] = 'jobs/1452577:(id,company:(name),position:(title))';
APICalls['jobSearch'] = 'job-search:(jobs,facets)?facet=location,us:84';

// TODO: duplicated from server.js. remove this.
function getIPString (req) {
    return req.headers['x-forwarded-for'] + ' / ' + 
           req.connection.remoteAddress + ' / ' + 
           req.socket.remoteAddress + ' / ' + 
           //req.connection.socket.remoteAddress + ' / ' + 
           req.ip;
}