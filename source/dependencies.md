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

Why do we need to look at `apt` and `brew`?  Isn't the
package manager for my main programing language enough?

In many cases using php-only or ruby-only libraries will be enough.
But sometimes the libraries we use in our dynamic languages use
other code originally written in c or c++.

The image processing library `imagemagick` and the encryption and network library
`openssl` are two good examples.  If you want to use the ruby gem [rmagick](https://rubygems.org/gems/rmagick/versions/2.15.4) to edit images you will find that to install
the gem, you first need to install the program+library "ImageMagick" (using apt or brew).



### How to install

* `apt-get install imagemagick`
* `brew install imagemagick`
* `gem install rmagick`
* `npm install imagemagick`
* `composer install imagemagick`


### Where is the code installed?

* `apt` and the packages it uses conform to the linux file standard conventions. You can find out where it put the files by issuing dpkg -L imagemagick
* `brew` installs in just one location:  `/usr/local/Cellar/`.  You can find out where it put the files by issuing `brew list imagemagic`. brew created a folder structure with the package name and the version number: /usr/local/Cellar/imagemagick/6.9.4-1_1/  and added several subfolders (lib/, etc/, ....)
* `gem` creates a folder that combines package name and version number rmagick-2.15.4/ to install the package
* `composer`...
* `npm` install the package inside your project, in a folder called `node_packages`

We will look at ruby and its gems as a first example of how to
use dependencies.  

### ruby and gems

`rubygems` is the package manager for ruby,
it let's you install gems on your system.

A gem has a name  (e.g. `rake`) and a version number (e.g. `10.4.2`).
It can be written in plain ruby or sometimes in ruby and c.  Many gems
depend on system libraries that need to be installed before the gem can
be installed.  For example the [rmagick](https://rubygems.org/gems/rmagick/versions/2.15.4)
gem for image manipulation needs the library `ImageMagick`.

So most of the time installing a gem is as simple as

```bash
> gem install rails_best_practices
Successfully installed rails_best_practices-1.15.7
Parsing documentation for rails_best_practices-1.15.7
Installing ri documentation for rails_best_practices-1.15.7
Done installing documentation for rails_best_practices after 2 seconds
1 gem installed
```

But sometimes you have to do other installations first. 
On your development machine this might look like this:

```bash
# install node on a mac
> brew install nodejs
> gem install uglifier
```

Sometimes you need to set include paths when compiling the c-part of the gem, e.g.:

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

In production you probably have to deal with Linux, and you
may not have the right permissions to install system libraries.
A typical example would be:

``` shell
$dev> ssh my.production.machine
$production> sudo apt-get install libmagick++-dev
$production> gem install rmagick
$production> gem install paperclip
```

Now that you have installed the gem once by hand
you can be sure that it can also be reinstalled by bundler.

See also:

* [what is a gem](http://docs.rubygems.org/read/chapter/24)
* find 100.000 gems at [rubygems.org](http://rubygems.org/)

### dependency hell

For a big web project you will be using a lot of gems. This will lead
to two problems:

1. dependency resolution: gem A depends on version 1.1 of gem C, while gem B wants at least version 1.5.  You need to find the right version of every gem in your project that actually fits together
2. different installation: when deploying to a production server, or even just when sharing code with other developers you need to make sure that the same constellation of gems and versions is used on every machine

If this all goes horribly wrong you are in "dependency hell": you can't find the right versions
of gems to make your code work again on a new machine or after an update.

### bundler saves us

![bundler](images/bundler-small.png)

Bundler is the name of the tool that saves us from dependency hell.
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
your project, and their version numbers.  These are now locked down,
and will not change!

When deploying to a new development machine or the production server, 
you run `bundle install` and the exact same versions are now installed.


### defining versions

In the Gemfile you can specify which versions should be used.
But don't overdo it!  Bundler does a good job picking versions,
if you specify every version number by hand you are doing too much work.

Some examples of the different ways of specifying version number and source:

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


