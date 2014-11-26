var osc = require('node-osc'),
    io = require('socket.io').listen(8081);

var oscServer, oscClient;
var oscServers = [];

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
      // message-<host>:<port>
      // for example:
      // message-127.0.0.1:123
      server.on('message', function(msg, rinfo) {
        // console.log(msg, rinfo);
        socket.emit("message-" + obj.listen.host + ":" + obj.listen.port, {
          data: msg,
          info: rinfo
        });
      });  
    }  
  });

  socket.on("message", function (obj) {
    oscClient.send(obj);
  });

});