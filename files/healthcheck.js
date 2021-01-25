var https = require("https");

var options = {  
    host : "localhost",
    port : "631",
    timeout : 5,
    rejectUnauthorized: false,
    requestCert: true,
};

var request = https.request(options, (res) => {  
    console.log(`STATUS: ${res.statusCode}`);
    if (res.statusCode == 200) {
        process.exit(0);
    }
    else {
        process.exit(1);
    }
});

request.on('error', function(err) {  
    console.log('ERROR'+err);
    process.exit(1);
});

request.end();  