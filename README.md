Pigeonhole
====

## The Development Tools

- [Gulp](http://gulpjs.com/)
- [st](https://github.com/isaacs/st)
- [CoffeeScript](http://coffeescript.org/)
- [Browserify](http://browserify.org/)
- [LESS](http://lesscss.org/)
  - [normalize.css](http://necolas.github.io/normalize.css/)
  - [autoprefixer](https://github.com/less/less-plugin-autoprefix)


## How to set up development…

- `npm install`
- Build and watch styles and templates with `./tools/gulp`
- Watch JavaScript bundle with `./tools/watch`
- Build JavaScript bundle with `./tools/build` (for production)
- Serve locally with `./tools/serve`
- Visit [localhost:8080](http://localhost:8080) to view your site.


## Serving

Everything in `/public` is static and servable, so you don’t necessarily
need to serve via the included app.coffee in production. But if you do use
app.coffee, be sure to set the environment variable on your server with
`export NODE_ENV=production`. You can change the port in
`/config/production.json`.
