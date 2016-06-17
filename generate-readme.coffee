_          = require 'lodash'
parse      = require 'json-schema-to-markdown'
allSchemas = require './schemas.json'

class Generate
  run: =>
    configures = @parseSchemas allSchemas.schemas.configure
    messages = @parseSchemas allSchemas.schemas.message
    resultMarkdown = @compileSchemas { configures, messages }
    console.log(resultMarkdown)

  parseSchemas: (schemas) =>
    return _.mapValues schemas, (schema) =>
      return parse(schema)

  compile: (title, orgMarkdown, schemas) =>
    resultMarkdown = orgMarkdown
    resultMarkdown += "\n\n"
    resultMarkdown += "# #{title} Schemas"
    _.each schemas, (schema) =>
      resultMarkdown += "\n\n"
      resultMarkdown += schema
      return
    resultMarkdown

  compileSchemas: ({ configures, messages }) =>
    resultMarkdown = ""
    resultMarkdown = @compile "Configure", resultMarkdown, configures
    resultMarkdown = @compile "Message", resultMarkdown, messages
    return resultMarkdown

  write: (resultMarkdown) =>
    fs.writeFileSync(path.join(__dirname, "TEST.md"), resultMarkdown)

new Generate().run()
