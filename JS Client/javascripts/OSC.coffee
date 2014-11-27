class @oscReceiver extends Backbone.Model
  initialize: ->
    @socket = @get('socket')
    @start()

  start: ->
    @socket.emit 'config',
      listen:
        id: this.cid
        port: @get('port')
        host: @get('host')


    # handler for incoming messages on the broadcasting port
    @socket.on 'message-'+this.cid, (obj) =>
      @trigger 'message', obj


class @oscSender extends Backbone.Model
  initialize: ->
    @socket = @get('socket')
    @start()

  start: ->
    @socket.emit 'config',
      sender:
        id: @cid
        port: @get('port')
        host: @get('host')

  send: (msg, pars) ->
    @socket.emit 'message-'+@cid, msg, pars

