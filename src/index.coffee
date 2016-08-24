{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
HueManager      = require './hue-manager'
_               = require 'lodash'

class Connector extends EventEmitter
  constructor: ->
    @hue = new HueManager
    @connected = false

    @lightStates = {}
    @groupStates = {}

    @prevState = {
      lightStates: {}
      groupStates: {}
    }

  isOnline: (callback) =>
    callback null, running: true

  changeGroup: () =>
    _.forEach @groupStates, (data, key) =>
      @hue.changeGroup data unless _.isEqual data, @prevState.groupStates[key]
    @prevState.groupStates = @groupStates

  changeLight: () =>
    _.forEach @lightStates, (data, key) =>
      @hue.changeLight data unless _.isEqual data, @prevState.lightStates[key]
    @prevState.lightStates = @lightStates

  updateGroup: (data, callback=->) =>
    @groupStates[data.groupNumber] = data
    @emit 'update', { groupStates: @groupStates }
    callback()

  updateLight: (data, callback=->) =>
    @lightStates[data.lightNumber] = data
    @emit 'update', { lightStates: @lightStates }
    callback()

  resetState: () =>
    @emit 'update', { lightStates: {}, groupStates: {}}

  close: (callback) =>
    debug 'on close'
    callback()

  handleStateChange: (device={}) =>
    @changeGroup() if device?.groupStates?
    @changeLight() if device?.lightStates?

  onConfig: (device={}, callback=->) =>
    { @options, apikey, @groupStates, @lightStates } = device
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
