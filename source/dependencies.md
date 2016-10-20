Managing Dependencies
=======================

The program you write will depend on other code
that other people have written.  This guide will teach you 
how to install, use and upgrade dependencies for your web application. 
It covers ruby, javascript and php.

After working through this guide you will be able to:

* understand what a package manager does for you
* install packages for javascript and node with `npm`
* install gems für ruby with `gem` and `bundler`
* install libraries for php with `composer`
* install programs and libraries for your mac with `brew`
* install programs and libraries for your linux machine with `apt`
* know how to keep your dependencies current

---------------------------------------------------------------------------

Dependencies
-----------

The program you write will depend on other code
that other people have written. Some of this code
has been packaged into operating systems or applications:
Linux, Postgres, Apache, nginx, and so on.

But you also use smaller pieces of code that you include
in your source code or link to your code after compiling.
These dependencies are called libraries, packages or gems in different
programming languages.

We will discuss five different systems:

* `apt` a package manager for Linux (used in debian, ubuntu, and several other distributions)
* `brew` a package manager for mac os
* `gem` and `bundler` for ruby
* `npm` for javascript and node.js
* `composer` for php


### dynamiclly linked libraries

Why do we need to look at `apt` and `brew`?  Isn't the
package manager for my main programing language enough?

In many cases using php-only or ruby-only libraries will be enough.
But sometimes the libraries we use in our dynamic languages use
other code originally written in c or c++.

The image processing library `imagemagick` is a good example.  If you want to use the ruby gem [rmagick](https://rubygems.org/gems/rmagick/versions/2.15.4) to edit images you will find that to install
the gem, you first need to install the program and the library "ImageMagick".
You do this using apt or brew or
[the windows installer with dynamic link libraries](http://www.imagemagick.org/script/binary-releases.php#windows).

The result of installing imagemagick with brew is the file `libMagickCore-6.Q16.2.dylib` and two other libraries.  These are libraries that can be used by multiple programs on your computer when they are dynamically linked to those programs.

When installing the ruby gem with `gem install rmagick` you get the following output:

    Building native extensions.  This could take a while...


Sometimes you need to set include paths when installing gem, e.g.:

```bash
> gem install eventmachine 
... error messages ...
In file included from binder.cpp:20:
./project.h:116:10: fatal error: 'openssl/ssl.h' file not found
#include <openssl/ssl.h>
         ^
> brew install openssl
> gem install eventmachine -- --with-cppflags=-I/usr/local/opt/openssl/include
```


### package names and a central database

To enable easy installation of a dependency with just one command we need
a central database that contains the information on all available packages.
These databases typically also offer a web page with search functionality:

* [rubygems.org](https://rubygems.org/) for ruby
* [npmjs.com](https://www.npmjs.com/) for javascript
* [packagist.org](https://packagist.org/) for php and composer
* [homebrew/core](https://github.com/Homebrew/homebrew-core) is a repository on github, but other "taps" (sources of packges) can be added
* [apt](http://de.archive.ubuntu.com/ubuntu) packages are kept on ftp servers and are not searchable there. other sources can be added to `/etc/apt/sources.list`

Package names need to be unique.  Version numbers are often given out according to [semantic versioning](http://semver.org/).


### How to install

* `apt-get install imagemagick`
* `brew install imagemagick`
* `gem install rmagick`
* `npm install imagemagick`
* `composer install imagemagick`  - does not work, needs PECL 


### Where is the code installed?

All the package managers distinguish between installing **globally** - for all users and projects on a computer and installing **locally**.  This might mean installing in a way that only one user can use, or it might mean installing into a projects directory.

When you deploy your project to a production server you again face this question: should
the dependencies be installed globally or locally?

Dependency Hell
---------------


For a big web project you will be using a lot of dependencies. This will lead
to two problems (here shown in a ruby projects with gems):

1. dependency resolution: gem A depends on version 1.1 of gem C, while gem B wants at least version 1.5.  You need to find the right version of every gem in your project that actually fits together
2. different installation: when deploying to a production server, or even just when sharing code with other developers you need to make sure that the same constellation of gems and versions is used on every machine

If this all goes horribly wrong you are in "dependency hell": you can't find the right versions
of gems to make your code work again on a new machine or after an update.

### Escape from Depencency Hell

![bundler](images/bundler-small.png)

Bundler is the name of the ruby tool that solves this problem for ruby.
Bundler is itself a gem, so you install it with `gem install bundler`.
Beware: the command you will be using called `bundle`, not bundler.

There is how it works: In every ruby project you write
a `Gemfile` in which you define which gems and (to a certain degree) which versions you want.
When you run `bundle install` bundler will:

* read the Gemfile, 
* pick out compatible versions of all the gems (if possible), 
* install all these gems
* write `Gemfile.lock`

The lock-file contains a complete list of all the gems necessary for
your project, and their version numbers.  This also includes dependencies of you
dependencies, that you don't even knew you were using!
The version numbers are now locked down, and will not change!

When deploying to a new development machine or the production server, 
you run `bundle install` and the exact same versions are now installed.

All modern package managment systems offer a form of this solution, with

* on file that is written by hand that contains your **wishes** 
* another file that is created by the package manager, that contains the exact version numbers


### Defining Versions

When definig your wishes for dependencies you can specify which versions should be used.
But don't overdo it!  The package manager does a good job picking versions.
If you specify every version number by hand you are doing too much work. And you
are potentially locking yourself in to old versions.

Some examples of the different ways of specifying version number and source in a ruby `Gemfile`:

``` ruby
# Gemfile
source 'https://rubygems.org'

ruby '2.1.5'

gem 'devise'
gem 'rails', '4.2.5'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
```

Giving an exact version number fixes that version, so only
version 4.2.5 of rails will be allowed here.  Using the "greater-or-equal-than" sign
you can require any version greater or equal to 1.3.0.  So 1.2.7 is forbidden,
but 1.3.2 or 1.4.0 or 2.2.0 is allowed.

The arrow `~>` will only allow an increase in the 
last (right most) number, so `~> 4.1.0` does allow `4.1.17` but not `4.2`.
This is called a pessimistic version constraint, read more about 
it in [the rubygem documentation](http://guides.rubygems.org/patterns/#pessimistic-version-constraint).


### Keeping Up To Date

Let's assume you list 12 dependencies in your project. This might result in 36 dependencies 
being installed in all.  Now assume each dependency releases a new version once a year. You
have to be prepared for updating several dependencies each month!

To update the versions you need to override the lock-file and allow a change in version numbers.

For each dependency system we discussed there are services out there that will tell
you about new version or -- even more important -- new security updates for your dependencies.


Dependency Managment in Detail
-----------

More detailled information on the five systems is available on separate pages:

* `apt` a package manager for Linux (used in debian, ubuntu, and several other distributions)
* `brew` a package manager for mac os
* `gem` and `bundler` for ruby
* `npm` for javascript and node.js
* `composer` for php


 


