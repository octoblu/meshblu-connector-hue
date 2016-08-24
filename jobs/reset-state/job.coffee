http = require 'http'

class ResetState
  constructor: ({@connector}) ->
    throw new Error 'ResetState requires connector' unless @connector?

  do: ({data}, callback) =>
    @connector.resetState()

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = ResetState
