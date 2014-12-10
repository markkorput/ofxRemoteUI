class @jsRemoteUIClient extends Backbone.Model

  initialize: ->

    # connect to our server-side OSC bridge
    @socket = io.connect('http://127.0.0.1', port: 8081, rememberTransport: false)

    # setup monitor for broadcast messages
    @broadcastReceiver = new jsRemoteUIBroadcastReceiver
      socket: @socket
      port: 25748 # 25748 is the default ofxRemoteUI broadcast port

    # supporting multiple simultanous connected remote apps;
    # this sessions collection will keep track of all active
    # sessions, their status (active/idle/disconnected) etc.
    @sessions = new SessionsCollection()

    # automatically start a new session with the first discovered remote
    # @broadcastReceiver.remotes.on "add", (remote) =>
    #   # first / only remote? auto-load it
    #   if @broadcastReceiver.remotes.length == 1
    #     @sessions.add(remote: remote, socket: @socket).connect()

    # create header view, which shows broadcaster activity
    # and gives the user an option to select remotes to start a session with
    @headerView = new HeaderView(model: @broadcastReceiver)
    @headerView.on 'remoteChanged', (remote) =>
      @sessions.add(remote: remote, socket: @socket).connect()

    # a view for for our sessions collection
    @sessionsListView = new SessionsListView(collection: @sessions)

    jQuery('body').append(@headerView.el)
    jQuery('body').append('<hr/>')
    jQuery('body').append(@sessionsListView.el)
