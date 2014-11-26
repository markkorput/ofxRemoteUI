class @jsRemoteUIClient extends Backbone.Model

  initialize: ->

    @socket = io.connect('http://127.0.0.1', port: 8081, rememberTransport: false)

    @broadcastReceiver = new jsRemoteUIBroadcastReceiver
      socket: @socket
      port: 25748 # 25748 is the default ofxRemoteUI broadcast port

    @headerView = new HeaderView(model: @broadcastReceiver)
    jQuery('body').append(@headerView.el)
    jQuery('body').append('<hr/>')


  update: ->

  draw: ->
