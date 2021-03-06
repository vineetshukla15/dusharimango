/* config file with default values */
/* overwrite in specific env files */

var config = module.exports = {};

config.env = 'dev';
config.serverport = 8000;
config.hosturl = 'http://localhost:8000';
config.backendapiurl = 'http://alpha:@Lph0ns0@proxy.alphonso.tv/dashapi';

/**************************
mysql database
**************************/
config.mysql = {};
config.mysql.connectionLimit = 5;
config.mysql.host = 'localhost';
config.mysql.port = '3306';
config.mysql.user = 'alpha';//'warehouseuser';
config.mysql.password = '';
config.mysql.database = 'insights';//'dashboard';
/**************************
mysql reports database
**************************/
config.mysql.reports = {};
config.mysql.reports.connectionLimit = 5;
config.mysql.reports.host = 'localhost';
config.mysql.reports.port = '3306';
config.mysql.reports.user = 'warehouseuser';
config.mysql.reports.password = '';
config.mysql.reports.database = 'reports';

/**************************
LinkedIn OAuth
**************************/
config.linkedin = {};
//API keys received from developer.linkedin.com
config.linkedin.apikey = '756rgxekoarxum';
config.linkedin.apikeysecrect = 'dCXHt3luSulttC48';
//should be an authorized url @ developer.linkedin.com
config.linkedin.callbackurl = config.hosturl + '/commercial/';
config.linkedin.apiversion = 'v1';
config.linkedin.apiscope = 'r_basicprofile r_emailaddress';

/**************************
Email Configuration
**************************/
config.email = {};
config.email.enabled = false;
config.email.sender = 'Alphonso Inc. <insights@alphonso.tv>';
config.email.notify = {};
config.email.notify.ongetreports = 'amit@alphonso.tv, nikhil@alphonso.tv';
config.email.notify.onsignin = 'amit@alphonso.tv, nikhil@alphonso.tv';
config.email.notify.onreportvideo = 'amit@alphonso.tv, nikhil@alphonso.tv';
config.email.notify.ongetfullaccess = 'amit@alphonso.tv, nikhil@alphonso.tv';
config.email.notify.onftrequest = 'amit@alphonso.tv, nikhil@alphonso.tv';
