class @jsRemoteUIClient
  constructor: (_opts) ->
    @options = _opts
    @setup()

  setup: ->
    @socket = io.connect('http://127.0.0.1', port: 8081, rememberTransport: false)
    broadcastReceiver = new jsRemoteUIBroadcastReceiver
      socket: @socket
      port: 25748 # 25748 is the default ofxRemoteUI broadcast port

  update: ->

  draw: ->
