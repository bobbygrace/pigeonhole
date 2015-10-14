letters = require '../data/letters.coffee'
cats = require '../data/categories.coffee'
sounds = require '../data/sounds.json'
shuffle = require 'knuth-shuffle'
{ renderable, div, p, img, span, text, strong, a, button, ol, li, h1, h2 } = require 'teacup'

@counterId = null


# Utilities

getRandomItems = (items, number) ->
  shuffle.knuthShuffle(items).slice(0, number ? 1)

getElem = (className) ->
  # Takes only 'js-' prefixed class name
  document.getElementsByClassName(className)[0]


# Templates

introTemplate = renderable ->
  howToText = "Get a lot of people together. Write 1 though 10 on many
    sheets of paper and hand them out. Ready? Hit “Start”. You’ll get one
    letter, ten categories, and two and a half minutes. Write down an answer
    for each of the categories that starts with the letter. For example, you
    get the letter “B” and category “Foods You Can Eat with a Fork or with
    Your Hands”. That’s easy. “Burrito.” It can be a word or short phrase. Now
    on to the next category. Hurry. Just write something down. Make it
    original! Oh, you can’t use the same answer for multiple categories. What’s
    that funny noise? It’s the end of the round. Phew. Now compare. Everyone
    list off what they had for the first category. If nobody else had the same
    answer, then you get a point for that category. If more than half the
    people say, “No way. That doesn’t count.” then it doesn’t count. Now
    compare the next category and so one. Keep track of the points if you want.
    Click “New Game” for another round. Keep playing rounds until you pass out.
    When you wake up, compare points. Ignore the points. Everybody wins. Click
    “New Game”."

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
        p '.intro-content-section-details', howToText
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

playRandomSound = ->
  file = getRandomItems(sounds)
  audio = new Audio("/audio/#{file}")

  audio.addEventListener 'ended', ->
    audio.remove()

  audio.play()

  return

renderTimeLeft = (secondsLeft) ->
  getElem('js-time-left').innerHTML = secondsLeft.toString()

endTimerEvent = ->
  clearInterval(@counterId)
  document.body.classList.add('end-o-timer')
  getElem('js-timer-section').innerHTML = gameOverTemplate()
  getElem('js-header-button').innerHTML = newGameButtonTemplate()
  playRandomSound()
  setTimeout ->
    document.body.classList.remove('end-o-timer')
  , 7000

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    document.body.classList.remove('end-o-timer')
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

  data =
    letter: getRandomItems(letters)[0]
    catList: getRandomItems(cats, 10)

  getElem('js-game').innerHTML = gameTemplate data
  getElem('js-intro').innerHTML = ''
  getElem('js-header-button').innerHTML = startButtonTemplate()

  getElem('js-start-game').addEventListener 'click', (e) ->
    startGame()
    false

  getElem('js-show-intro').addEventListener 'click', (e) ->
    renderIntro()
    false

  return

renderIntro = ->
  clearInterval(@counterId)
  getElem('js-intro').innerHTML = introTemplate()
  getElem('js-game').innerHTML = ''
  getElem('js-header-button').innerHTML = newGameButtonTemplate isWhite: true

  getElem('js-new-game').addEventListener 'click', (e) ->
    makeNewGame()
    false

  return

renderBaseLayout = ->
  getElem('js-app').innerHTML = baseLayoutTemplate()

  renderIntro()

  return

renderBaseLayout()
