{View, TextEditorView} = require 'atom-space-pen-views'
Rest = require 'restler'

ApiUrl = 'https://api.hipchat.com/'

module.exports =
class UsersView extends View
  @content: ->
    @div =>
      @div outlet: 'conversation'
      @div class: 'bottom_controls', =>
        @subview 'msgEditor', new TextEditorView(mini: true)
        @button class: 'btn', outlet: 'sendBtn', click: 'send', 'Send!'

  getTitle: ->
    @remoteUser.name

  initialize: (@remoteUser) ->
    atom.commands.add @msgEditor.element, 'core:confirm': => @send()
    @msgEditor.focus()

    callback = => @checkAndAppendMessages()
    @interval = setInterval(callback, 5000)

  destroy: ->
    clearInterval(@interval)

  send: ->
    msg = @msgEditor.getModel().getText()

    Rest.postJson(ApiUrl + 'v2/user/' + @remoteUser.id + '/message', {
      'message': msg,
      'message_format': 'text'
      }, {
      accessToken: atom.config.get('hipchat-chat.token')
      }).on 'complete',
        (response) =>
          if response == ""
            @conversation.append "Me: #{msg}<br/>"
            @msgEditor.getModel().setText('')
          else
            console.log "Error:"
            console.log response

  checkAndAppendMessages: ->
    console.log if @lastQuery? then parseInt @lastQuery.getTime() / 1000 else
      'recent'

    Rest.get(ApiUrl + 'v2/user/' + @remoteUser.id + '/history', {
      query: {
        'max-results': 10,
        'date': 'recent'
        },
      accessToken: atom.config.get('hipchat-chat.token')
      }).on 'complete',
        (result) =>
          found = false
          for msg in result.items
            if found
              @conversation.append("#{@remoteUser.name}: #{msg.message}<br/>")

            if msg.id == @lastId
              found = true

          if not found
            @conversation.append(
              "#{@remoteUser.name}: #{m.message}<br/>" for m in result.items)

          if result.items.length > 0
            @lastId = result.items[result.items.length - 1].id
