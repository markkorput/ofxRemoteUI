class @Session extends Backbone.Model
  initialize: ->
    @sender = new oscSender
      socket: @get('socket')
      host: @get('remote').get('ip')
      port: @get('remote').get('port')

    @requestCompleteUpdate()    

  requestCompleteUpdate: ->
    @sender.send('REQU')

class @SessionsCollection extends Backbone.Collection
  model: Session