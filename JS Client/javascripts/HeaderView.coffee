class @HeaderView extends Backbone.View
  tagName: "nav"

  events:
    "change #remotes": "onRemoteChanged"

  initialize: ->
    # @$el.append '<label for="remotes">Servers</label>'
    @$el.append '<select id="remotes"><option value="oi">-- no applications detected yet --</option></select>'

    @model.remotes.on "add", (remote) =>
      @$el.find('select#remotes').append '<option value="'+remote.cid+'">'+remote.get('binaryName')+' @ '+ remote.get('computerName')+'</option>'
      @$el.find('select#remotes option:first').text('-- '+@model.remotes.length+' application(s) detected --')

  onRemoteChanged: (event) ->
    if remote = @model.remotes.get(@$el.find('select#remotes').val())
      @trigger "remoteChanged", remote


