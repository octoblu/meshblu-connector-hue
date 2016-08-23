{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
HueManager      = require './hue-manager'

class Connector extends EventEmitter
  constructor: ->
    @hue = new HueManager
    @connected = false

  isOnline: (callback) =>
    callback null, running: true

  changeGroup: (data, callback) =>
    @hue.changeGroup data, callback

  changeLight: (data, callback) =>
    @hue.changeLight data, callback

  updateGroup: (data, callback=->) =>
    @emit 'update', { groupState: data }
    callback()

  updateLight: (data, callback=->) =>
    @emit 'update', { lightState: data }
    callback()

  close: (callback) =>
    debug 'on close'
    callback()

  handleStateChange: (device={}) =>
    @changeGroup device.groupState if device?.groupState?
    @changeLight device.lightState if device?.lightState?

  onConfig: (device={}, callback=->) =>
    { @options, apikey } = device
    debug 'on config', @options

    if @connected == false
      @hue.createClient {@options, apikey}, (error) =>
        return callback error if error?
        @connected = true
        @hue.on 'change:username', ({apikey}) =>
          @emit 'update', {apikey}
        callback()

    @handleStateChange device

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
