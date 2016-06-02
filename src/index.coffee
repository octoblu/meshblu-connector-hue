{EventEmitter}  = require 'events'
_              = require 'lodash'
tinycolor      = require 'tinycolor2'
HueUtil        = require 'hue-util'
debug           = require('debug')('meshblu-connector-hue:index')

class Hue extends EventEmitter
  constructor: ->
    @options = {}

  isOnline: (callback) =>
    callback null, running: !!@hue

  onMessage: (message={}) =>
    { devices } = message
    return debug 'broadcast - no action' if '*' in devices
    @updateHue message.payload

  onConfig: (device={}) =>
    debug 'on config', apikey: device.apikey
    @apikey = device.apikey || {}
    @options = _.assign { apiUsername: 'octoblu' }, device.options
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
    return unless payload.lightNumber? && payload.useGroup?
    debug 'updating hue', payload
    @hue.changeLights payload, (error, response) =>
      return console.error error if error?
      @emit 'message', devices: ['*'], payload: { response }

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @onConfig device

module.exports = Hue
