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
letterChooser = itemChooser(letters)

# Variables
window.currentPack = null


# General

setPack = (pack) ->
  # Cat chooser is holding state, so don't destroy it.
  return if pack == window.currentPack && pack?
  window.currentPack = pack ? 'original'
  window.catChooser = itemChooser(packs[window.currentPack].categories)

setPack 'original'


# Base

renderBaseLayout = ->
  fillElem 'js-app', t.baseLayout()
  renderIntro()
  return


# App Intro

renderIntro = ->
  clearInterval(window.gameTimerId)
  bodyClassList.remove('is-end-of-timer')

  fillElem 'js-intro', t.intro()
  fillElem 'js-game', ''
  fillElem 'js-overlay', ''

  el('js-open-new-game-overlay').addEventListener 'click', (e) ->
    track 'Intro', 'Open New Game Overlay'
    openNewGameOverlay()

  return


# New Game Overlay

openNewGameOverlay = ->

  fillElem 'js-overlay', t.newGameOverlay()
  fillElem 'js-game', ''
  fillElem 'js-intro', ''

  renderPacks = ->
    packButtons = []

    for pack in packList
      data =
        name: pack
        labelText: packs[pack].name
        isChecked: pack == window.currentPack
      packButtons.push t.radioButton(data)

    fillElem 'js-fill-packs', packButtons.join('')

    for pack in packList
      target = document.querySelectorAll("[data-name=#{pack}]")[0]
      target.addEventListener 'click', (e) ->
        name = e.currentTarget.getAttribute('data-name')
        track 'New Game Overlay', "Set Pack #{name}"
        setPack name
        renderPacks()
        false

  renderPacks()

  renderGame()

  el('js-start-game').addEventListener 'click', (e) ->
    e.preventDefault()
    renderGame() # in case the data changed.
    startGame()
    track 'New Game Overlay', "Start Game, Pack: #{window.currentPack}"
    false


# Game Stuff

renderGame = ->
  clearInterval(window.gameTimerId)
  bodyClassList.remove('is-end-of-timer')

  data =
    letter: letterChooser()
    catList: getMultipleItems(window.catChooser, 10)

  fillElem 'js-game', t.game data

  el('js-show-intro').addEventListener 'click', (e) ->
    e.preventDefault()
    renderIntro()
    track 'Game Bar', 'Back to Intro'
    false

  return


renderTimeLeft = (secondsLeft) ->
  minutes = Math.floor(secondsLeft / 60)
  seconds = secondsLeft - (minutes * 60)
  secondsString = seconds.toString().padStart(2, "0")
  timeString = minutes.toString() + ":" + secondsString
  fillElem 'js-time-left', timeString


endGame = ->
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
    openNewGameOverlay()
    bodyClassList.remove('is-end-of-timer')
    track 'Game', 'Open New Game Overlay'
    false

  return


startGame = ->
  el('js-game-container').classList.remove('is-blurred')
  fillElem 'js-overlay', ''
  fillElem 'js-intro', ''

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
      endGame()

  return


# Render and start the app

renderBaseLayout()
