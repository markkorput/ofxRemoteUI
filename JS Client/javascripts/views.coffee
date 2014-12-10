#
# Groups
#

class @GroupsListView extends Backbone.View
  tagName: "div"
  className: "groups"

  initialize: ->
    @groupViews = []

    @collection.on 'add', (group) =>
      # create new group view
      groupView = new GroupView(model: group)

      # show it
      @$el.append(groupView.el)

      # save it our views array
      @groupViews.push(groupView)

class @GroupView extends Backbone.View
  tagName: "div"
  className: "group"

  initialize: ->
    @$el.append('<h2>'+@model.get('name') + '</h2>');

    @paramsView = new ParamsListView(collection: @model.params)
    @$el.append(@paramsView.el)

#
# Params
#

class @ParamsListView extends Backbone.View
  tagName: "div"
  className: "params"

  initialize: ->
    @views = []

    @collection.on 'add', (param) =>
      # create new param view
      view = new ParamView(model: param)

      # show it
      @$el.append(view.el)

      # save it our views array
      @views.push(view)

class @ParamView extends Backbone.View
  tagName: "div"
  className: "param"

  initialize: ->
    @$el.append('<h3>'+@model.get('name') + ': ' + @model.get('value') + '</h3>');