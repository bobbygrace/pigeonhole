letters = require '../data/letters.coffee'
cats = require '../data/categories.coffee'
sounds = require '../data/sounds.json'
{ renderable, div, p, img, span, text, strong, a, button, blockquote, ol, li, h1, h2 } = require 'teacup'

@counterId = null


# Utilities

# http://stackoverflow.com/a/17891411
randomNoRepeats = (array) ->
  copy = array.slice(0)
  ->
    if copy.length < 1
      copy = array.slice(0)
    index = Math.floor(Math.random() * copy.length)
    item = copy[index]
    copy.splice index, 1
    item

getMultipleItems = (fn, num) ->
  arr = []
  i = 0
  while i < num
    arr.push fn()
    i++
  return arr


getElem = (className) ->
  # Takes only 'js-' prefixed class name
  document.getElementsByClassName(className)[0]

# Google Analytics event tracking
track = (category, action, label, value) ->
  window.ga? 'send', 'event', category, action, label, value


# Templates

introTemplate = renderable ->
  howToText = ->
    ol ->
      li ->
        p "Get a bunch of people together around the screen. Have everyone
          write 1 through 10 on sheets of paper. Ready? Hit “New Game” then
          start."
        blockquote "You can’t have too many people. It’s more fun with more
          people."
      li ->
        p "You’ll get one letter, ten categories, and two and a half minutes.
          Write an answer that fits into each of the categories that starts
          with the letter. Make it original. You can’t use the same answer for
          multiple categories."
        blockquote "Need an example? You have the letter “B” and category
          “Foods You Can Eat with a Fork or with Your Hands”. That’s easy!
          “Burrito.”"
        blockquote "An answer can be a word or a short phrase."
      li ->
        p "That funny noise means it’s the end of the round. Time to compare
          answers. Everyone say what they had for the first category. If nobody
          else had the same answer, you get a point. Compare the next category
          and so on."
        blockquote "You can put an answer to a vote. If half or more of
          the players say, “No way. That doesn’t count.” then sorry, the group
          has spoken. It doesn’t count."
      li ->
        p "Play another round by clicking “New Game”. If the group is feeling
          competitive, keep track of the points and compare at the end. As long
          as you laugh and have a good time, everyone wins."
        blockquote "If you want, you can give multiple points for each word in
          an answer that starts with the letter. For example, you would get
          three points for “Black Bean Burrito”."
        blockquote "For an extra challenge, don’t use adjectives for the first
          word in the phrase."
        blockquote "You may play all night so it’s best to have blankets and
          pillows laying around in case people fall asleep."

  div '.logo', ->
    img '.logo-mark-image', src: '/images/logo-white.svg'

  div '.intro', ->
    div '.intro-content', ->
      div '.intro-content-section', ->
        p '.intro-content-section-header', "This is"
        p '.intro-content-section-details', ->
          strong "Pigeonhole"
      div '.intro-content-section', ->
        p '.intro-content-section-header', "How to Play"
        div '.intro-content-section-details', howToText()
      div '.intro-content-section', ->
        p '.intro-content-section-header', "Made By"
        p '.intro-content-section-details', ->
          a href: "http://bobbygrace.info", "Bobby Grace"
          text " and "
          a href: "http://madeleineburkart.com", "Madeleine Burkart"


gameTemplate = renderable ({letter, catList}) ->
  div '.logo', ->
    a '.logo-mark.js-show-intro', href: '#', title: 'Show introduction', ->
      img '.logo-mark-image.mod-clickable', src: '/images/logo-green.svg'

  div '.game.is-blurred.js-game-container', ->

    div '.game-section.mod-left', ->
      p '.game-section-header', "Letter"
      div '.game-section-detail', ->
        p '.letter', letter

      div '.js-timer-section'

    div '.game-section.mod-right', ->
      p '.game-section-header', "Categories"
      div '.game-section-detail', ->
        ol '.category-list.js-categories', ->
          for cat in catList
            li cat

timerTemplate = renderable ->
  p '.game-section-header', "Time"
  div '.game-section-detail', ->
    p '.js-time-left'

gameOverTemplate = renderable ->
  div '.game-section-detail', ->
    p "Game Over!"

newGameButtonTemplate = renderable ({ isWhite } = { isWhite: false}) ->
  if isWhite
    button '.mod-white.js-new-game', "New Game"
  else
    button '.js-new-game', "New Game"

startButtonTemplate = renderable ->
  button '.js-start-game', "Start"

baseLayoutTemplate = renderable ->
  div '.js-intro'
  div '.js-game'
  div '.button-section.js-header-button', ->


# Business

catChooser = randomNoRepeats(cats)
letterChooser = randomNoRepeats(letters)
audioChooser = randomNoRepeats(sounds)

playRandomSound = ->
  file = audioChooser()
  audio = new Audio("/audio/#{file}")

  audio.addEventListener 'ended', ->
    audio.remove()

  audio.play()

  return

renderTimeLeft = (secondsLeft) ->
  getElem('js-time-left').innerHTML = secondsLeft.toString()

endTimerEvent = ->
  clearInterval(@counterId)
  document.body.classList.add('is-end-of-timer')

  getElem('js-timer-section').innerHTML = gameOverTemplate()
  getElem('js-header-button').innerHTML = newGameButtonTemplate()

  playRandomSound()

  setTimeout ->
    document.body.classList.remove('is-end-of-timer')
  , 7000

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    document.body.classList.remove('is-end-of-timer')
    track 'Game', 'Make New Game', 'From Game'
    false

  return

startCounter = (seconds) ->
  counter = seconds

  getElem('js-timer-section').innerHTML = timerTemplate()
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
  getElem('js-header-button').innerHTML = ''
  getElem('js-game-container').classList.remove('is-blurred')
  startCounter(150)
  return

makeNewGame = ->
  clearInterval(@counterId)
  document.body.classList.remove('is-end-of-timer')

  data =
    letter: letterChooser()
    catList: getMultipleItems(catChooser, 10)

  getElem('js-game').innerHTML = gameTemplate data
  getElem('js-intro').innerHTML = ''
  getElem('js-header-button').innerHTML = startButtonTemplate()

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
  document.body.classList.remove('is-end-of-timer')

  getElem('js-intro').innerHTML = introTemplate()
  getElem('js-game').innerHTML = ''
  getElem('js-header-button').innerHTML = newGameButtonTemplate isWhite: true

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    track 'Game', 'Make New Game', 'From Intro'
    false

  return

renderBaseLayout = ->
  getElem('js-app').innerHTML = baseLayoutTemplate()

  renderIntro()

  return

renderBaseLayout()
