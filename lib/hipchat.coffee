HipchatView = require './hipchat-view'
{CompositeDisposable} = require 'atom'

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

    # Register command that toggles this view
    @subscriptions.add(
      atom.commands.add('atom-workspace', 'hipchat:toggle': => @toggle())
      )

    console.log('getting users')
    @rest = require('restler')
    @rest.get('https://api.hipchat.com/v2/user', {
      query: {
        'start-index': 0,
        'max-results': 10,
        'expand': 'items'
        },
      accessToken: atom.config.get('hipchat.token')
      }).on 'complete', (result) =>  @showUsers result

  showUsers: (data) ->
    console.log('received users:')
    console.log(u.name + ' - ' + u.presence?.show) for u in data.items

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
