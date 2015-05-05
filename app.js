var express = require('express');
var os = require("os");

var DEFAULT_PORT = 3001;
var PORT = process.env.PORT || DEFAULT_PORT;

var app = express();
var hostname = os.hostname();

app.get('/', function (req, res) {
  res.send('<html><body>Hello from Node.js container ' + hostname + '</body></html>');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);