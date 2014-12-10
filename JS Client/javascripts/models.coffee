class @ParamModel extends Backbone.Model
  initialize: ->
    console.log 'param initializing'

class @ParamsCollection extends Backbone.Collection
  model: ParamModel


class @GroupModel extends Backbone.Model
  initialize: ->
    console.log "group initing"
    @params = new ParamsCollection()

class @GroupsCollection extends Backbone.Collection
  model: GroupModel


class @Session extends Backbone.Model
  initialize: ->
    # @connect();
    @groups = new GroupsCollection()
    @receivingGroup = @groups.add(name: "Groupless")

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
      # parse message
      msg = new jsRemoteUIMessage(incoming);

      switch msg.type()
        when "SENDSPA"
          # find existing group
          group = @groups.find(msg.sendSpaId())
          # if no existing group found, create new group
          group ||= @groups.add(id: msg.sendSpaId(), name: msg.sendSpaName())
          # make this th group that receives upcoming parma definitions
          @receivingGroup = group

        when "SENDPARAM"
          # in the current 'receiving group'; find existing param (by name), or create one
          param = @receivingGroup.params.findWhere(name: msg.paramName())
          param ||= @receivingGroup.params.add(name: msg.paramName())
          # read value
          param.set(value: msg.paramValue(), type: msg.paramType())
          # if min/max kinda param, read those values
          param.set(minValue: msg.paramMinValue(), maxValue: msg.paramMaxValue()) if msg.paramType() == 'INT'

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

