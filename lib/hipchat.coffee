HipchatView = require './hipchat-view'
Rest = require 'restler'
{CompositeDisposable} = require 'atom'

ApiUrl = 'https://api.hipchat.com/'

module.exports = Hipchat =
  # Config schema
  config:
    token:
      type: 'string'
      title: 'User token'
      default: ''

    user_email:
      type: 'string'
      title: 'User email'
      default: ''

  hipchatView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @hipchatView = new HipchatView(state.hipchatViewState)
    @modalPanel = atom.workspace.addModalPanel(
      item: @hipchatView.getElement(),
      visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add(
      atom.commands.add 'atom-workspace', 'hipchat:toggle': => @toggle())
    @subscriptions.add(
      atom.commands.add 'atom-workspace', 'hipchat:printUsers':=> @printUsers())

  printUsers: ->
    console.log('getting users')
    Rest.get(ApiUrl + 'v2/user', {
      query: {
        'start-index': 0,
        'max-results': 10,
        'expand': 'items'
        },
      accessToken: atom.config.get('hipchat.token')
      }).on 'complete',
        (result) ->
          console.log u.name + ' - ' + u.presence?.show for u in result.items

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @hipchatView.destroy()

  serialize: ->
    hipchatViewState: @hipchatView.serialize()

  toggle: ->
    console.log 'HipChat was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    #else
    #  @modalPanel.show()
