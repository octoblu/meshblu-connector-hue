_              = require 'lodash'
HueUtil        = require 'hue-util'
{EventEmitter} = require 'events'
tinycolor      = require 'tinycolor2'
debug          = require('debug')('meshblu-connector-hue:hue-manager')
_              = require 'lodash'

class HueManager extends EventEmitter
  createClient: ({@options, @apikey}, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @apikey ?= {}
    @options ?= {}
    {apiUsername, ipAddress} = @options
    {username} = @apikey
    apiUsername ?= 'newdeveloper'
    @apikey.devicetype = apiUsername
    @hue = new HueUtil apiUsername, ipAddress, username, @_onUsernameChange
    callback()

  _onUsernameChange: (username) =>
    return if username == @apikey.username
    @apikey.username = username
    @_emit 'change:username', {@apikey}

  getLights: (callback) =>
    @hue.getLights (err, lights) =>
      mappedLights = {}
      _.forEach lights, (light, lightNumber) =>
        { bri, sat, hue, alert, effect } = light.state

        bri = (bri / 254) * 100
        hue = (hue / 254) * 100
        sat = (sat / 254) * 100

        color = "hsl(" + hue + "%," + sat + "%," + bri + "%)"

        mappedLights[lightNumber] = {
          lightNumber: lightNumber,
          color: color,
          alert: alert,
          effect: effect,
          on: light.state.on
        }
      callback mappedLights

  getGroups: (callback) =>
    @hue.getGroups (err, groups) =>
      mappedGroups = {}
      _.forEach groups, (group, groupNumber) =>
        mappedGroups[groupNumber] = {
          lights: group.lights
        }
      callback mappedGroups

  changeLight: (data, callback) =>
    {
      lightNumber
      color
      transitionTime
      alert
      effect
    } = data

    @hue.changeLights { lightNumber, color, transitionTime, alert, effect, on: data.on }, callback

  changeGroup: (data, callback) =>
    {
      groupNumber
      color
      transitionTime
      alert
      effect
    } = data
    useGroup = true
    lightNumber = groupNumber

    @hue.changeLights { lightNumber, useGroup, color, transitionTime, alert, effect, on: data.on }, callback

module.exports = HueManager
