class @SessionsListView extends Backbone.View
  tagName: "div"
  className: "sessions"

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
  tagName: "div"
  className: "session"

  initialize: ->
    remote = @model.get('remote');
    @$el.append('<h1>'+remote.get('binaryName')+'@'+remote.get('computerName')+' ('+remote.get('ip')+')</h1>');

    @groupsView = new GroupsListView(collection: @model.groups)
    @$el.append(@groupsView.el)
