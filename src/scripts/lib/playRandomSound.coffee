itemChooser = require '../utils/itemChooser.coffee'
sounds = require '../data/sounds.json'
audioChooser = itemChooser(sounds)

module.exports = ->
  file = audioChooser()
  audio = new Audio("/audio/#{file}")

  audio.addEventListener 'ended', ->
    audio.remove()

  audio.play()

  return
