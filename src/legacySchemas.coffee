MESSAGE_SCHEMA =
  type: 'object'
  properties:
    lightNumber:
      type: 'number'
      required: true
    useGroup:
      type: 'boolean'
      required: true
      default: false
    on:
      type: 'boolean'
      required: true
    color:
      type: 'string'
      required: true
    transitiontime:
      type: 'number'
    alert:
      type: 'string'
    effect:
      type: 'string'

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    ipAddress:
      type: 'string'
      required: true
    apiUsername:
      type: 'string'
      required: true
      default: 'octoblu'

module.exports = {
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
}
