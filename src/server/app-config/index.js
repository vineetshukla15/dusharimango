/* index file to load the internal config module */

var env = process.env.NODE_ENV || 'dev'
  , config = require('./config.'+env);

console.log("Server running in '" + config.env + "' mode. To change start with 'NODE_ENV=dev/test/prod node ./server.js' option.")


/* overwrite the derived properties here */
/**************************
LinkedIn OAuth
**************************/
//should be an authorized url @ developer.linkedin.com
config.linkedin.callbackurl = config.hosturl + '/commercial/';

module.exports = config;