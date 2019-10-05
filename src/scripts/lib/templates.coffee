# Teacup
import { renderable, div, p, img, span, text, strong, a, button, blockquote,
  ol, li, h1, h2, label } from 'teacup'

module.exports = {

  baseLayout: renderable ->
    div '.js-overlay'
    div '.js-intro'
    div '.js-game'
    return

  intro: renderable ->

    div '.intro', ->
      div '.intro-content', ->
        div '.intro-header', ->
          div '.logo', ->
            img '.logo-image', src: '/images/logo-light.svg'
            h1 '.logo-text', "Pigeonhole"
          p '.intro-header-opening', "A word game of categories."
          button '.intro-header-start-button.js-open-new-game-overlay', "Start"

        div '.intro-content-section', ->
          h2 '.intro-content-section-header', "How to Play"
          div '.intro-content-section-details', ->

            ol ->
              li ->
                p "Gather a group of friends around the screen.
                  There is no player limit. The more the merrier!"
              li ->
                p "When you start a game, you get one letter,
                  ten categories, and two and a half minutes."
              li ->
                p "You and your friends scramble to find words or phrases that
                  start with the given letter for each category."
              li ->
                p "A timer will go off at the end of the game. Compare answers.
                  For each unique answer, you get a point."

        div '.intro-content-section', ->
          p '.intro-content-section-details', ->
            text "Made by "
            a href: "http://bobbygrace.info", "Bobby"
            text " and Madeleine Grace"

  radioButton: renderable ({labelText, name, isChecked}) ->

    classes = '.radio-button'
    if isChecked
      classes += '.is-checked'

    div classes, ->
      button '.radio-button-check.js-select-pack', {'data-name': name}
      label '.radio-button-label', labelText

  newGameOverlay: renderable () ->
    div '.new-game-overlay', ->
      div '.new-game-overlay-content', ->
        h2 "Pick a pack"
        div '.pack-chooser.js-fill-packs'
        h2 "Ready?"
        button '.js-start-game', "Start"

  packButton: renderable ({name, displayName}) ->
    button '.mod-pack.js-select-pack', {'data-name': name}, displayName

  game: renderable ({letter, catList}) ->

    div '.game.is-blurred.js-game-container', ->

      div '.game-section.mod-left', ->
        p '.game-section-header', "Letter"
        div '.game-section-detail', ->
          p '.letter', letter

        div '.js-timer-section', ->
          p '.game-section-header', "Time"
          div '.game-section-detail', ->
            p '.game-timer.js-time-left'

      div '.game-section.mod-right', ->
        p '.game-section-header', "Categories"
        div '.game-section-detail', ->
          ol '.category-list.js-categories', ->
            for cat in catList
              li '.category-list-item', cat

    div '.button-bar', ->

      div '.button-bar-left-section', ->
        a '.logo-button.js-show-intro', href: '#', title: 'Go back', ->
          img '.logo-button-image', src: '/images/logo-light.svg'
          span '.logo-button-text', "Pigeonhole"

      div '.button-bar-right-section.js-fill-button-bar', ->

  gameOverButtons: renderable ->
    button '.mod-button-bar.js-new-game', "New Game"

  startButton: renderable ->
    button '.js-start-game', "Start"

}
