class @SessionsListView extends Backbone.View
  tagName: "main"

  initialize: ->
    @sessionViews = []

    @collection.on 'add', (session) =>
      # create new session view
      sessionView = new SessionView(model: session)

      # show it
      @$el.append(sessionView.el)

      # add to our views array
      @sessionViews.push(sessionView)

class @SessionView extends Backbone.View
  tagName: "section"

  initialize: ->
    remote = @model.get('remote');
    @$el.append('<h1>'+remote.get('binaryName')+'@'+remote.get('computerName')+' ('+remote.get('ip')+')</h1>');