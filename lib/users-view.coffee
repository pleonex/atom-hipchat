{SelectListView, $$} = require 'atom-space-pen-views'

module.exports =
class UsersView extends SelectListView
  initialize: (@listOfItems) ->
    super
    @setItems(@listOfItems)

  viewForItem: (item) ->
    $$ -> @li(item)

  destroy: ->
    @cancel()
    @panel?.destroy()

  cancel: ->
    @hide()

  confirmed: (item) ->
    console.log("confirmed", item)

  show: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

  hide: ->
    @panel?.hide()

  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      @show()
