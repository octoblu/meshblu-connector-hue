http = require 'http'

class ChangeGroup
  constructor: ({@connector}) ->
    throw new Error 'ChangeGroup requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.groupNumber is required') unless data?.groupNumber?
    return callback @_userError(422, 'data.on is required') unless data?.on?

    {
      groupNumber
      color
      transitionTime
      alert
      effect
    } = data

    @connector.changeGroup { groupNumber, color, transitionTime, alert, effect, on: data.on }, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = ChangeGroup
