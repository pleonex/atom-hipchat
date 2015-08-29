AtomHipchatView = require './atom-hipchat-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomHipchat =
  atomHipchatView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomHipchatView = new AtomHipchatView(state.atomHipchatViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomHipchatView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-hipchat:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomHipchatView.destroy()

  serialize: ->
    atomHipchatViewState: @atomHipchatView.serialize()

  toggle: ->
    console.log 'AtomHipchat was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
