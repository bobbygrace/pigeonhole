# Teacup
{ renderable, div, p, img, span, text, strong, a, button, blockquote, ol, li,
  h1, h2 } = require 'teacup'

module.exports = {

  baseLayout: renderable ->
    div '.js-intro'
    div '.js-game'
    div '.js-overlay'
    return

  intro: renderable ->

    div '.intro', ->
      div '.intro-content', ->
        div '.intro-content-section', ->
          p '.intro-content-section-header', "This is"
          p '.intro-content-section-details', ->
            strong "Pigeonhole"

        div '.intro-content-section', ->
          p '.intro-content-section-header', "Packs"
          div '.intro-content-section-details', ->
            div '.js-pack-list'

        div '.intro-content-section', ->
          p '.intro-content-section-header', "How to Play"
          div '.intro-content-section-details', ->

            ol ->
              li ->
                p "Get a bunch of people together around the screen. Have
                  everyone write 1 through 10 on sheets of paper. Ready? Hit
                  “New Game” then start."
                blockquote "You can’t have too many people. It’s more fun with
                  more people."
              li ->
                p "You’ll get one letter, ten categories, and two and a half
                  minutes. Write an answer that fits into each of the categories
                  that starts with the letter. Make it original. You can’t use
                  the same answer for multiple categories."
                blockquote "Need an example? You have the letter “B” and
                  category “Foods You Can Eat with a Fork or with Your Hands”.
                  That’s easy! “Burrito.”"
                blockquote "An answer can be a word or a short phrase."
              li ->
                p "That funny noise means it’s the end of the round. Time to
                  compare answers. Everyone say what they had for the first
                  category. If nobody else had the same answer, you get a point.
                  Compare the next category and so on."
                blockquote "You can put an answer to a vote. If half or more of
                  the players say, “No way. That doesn’t count.” then sorry, the
                  group has spoken. It doesn’t count."
              li ->
                p "Play another round by clicking “New Game”. If the group is
                  feeling competitive, keep track of the points and compare at
                  the end. As long as you laugh and have a good time, everyone
                  wins."
                blockquote "If you want, you can give multiple points for each
                  word in an answer that starts with the letter. For example,
                  you would get three points for “Black Bean Burrito”."
                blockquote "For an extra challenge, don’t use adjectives for the
                  first word in the phrase."
                blockquote "You may play all night so it’s best to have blankets
                  and pillows laying around in case people fall asleep."

        div '.intro-content-section', ->
          p '.intro-content-section-header', "Made By"
          p '.intro-content-section-details', ->
            a href: "http://bobbygrace.info", "Bobby Grace"
            text " and "
            a href: "http://madeleineburkart.com", "Madeleine Burkart"

  packButton: renderable ({name, displayName}) ->
    button '.mod-white.mod-pack.js-select-pack', {'data-name': name}, displayName

  game: renderable ({letter, catList}) ->

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

    div '.button-bar', ->

      div '.button-bar-left-section', ->
        a '.logo-button.js-show-intro', href: '#', title: 'Go back', ->
          img '.logo-button-image', src: '/images/logo-green.svg'
          span '.logo-button-text', "Pigeonhole"

      div '.button-bar-right-section.js-fill-button-bar', ->


  startGameOverlay: renderable ->
    div '.center-overlay.js-section-start-game', ->
      button '.mod-big-time.js-start-game', "Start"

  gameOverButtons: renderable ->
    button '.mod-button-bar.js-new-game', "New Game"

  timer: renderable ->
    p '.game-section-header', "Time"
    div '.game-section-detail', ->
      p '.js-time-left'

  gameOver: renderable ->
    div '.game-section-detail', ->
      p "Game Over!"

  startButton: renderable ->
    button '.js-start-game', "Start"

}
