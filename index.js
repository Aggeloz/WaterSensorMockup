const WebSocket = require('ws');
const dotenv = require('dotenv');
dotenv.config();

const port = process.env.serverPort;
const addr = process.env.serverAddr;
const ws = new WebSocket(`ws://${addr}:${port}`);

function between(min, max) {
    let rand = Math.random() * (max - min) + min;
    rand = parseFloat(rand.toFixed(3));
    return rand;
}

function measurement(){
    let msg = {
        "ph":between(0.0, 14.0),
        "dissolved_oxygen":between(0, 20),
        "turbidity":between(0, 1000),
        "temperature":between(0, 70),
        "electrical_conductivity":between(0, 2000),
        "dissolved_solids":between(0, 1000),
        "nitrate":between(0, 50),
        "phosphate":between(0, 1),

    };
    console.log(msg);
    msg = JSON.stringify(msg);
    return msg;
}



ws.on('open', () => {
    console.log('Connected to the server');
    // ws.send(measurement());
    setInterval(() => {
        ws.send(measurement());
    }, 2000);
});

ws.on('message', (data) => {
    console.log(`Received: ${data}`);
});

ws.on('error', (err) => {
    console.log(err);
});

ws.on('close', () => {
    console.log('Disconnected from the server');
});
