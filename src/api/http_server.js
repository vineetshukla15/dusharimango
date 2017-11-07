#!/usr/bin/env node

//Lets require/import the HTTP module
var http = require('http');

//Lets define a port we want to listen to
const PORT = 8000;

//We need a function which handles requests and send response
function handleRequest(request, response) {
  console.log('Request method:' + request.method);

  var body = '';
  request.on('data', function(chunk) {
    body += chunk;
  });

  var req_url = request.url;
  var arr = req_url.toString().split("/");


  request.on('end', function() {
    try {
      var data = JSON.parse(body);
      var message = JSON.stringify(data);
      console.log(' data:' + message);


    } catch (er) {
      // uh oh!  bad json!
      console.log('error: ' + er.message);
      //response.statusCode = 400;
      //return response.end('error: ' + er.message);
    }

  });



  response.end('ok' + request.url + '\n');
}

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function() {
  //Callback triggered when server is successfully listening. Hurray!
  console.log("Server listening on: http://localhost:%s", PORT);
});
