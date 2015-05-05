var express = require('express');
var os = require('os');

var interfaces = os.networkInterfaces();
var addresses = [];
for (var k in interfaces) {
    for (var k2 in interfaces[k]) {
        var address = interfaces[k][k2];
        if (address.family === 'IPv4' && !address.internal) {
            addresses.push(address.address);
        }
    }
}

//console.log(addresses);

// Constants
var DEFAULT_PORT = 3001;
var PORT = process.env.PORT || DEFAULT_PORT;

// App
var app = express();
app.get('/', function (req, res) {
  res.send('Hello World Static <br/><br/>'+addresses);
});

app.listen(PORT)
console.log('Running on http://localhost:' + PORT);