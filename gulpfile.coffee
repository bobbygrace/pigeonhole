{ task, series, parallel, watch, src, dest } = require 'gulp'
path = require 'path'
fs = require 'fs'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
sourcemaps = require 'gulp-sourcemaps'

less = require 'gulp-less'
LessPluginAutoPrefix = require 'less-plugin-autoprefix'
cleanCSS = require 'gulp-clean-css'

minifyHTML = require 'gulp-minify-html'

browserify = require 'browserify'
coffeeify = require 'coffeeify'
babelify = require 'babelify'
uglify = require 'gulp-uglify'


# Styles

stylesSrc = './src/styles/app.less'

autoprefix = new LessPluginAutoPrefix
  browsers: [
    'last 3 Chrome versions'
    'last 3 Firefox versions'
  ]

styles = (done) ->

  return src(stylesSrc)
    .pipe less
      paths: [path.join(__dirname, 'src/styles')]
      plugins: [autoprefix]
    .on 'error', (err) ->
      gutil.log(err)
      this.emit('end')
    .pipe dest('./public/css')
    .pipe cleanCSS()
    .pipe rename('app.min.css')
    .pipe dest('./public/css')


# Templates

templatesSrc = './src/templates/*.html'

templates = (done) ->
  options = { empty: true }

  return src(templatesSrc)
    .pipe minifyHTML(options)
    .pipe dest('./public')

  done()


# Scripts

scriptsDev = (done) ->

  bundle = browserify
    entries: './src/scripts/entries/app.coffee'
    extensions: ['.coffee']
    debug: true

  bundle.transform coffeeify,
    transpile: { presets: ['@babel/env'] }

  return bundle.bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sourcemaps.write('./'))
    .pipe(dest('./public/js/'))

  done()

scripts = (done) ->

  bundle = browserify
    entries: './src/scripts/entries/app.coffee'
    extensions: ['.coffee']

  bundle.transform coffeeify,
    transpile: { presets: ['@babel/env'] }

  return bundle.bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(dest('./public/js/'))

  done()


# Audio

audiodata = (done) ->
  fs.readdir 'public/audio/', (err, files) ->
    data = []

    for file in files
      # No dot files. This could be more smarter.
      if !/^\./.test(file)
        data.push file

    json = JSON.stringify(data)

    fs.writeFile 'src/scripts/data/sounds.json', json, (err) ->
      if err
        console.log err

      console.log 'sounds.json is written.'

      done()


# Watch

watchFiles = ->
  watch './src/styles/*', styles
  watch './src/scripts/**/*', scriptsDev
  watch templatesSrc, templates
  watch './public/audio/*', audiodata


# Exports

exports.styles = styles
exports.templates = templates
exports.scriptsDev = scriptsDev
exports.scripts = scripts
exports.audiodata = audiodata
exports.dev = series(styles, templates, scriptsDev, audiodata, watchFiles)
exports.default = series(styles, templates, audiodata, scripts)
