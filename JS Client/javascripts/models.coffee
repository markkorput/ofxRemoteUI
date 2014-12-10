class @Session extends Backbone.Model
  initialize: ->
    # @connect();

  connect: ->
    @sender = new oscSender
      socket: @get('socket')
      host: @get('remote').get('ip')
      port: @get('remote').get('port')

    @listener = new oscReceiver
      socket: @get('socket')
      port: @get('remote').get('port') + 1
      host: @get('remote').get('ip')

    @listener.on 'message', (incoming) =>
      console.log "session incoming: ", incoming

    @requestCompleteUpdate()    

  requestCompleteUpdate: ->
    console.log "sending REQU"
    @sender.send('REQU', '')
    # @sender.send('REQU', 'OK') # confirmation

class @SessionsCollection extends Backbone.Collection
  model: Session

  initialize: ->
    @on 'add', (session) =>
      # # close all existing sessions
      # @collection.each (other_session) ->
      #   if other_session != session
      #     other_session.set(active: false)
