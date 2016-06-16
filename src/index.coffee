{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
HueManager      = require './hue-manager'

class Connector extends EventEmitter
  constructor: ->
    @hue = new HueManager

  isOnline: (callback) =>
    callback null, running: true

  changeGroup: (data, callback) =>
    @hue.changeGroup data, callback

  changeLight: (data, callback) =>
    @hue.changeLight data, callback

  close: (callback) =>
    debug 'on close'
    callback()

  onConfig: (device={}, callback=->) =>
    { @options, apikey } = device
    debug 'on config', @options
    @hue.createClient {@options, apikey}, (error) =>
      return callback error if error?
      @hue.on 'change:username', (apikey) =>
        @emit 'update', data
      callback()

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
