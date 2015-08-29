HipchatView = require './hipchat-view'
{CompositeDisposable} = require 'atom'

module.exports = Hipchat =
  hipchatView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @hipchatView = new HipchatView(state.hipchatViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @hipchatView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'hipchat:toggle': => @toggle()

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
    else
      @modalPanel.show()
