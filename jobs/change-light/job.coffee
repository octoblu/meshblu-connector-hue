http = require 'http'

class ChangeLight
  constructor: ({@connector}) ->
    throw new Error 'ChangeLight requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.lightNumber is required') unless data?.lightNumber?
    return callback @_userError(422, 'data.on is required') unless data?.on?

    {
      lightNumber
      color
      transitionTime
      alert
      effect
    } = data

    @connector.changeLight { lightNumber, color, transitionTime, alert, effect, on: data.on }, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = ChangeLight
