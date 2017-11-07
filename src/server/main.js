/*
    Ref: http://rowanmanning.com/posts/node-cluster-and-express/
        https://nodejs.org/api/cluster.html
        http://expressjs.com/en/4x/api.html
*/
var cluster = require('cluster');

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

} else {

var express = require('express');
var app = express();

/*
 * Ref: http://expressjs.com/en/starter/static-files.html
 */
var options = {
  index: "index.html"
};
app.use(express.static('static', options));

var server = app.listen(8000, function () {
    var host = server.address().address
    var port = server.address().port
    console.log('Worker %d created listening at http://%s:%s.', cluster.worker.id, host, port);
})

} // if (cluster.isMaster) else