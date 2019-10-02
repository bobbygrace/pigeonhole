# Utils
import itemChooser from '../utils/itemChooser.coffee'
import getMultipleItems from '../utils/getMultipleItems.coffee'
import el from '../utils/getElem.coffee'
import fillElem from '../utils/fillElem.coffee'
import bodyClassList from '../utils/bodyClassList.coffee'

# Analytics
import track from '../analytics/track.coffee'

# Our app stuff…
import t from '../lib/templates.coffee'
import playRandomSound from '../lib/playRandomSound.coffee'

# Data
import letters from '../data/letters.coffee'
import packs from '../data/packs.coffee'
packList = Object.keys(packs)

# Variables
window.currentPack = null


# The app

setPack = (pack) ->
  # don't destroy the cat chooser if we don't have to. it's holding state.
  return if pack == window.currentPack && pack?
  window.currentPack = pack ? 'original'
  window.catChooser = itemChooser(packs[window.currentPack].categories)

setPack('original')

letterChooser = itemChooser(letters)


# Game Stuff

renderTimeLeft = (secondsLeft) ->
  minutes = Math.floor(secondsLeft / 60)
  seconds = secondsLeft - (minutes * 60)
  secondsString = seconds.toString().padStart(2, "0")
  timeString = minutes.toString() + ":" + secondsString
  fillElem 'js-time-left', timeString


endTimerEvent = ->
  clearInterval(window.gameTimerId)
  bodyClassList.add('is-end-of-timer')

  fillElem 'js-time-left', "Game over!"

  playRandomSound()

  setTimeout ->
    bodyClassList.remove('is-end-of-timer')
  , 7000

  fillElem 'js-fill-button-bar', t.gameOverButtons()

  el('js-new-game').addEventListener 'click', (e) ->
    e.preventDefault()
    makeNewGame()
    bodyClassList.remove('is-end-of-timer')
    track 'Game', 'Make New Game', 'From Game'
    false

  return


startGame = ->
  el('js-game-container').classList.remove('is-blurred')
  fillElem 'js-overlay', ''

  gamelengthSeconds = 150
  gamelengthMs = gamelengthSeconds * 1000
  startDate = Date.now()
  endDate = parseInt(Date.now()) + gamelengthMs

  renderTimeLeft(gamelengthSeconds)

  # Adapted from…
  # https://codeburst.io/a-countdown-timer-in-pure-javascript-f3cdaae1a1a3
  window.gameTimerId = setInterval ->
    calculateTime()
  , 150

  calculateTime = ->
    startDate = new Date().getTime()

    secondsRemaining = parseInt((endDate - startDate) / 1000)
    renderTimeLeft(secondsRemaining)

    if secondsRemaining == 0
      endTimerEvent()

  return


makeNewGame = ->
  clearInterval(window.gameTimerId)
  bodyClassList.remove('is-end-of-timer')

  data =
    letter: letterChooser()
    catList: getMultipleItems(window.catChooser, 10)

  fillElem 'js-game', t.game data
  fillElem 'js-intro', ''
  fillElem 'js-overlay', t.startGameOverlay()

  el('js-start-game').addEventListener 'click', (e) ->
    e.preventDefault()
    startGame()
    track 'Game', 'Start New Game'
    false

  el('js-show-intro').addEventListener 'click', (e) ->
    e.preventDefault()
    renderIntro()
    track 'Intro', 'Back to Intro from Game'
    false

  return


# App Intro

renderIntro = ->
  clearInterval(window.gameTimerId)
  bodyClassList.remove('is-end-of-timer')

  fillElem 'js-intro', t.intro()
  fillElem 'js-game', ''
  fillElem 'js-overlay', ''

  packButtons = []
  for pack in packList
    data =
      name: pack
      displayName: packs[pack].name
    packButtons.push t.packButton(data)

  fillElem 'js-pack-list', packButtons.join('')

  for pack in packList
    target = document.querySelectorAll("[data-name=#{pack}]")[0]
    target.addEventListener 'click', (e) ->
      name = e.currentTarget.getAttribute('data-name')
      setPack name
      makeNewGame()
      track 'Game', 'Make New Game', "#{name}, From Intro Pack Section"
      false

  return


# Base

renderBaseLayout = ->
  fillElem 'js-app', t.baseLayout()
  renderIntro()
  return

renderBaseLayout()
