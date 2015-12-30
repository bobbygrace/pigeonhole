module.exports = (className) ->
  # Takes only 'js-' prefixed class name
  document.getElementsByClassName(className)[0]
