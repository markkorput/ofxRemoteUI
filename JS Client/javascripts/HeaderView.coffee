class @HeaderView extends Backbone.View
  tagName: "nav"

  initialize: ->
    # @$el.append '<label for="remotes">Servers</label>'
    @$el.append '<select id="remotes"><option value="">-- no applications detected yet --</option></select>'

    @model.remotes.on "add", (remote) =>
      @$el.find('select#remotes').append '<option value="'+remote.cid+'">'+remote.get('ip')+'</option>'
      @$el.find('select#remotes option:first').text('-- '+@model.remotes.length+' application(s) detected --')

