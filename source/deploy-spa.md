Deploy a Single Page App
=======================

A Single Page App makes one html file appear
to contain many pages.  To host such an app
you need a very specific configuration of a webserver 

After reading it you should be familiar with:

* How to host a SPA on Heroku
* How to configure Apache for a SPA


---------------------------------------------------------------------------

URLS and Routing in a SPA
---------

A Single Page App makes one html file appear
to contain many pages.  When a users clicks on a link
the URL changes and new content appears, just like
in a classical static web site.  But the new
content and the URL change are both done by JavaScript.

See [How Single-Page Applications Work](https://blog.pshrmn.com/entry/how-single-page-applications-work/) for a good introduction.


For example let's consider the single page app on `https://mini-spa-demo.herokuapps.com/`. There might be only one `index.html`, but inside this page the URL might be changed to

* `https://mini-spa-demo.herokuapps.com/about`
* `https://mini-spa-demo.herokuapps.com/product/1`
* `https://mini-spa-demo.herokuapps.com/product/2`

and so on.

Each of these URLs also need to work when you call them
directly, without entering through index.html.  This is
what we need to configure our webserver for.



Deploying to Heroku
-------------------

You need a heroku account and the heroku toolbelt (= command line program) installed. Remember: heroku expects your app to be in the **root folder of the repository**!!

Heroku offers a plugin to the heroku toolbelt, install it with

```sh
$ heroku plugins:install heroku-cli-static
```

Got to your SPAs root folder and run

```sh
$ heroku create
```

to create a new heroku app.  you will be told the URL of your app.

Now you can start the setup process: First define the buildpacks

```sh
$ heroku buildpacks:add heroku/nodejs
$ heroku buildpacks:add https://github.com/hone/heroku-buildpack-static
```

We need two buildpacks: nodejs to run the build, and static to do
the actuall serving of the pages.  

The node buildpack will run `npm install` automatically.
this is considered to be the build step. But we need another
build step to build our app. So we add `heroku-postbuild` 
to `package.json` and run our build there:

```sh
    "heroku-postbuild": "webpack --mode production",
```


To configure the static buildpack we create a file `static.json`:

```sh
$ heroku static:init
? Enter the directory of your app: dist/
? Drop `.html` extensions from urls? Yes
? Path to custom error page from root directory: 404
{
  "root": "dist/",
  "clean_urls": true,
  "error_page": "404"
}
```

This creates the file `static.json`. You could have created this file
by hand. Now we need to add information about the routing in our page.
For example: the build process creates a structure.

```
--+ dist
  |-+ fonts
    + Roboto-Regular.woff
    + Roboto-Regular.woff2
  |-+ images
    + logo.svg
  + index.html
  + style.b15a70a9c7e59c773405.css
  + main.ff30a167f508273f99d6.js
```

the fonts, images, css and js files should be served by the webserver directly.  All other URLs should be handled by index.html. This can be configured in `static.json` like this:

```sh
{
  "root": "dist/",
  "clean_urls": true,
  "error_page": "404.html",
  "routes": {
    "/fonts/*":  "/fonts/",
    "/images/*": "/images/",
    "/*.js":     "/",
    "/*.css":    "/",
    "/**":       "index.html"
  }  
}
```



See Also
--------

* [heroku-cli-static](https://www.npmjs.com/package/heroku-cli-static)
* [static buildpack for heroku](https://github.com/heroku/heroku-buildpack-static)
