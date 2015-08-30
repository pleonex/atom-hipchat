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

    @addPastHistory()

  send: ->
    msg = @msgEditor.getModel().getText()
    @conversation.append "Me: #{msg}<br/>"
    @msgEditor.getModel().setText('')

  addPastHistory: ->
    Rest.get(ApiUrl + 'v2/user/' + @remoteUser.id + '/history', {
      query: {
        'max-results': 10
        },
      accessToken: atom.config.get('hipchat.token')
      }).on 'complete',
        (result) => @conversation.append(
          "#{@remoteUser.name}: #{msg.message}" for msg in result.items)
