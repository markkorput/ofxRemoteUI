class @jsRemoteUIMessage
  constructor: (rawMessage) ->
    @source = rawMessage || {}

  params: ->
    (@source.data || [])[2]

  messageLine: ->
    return @params()[0]

  messageText: ->
    @messageLine() || ""

  type: ->
    # /^SEND SPA \w+ - \d+$
    return "SENDSPA" if /^SEND SPA (\w+)/.test(@messageText())
    return "SENDPARAM" if /^SEND (\w+) (\w+)/.test(@messageText())
    return "REQU" if /^REQU/.test(@messageText())

  sendSpaName: ->
    @params()[1] if @type() == "SENDSPA"

  sendSpaId: ->
    result = /^SEND SPA (\w+) - (\d+)/.exec(@messageText())
    if result
      return result[2]
    return null

  paramType: -> /^SEND (\w+) (\w+)/.exec(@messageText())[1]
  paramName: -> /^SEND (\w+) (\w+)/.exec(@messageText())[2]
  paramValue: -> @params()[1]
  paramMinValue: -> @params()[2]
  paramMaxValue: -> @params()[3]