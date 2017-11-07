/* overwrite env specific variables here */

var config = require('./config.master');

//config.env = 'dev';
//config.hosturl = 'http://localhost:8000';
//config.backendapiurl = 'http://alpha:@Lph0ns0@proxy.alphonso.tv:5081/dashapi';

/**************************
mysql database
**************************/
config.mysql.port = '7306';
/**************************
mysql reports database
**************************/
config.mysql.reports.port = '7306';

/**************************
Email Configuration
**************************/
config.email.notify.ongetreports = '';
config.email.notify.onsignin = '';
config.email.notify.onreportvideo = '';
config.email.notify.ongetfullaccess = '';

module.exports = config;