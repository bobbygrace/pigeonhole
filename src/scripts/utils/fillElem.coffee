getElem = require './getElem.coffee'
templates = require '../lib/templates.coffee'

# className should be "js-" prefixed.
module.exports = (className, fill) ->
  getElem(className).innerHTML = fill
