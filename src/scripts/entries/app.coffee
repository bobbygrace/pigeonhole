# Utils
itemChooser = require '../utils/itemChooser.coffee'
getMultipleItems = require '../utils/getMultipleItems.coffee'
getElem = require '../utils/getElem.coffee'
fillElem = require '../utils/fillElem.coffee'
bodyClassList = require '../utils/bodyClassList.coffee'

# Analytics
track = require '../analytics/track.coffee'

# Our app stuff…
t = require '../lib/templates.coffee'
playRandomSound = require '../lib/playRandomSound.coffee'

# Data
letters = require '../data/letters.coffee'
cats = require '../data/categories.coffee'

# Variables
@counterId = null



# And now, the app…

catChooser = itemChooser(cats)
letterChooser = itemChooser(letters)

renderTimeLeft = (secondsLeft) ->
  fillElem 'js-time-left', secondsLeft.toString()

endTimerEvent = ->
  clearInterval(@counterId)
  bodyClassList.add('is-end-of-timer')

  fillElem 'js-timer-section', t.gameOver()
  fillElem 'js-header-button', t.newGreenGameButton()

  playRandomSound()

  setTimeout ->
    bodyClassList.remove('is-end-of-timer')
  , 7000

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    bodyClassList.remove('is-end-of-timer')
    track 'Game', 'Make New Game', 'From Game'
    false

  return

startCounter = (seconds) ->
  counter = seconds

  fillElem 'js-timer-section', t.timer()
  renderTimeLeft(counter)

  @counterId = setInterval ->
    counter--
    if counter <= 0
      endTimerEvent()
      track 'Game', 'End Game'
    else
      renderTimeLeft(counter)
  , 1000

startGame = ->
  fillElem 'js-header-button', ''
  getElem('js-game-container').classList.remove('is-blurred')
  startCounter(150)
  return

makeNewGame = ->
  clearInterval(@counterId)
  bodyClassList.remove('is-end-of-timer')

  data =
    letter: letterChooser()
    catList: getMultipleItems(catChooser, 10)

  fillElem 'js-game', t.game data
  fillElem 'js-intro', ''
  fillElem 'js-header-button', t.startButton()

  getElem('js-start-game').addEventListener 'click', (e) ->
    startGame()
    track 'Game', 'Start New Game'
    false

  getElem('js-show-intro').addEventListener 'click', (e) ->
    renderIntro()
    track 'Intro', 'Back to Intro from Game'
    false

  return

renderIntro = ->
  clearInterval(@counterId)
  bodyClassList.remove('is-end-of-timer')

  fillElem 'js-intro', t.intro()
  fillElem 'js-game', ''
  fillElem 'js-header-button', t.newWhiteGameButton()

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    track 'Game', 'Make New Game', 'From Intro'
    false

  return

renderBaseLayout = ->
  fillElem 'js-app', t.baseLayout()

  renderIntro()

  return

renderBaseLayout()
