class @SessionsListView extends Backbone.View
  tagName: "main"

  initialize: ->
    @sessionViews = []

    @collection.on 'add', (session) =>
      # close all existing sessions
      @collection.each (other_session) ->
        if other_session != session
          other_session.set(active: false)

      # create new session view
      sessionView = new SessionView(model: session)

      # show it
      @$el.append(sessionView.el)

      # add to our views array
      @sessionViews.push(sessionView)

class @SessionView extends Backbone.View
  tagName: "section"

  initialize: ->
    @$el.append('<h1>'+@model.get('remote').get('ip')+'</h1>');