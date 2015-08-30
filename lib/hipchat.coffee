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

  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add(
      atom.commands.add 'atom-workspace', 'hipchat:toggle': => @toggle())
    @subscriptions.add(
      atom.commands.add 'atom-workspace', 'hipchat:printUsers':=> @printUsers())
    @subscriptions.add(
      atom.commands.add 'atom-workspace',
        'hipchat:showUsers': => @showUsers().toggle())

  getUsers: (callback) ->
    Rest.get(ApiUrl + 'v2/user', {
      query: {
        'start-index': 0,
        'max-results': 100,
        'expand': 'items'
        },
      accessToken: atom.config.get('hipchat.token')
      }).on 'complete', (result) -> callback(result)

  showUsers: ->
    unless @usersView?
      UsersView = require './users-view'
      @usersView = new UsersView()

      @usersView.setLoading('Getting users\u2026')
      @getUsers (result) =>
        @usersView.setItems(result.items)

    @usersView

  printUsers: ->
    console.log('getting users')
    @getUsers (result) -> console.log result

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->


  toggle: ->
    console.log 'HipChat was toggled!'
