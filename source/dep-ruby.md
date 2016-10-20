Managing Dependencies in Ruby
=======================

This guide will teach you 
how to install, use and upgrade dependencies in ruby and rails.

After working through this guide you will be able to:

* install gems für ruby with `gem` and `bundler`
* know how to keep your dependencies current

---------------------------------------------------------------------------


## ruby and gems


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

### bundler

![bundler](images/bundler-small.png)

Bundler is the name of the tool that saves us from dependency hell in ruby.
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

