{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
schemas         = require './legacySchemas.coffee'
_              = require 'lodash'
tinycolor      = require 'tinycolor2'
HueUtil        = require 'hue-util'
url            = require 'url'

class Hue extends EventEmitter
  constructor: ->
    debug 'Hue constructed'
    @options = {}

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  onMessage: (message) =>
    return unless message?
    { topic, devices, fromUuid } = message
    return if '*' in devices
    return if fromUuid == @uuid
    debug 'onMessage', { topic }
    return debug 'broadcast - no actions' if '*' in message.devices
    payload = message.payload
    @updateHue payload

  onConfig: (config) =>
    return unless config?
    debug 'on config', apikey: config.apikey
    @apikey = config.apikey || {}
    @setOptions config.options

  setOptions: (options={}) =>
    debug 'setOptions', options
    @options = _.extend apiUsername: 'octoblu', options

    if @options.apiUsername != @apikey?.devicetype
      @apikey =
        devicetype: @options.apiUsername
        username: null

    @hue = new HueUtil @options.apiUsername, @options.ipAddress, @apikey?.username, @onUsernameChange

  onUsernameChange: (username) =>
    debug 'onUsernameChange', username
    @apikey.username = username
    @emit 'update', apikey: @apikey

  updateHue: (payload={}) =>
    debug 'updating hue', payload
    @hue.changeLights payload, (error, response) =>
      return console.log error if error?
      @emit 'message', devices: ['*'], payload: response: response

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @emit 'update', schemas

module.exports = Hue
