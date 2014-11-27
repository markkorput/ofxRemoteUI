class @jsRemoteUIBroadcastReceiver extends Backbone.Model
  initialize: ->
    @socket = @get('socket')
    @remotes = new Backbone.Collection();

    broadcastListener = new oscReceiver
      socket: @socket
      port: @get('port')
      host: '127.0.0.1'

    broadcastListener.on 'message', (obj) =>
      # if message has the format of a ofxRemoteUIServer broadcast ping
      if obj.data && obj.info && obj.data[2] && obj.data[2]
        @parsePing
          ip: obj.info.address
          port: obj.data[2][1]
          computerName: obj.data[2][2]
          binaryName: obj.data[2][3]
          broadcastSequenceNumber: obj.data[2][4]

  update: ->

  draw: ->

  parsePing: (data) ->

    # find any known remote with the same ip/port
    if remote = @remotes.findWhere({ip: data.ip, port: data.port})

      # if received broadcastSequenceNumber is lower than the one we've got
      # so any reference we've got about it must be renewed
      if data.broadcastSequenceNumber < remote.get('broadcastSequenceNumber')
        console.log "Existing remote restarted: ", data
        # remove known instance
        @remotes.remove(remote)
        # add new instance
        data.lastSeen = new Date()
        @remotes.add(data)
        return

      # simply update existing remote's timestamp
      remote.set(lastSeen: new Date(), broadcastSequenceNumber: data.broadcastSequenceNumber)
      return

    # add new remote to our @remotes collection
    console.log "New remote: ", data
    data.lastSeen = new Date()
    @remotes.add(data)


