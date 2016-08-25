{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
HueManager      = require './hue-manager'
_               = require 'lodash'
tinycolor      = require 'tinycolor2'

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
    @hue.getGroups (groups) =>
      _.forEach @groupStates, (data, key) =>
        @hue.changeGroup data unless _.isEqual data, @prevState.groupStates[key]
        @addLightStates data, data.lights
      @prevState.groupStates = @groupStates
      @emit 'update', { lightStates: @lightStates }

  changeLight: () =>
    _.forEach @lightStates, (data, key) =>
      data.color = tinycolor(data.color).toString("hsl")
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

  addLightStates: (data, lights) =>
    _.forEach lights, (lightNumber) =>
      { color, alert, effect } = data

      @lightStates[lightNumber] = {
        lightNumber: lightNumber
        color: color
        alert: alert
        effect: effect
        on: data.on
      }

  resetState: () =>
    @emit 'update', { lightStates: {}, groupStates: {}}

  close: (callback) =>
    debug 'on close'
    callback()

  handleStateChange: (device={}) =>
    { groupStates, lightStates } = device
    @changeGroup() if groupStates? && !_.isEqual groupStates, @prevState.groupStates
    @changeLight() if lightStates? && !_.isEqual lightStates, @prevState.lightStates


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

        @hue.getLights (lights) =>
          @lightStates = lights

    @handleStateChange device

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
