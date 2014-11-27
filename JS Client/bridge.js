var osc = require('node-osc'),
    io = require('socket.io').listen(8081);

io.set('log level', 1);

var oscServer, oscClient;
var oscServers = [];
var oscClients = [];

io.sockets.on('connection', function (socket) {
  socket.on("config", function (obj) {
    console.log("Got config: "); console.log(obj);

    // change server config
    if(obj.server){
      oscServer = new osc.Server(obj.server.port, obj.server.host);

      oscServer.on('message', function(msg, rinfo) {
        // console.log(msg, rinfo);
        socket.emit("message", msg);
      });
    }

    // change client config
    if(obj.client){
      oscClient = new osc.Client(obj.client.host, obj.client.port);
      oscClient.send('/status', socket.sessionId + ' connected');
    }

    // add listener (server) config
    if(obj.listen){
      // create a new server
      server = new osc.Server(obj.listen.port, obj.listen.host);
      // add new server to our servers collection
      oscServers.push(server)
      // when receiving a message on this new server,
      // forward through our socket connection,
      // with message in the following format:
      // message-<id>
      // for example:
      // message-<c4>
      server.on('message', function(msg, rinfo) {
        // console.log('Received: ', msg, rinfo);
        socket.emit("message-" + obj.listen.id, {
          data: msg,
          info: rinfo
        });
      });  
    }  

    // add sender (client) config
    if(obj.sender){
      client = new osc.Client(obj.sender.host, obj.sender.port);
      oscClients.push(client);

      socket.on("message-"+obj.sender.id, function(msg, params){
        console.log('Sending: ', msg, params);
        if(!params)
          client.send(msg);
        else
          client.send(msg, params);
      });
    }
  });

  socket.on("message", function (obj) {
    oscClient.send(obj);
  });

});