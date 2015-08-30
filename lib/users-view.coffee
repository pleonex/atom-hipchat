{SelectListView, $$} = require 'atom-space-pen-views'

module.exports =
class UsersView extends SelectListView
  initialize: () ->
    super
    @setMaxItems(10)

  getFilterKey: ->
    'mention_name'

  viewForItem: (item) ->
    $$ ->
      @li class: 'two-lines', =>
        if item.presence?.show == 'away'
          status = 'modified'
        else if item.presence?.show == 'chat'
          status = 'added'
        else if item.presence?.show == 'dnd'
          status = 'removed'
        else if item.presence?.show == 'xa'
          status = 'modified'
        else
          status = 'ignored'

        if item.presence?.status?
          @div class: "status status-#{status} icon icon-diff-#{status}", =>
            @text "  (" + item.presence.status + ")"
        else
          @div class: "status status-#{status} icon icon-diff-#{status}"

        @div class: "primary-line name icon icon-person", => @text item.name
        @div class: "secondary-line alias no-icon", =>
          @text "@" + item.mention_name

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
