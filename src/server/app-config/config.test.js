/* overwrite env specific variables here */

var config = require('./config.master');

config.env = 'test';
config.hosturl = 'http://dashqa.alphonso.tv';

/**************************
mysql database
**************************/
config.mysql.connectionLimit = 10;
config.mysql.host = 'insightsdb.alphonso.tv';
/**************************
mysql reports database
**************************/
config.mysql.reports.connectionLimit = 5;
config.mysql.reports.host = 'insightsdb.alphonso.tv';

/**************************
Email Configuration
**************************/
config.email.enabled = true;
//config.email.notify.ongetreports = 'amit@alphonso.tv, nikhil@alphonso.tv';
//config.email.notify.onsignin = 'amit@alphonso.tv, nikhil@alphonso.tv';
//config.email.notify.onreportvideo = 'amit@alphonso.tv, nikhil@alphonso.tv';
//config.email.notify.ongetfullaccess = 'amit@alphonso.tv, nikhil@alphonso.tv';

module.exports = config;