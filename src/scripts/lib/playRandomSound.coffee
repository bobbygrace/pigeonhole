import itemChooser from '../utils/itemChooser.coffee'
import sounds from '../data/sounds.json'

audioChooser = itemChooser(sounds)

module.exports = ->
  file = audioChooser()
  audio = new Audio("/audio/#{file}")

  audio.addEventListener 'ended', ->
    audio.remove()

  audio.play()

  return
