class @jsRemoteUIClient extends Backbone.Model

  initialize: ->

    @socket = io.connect('http://127.0.0.1', port: 8081, rememberTransport: false)

    @broadcastReceiver = new jsRemoteUIBroadcastReceiver
      socket: @socket
      port: 25748 # 25748 is the default ofxRemoteUI broadcast port

    @sessions = new SessionsCollection()

    @broadcastReceiver.remotes.on "add", (remote) =>
      # first / only remote? auto-load it
      if @broadcastReceiver.remotes.length == 1
        @loadSession(remote)

    # create header view , setup handlers and show header view on page
    @headerView = new HeaderView(model: @broadcastReceiver)
    @headerView.on 'remoteChanged', @loadSession

    @sessionsListView = new SessionsListView(collection: @sessions)

    jQuery('body').append(@headerView.el)
    jQuery('body').append('<hr/>')
    jQuery('body').append(@sessionsListView.el)

  update: ->

  draw: ->

  loadSession: (remote) =>
    @sessions.add(remote: remote, socket: @socket)


