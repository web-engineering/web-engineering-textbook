Dependencies
=======================


The program you write will depend on code
that other people have written. This guide will teach you
how to install, use and upgrade dependencies for your web application.
It covers ruby, javascript and php.

After working through this guide you will be able to:

- understand what a package manager does for you
- install packages for javascript and node with `npm`
- install gems für ruby with `gem` and `bundler`
- install libraries for php with `composer`
- install programs and libraries for your operating system with `brew`, `apt` or `choco`
- know how to keep your dependencies current

---------------------------------------------------------------------------


## Dependencies

The program you write will depend on code
that other people have written. Some of this code
has been packaged into operating systems or applications:
Linux, Postgres, Apache, nginx, and so on.

But you also use smaller pieces of code that you include
in your source code or link to your code after compiling.
These dependencies are called libraries, packages or gems in different
programming languages.

We will discuss six different systems:

- Package management for the operating system:
  - `apt` a package manager for Linux (used in debian, ubuntu, and several other distributions)
  - `brew` a package manager for mac os
  - `choco` a package manager for windows
- Package management for a programming language:
  - `gem` and `bundler` for ruby
  - `npm` for javascript and node.js
  - `composer` for php

### The other side

While this chapter is about using dependencies, you might also consider
what goes into creating a good dependency: how do I write code that can
be reused? How do I split up a larger problem into smaller pieces that can
be reused?

Therese are questions of software design and software architecture. They go
back a long time (e.g. D.L. Parnas. (1972). On the criteria to be used in decomposing systems into modules. Communications of the ACM, 15(12), 1053–1058. doi: 10.1007/978-3-642-48354-7_20, discussed in
[morning papers](https://blog.acolyer.org/2016/09/05/on-the-criteria-to-be-used-in-decomposing-systems-into-modules/)).

### libraries.io

The site [libraries.io](https://libraries.io/) collects information
for many package management systems, it's a central place to look
for software to use.

### dynamiclly linked libraries

Why do we need to look at `apt`, `brew` or `choco`? Isn't the
package manager for my main programing language enough?

In many cases using php-only or ruby-only libraries will be enough.
But sometimes the libraries we use in our dynamic languages use
other code originally written in c or c++.

The image processing library `imagemagick` is a good example. If you want to use the ruby gem [rmagick](https://rubygems.org/gems/rmagick/versions/2.15.4) or the npm package [easyimage](https://www.npmjs.com/package/easyimage) to edit images you will that they deplend on the library "ImageMagick"
which is writen in [C](https://github.com/ImageMagick/ImageMagick/tree/master/MagickCore).

You do this using apt or brew or
[the windows installer with dynamic link libraries](http://www.imagemagick.org/script/binary-releases.php#windows).

```
sudo apt-get install imagemagick libmagickwand-dev  # ubuntu, wls
brew install imagemagick                            # macos
```

The result of installing imagemagick with brew is the file `libMagickCore-6.Q16.2.dylib` and two other libraries. These are libraries that can be used by multiple programs on your computer when they are dynamically linked to those programs.

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

- [apt](http://de.archive.ubuntu.com/ubuntu) packages are kept on ftp servers and are not searchable there. other sources can be added to `/etc/apt/sources.list`
- [homebrew/core](https://github.com/Homebrew/homebrew-core) is a repository on github, but other "taps" (sources of packges) can be added
- choco
- [rubygems.org](https://rubygems.org/) for ruby
- [npmjs.com](https://www.npmjs.com/) for javascript
- [packagist.org](https://packagist.org/) for php and composer
  Package names need to be unique. Version numbers are often given out according to [semantic versioning](http://semver.org/).

### How to install

- `apt-get install imagemagick`
- `brew install imagemagick`
- `choco install imagemagick`
- `gem install rmagick`
- `npm install imagemagick`
- `composer install imagemagick` - does not work, needs PECL

### Where is the code installed?

All the package managers distinguish between installing **globally** - for all users and projects on a computer and installing **locally**. This might mean installing in a way that only one user can use, or it might mean installing into a projects directory.

When you deploy your project to a production server you again face this question: should
the dependencies be installed globally or locally?

### Security considerations

Downloading and using software is always dangerous. With a package
management system a lot of downloads happen automatically. So we want
to make sure the software we download is really what it is supposed to be.

A package management system can offer different methods of making it more secure:

- comparing **checksums** of the code to make sure the downloaded package contains the same code as the original package
- cryptographically **signing** the code in the package and checking this signature before installing. This ensures
  that only the original author of the package can release new versions.

## Dependency Hell

For a big web project you will be using a lot of dependencies. This will lead
to two problems (here shown in a ruby projects with gems):

1. dependency resolution: gem A depends on version 1.1 of gem C, while gem B wants at least version 1.5. You need to find the right version for every gem in your project so that they actually all fit together
2. different installation: when deploying to a production server, or even just when sharing code with other developers you need to make sure that the same constellation of gems and versions is used on every machine

If this all goes horribly wrong you are in "dependency hell": you can't find the right versions
of gems to make your code work again on a new machine or after an update.

### Escape from Depencency Hell

![bundler](images/bundler-small.png)

Bundler is the name of the ruby tool that solves this problem for ruby.
Bundler is itself a gem, so you install it with `gem install bundler`.
Beware: the command you will be using called `bundle`, not bundler.

This is how it works: In every ruby project you write
a `Gemfile` in which you define which gems and (to a certain degree) which versions you want.
When you run `bundle install` bundler will:

- read the Gemfile,
- pick out compatible versions of all the gems and their dependencies (if possible),
- install all these gems
- write `Gemfile.lock`

The lock-file contains a complete list of all the gems necessary for
your project, and their version numbers. This also includes dependencies of you
dependencies, that you don't even knew you were using!
The version numbers are now locked down, and will not change.

When deploying to a new development machine or the production server,
you run `bundle install` and the exact same versions are now installed.

All modern package managment systems offer a form of this solution, with

- one file that is written by hand that contains your **wishes**
- another file that is created by the package manager, that contains the exact version numbers

You can add packages by editing the Gemfile, or on the commandline with `bundle add` and
the name of the gem.

### Defining Versions

When definig your wishes for dependencies you can specify which versions should be used.
But don't overdo it! The package manager does a good job picking versions.
If you specify every version number by hand you are doing too much work. And you
are potentially locking yourself in to old versions.

Some examples of the different ways of specifying version number and source in a ruby `Gemfile`:

```ruby
# Gemfile
source 'https://rubygems.org'

ruby '2.1.5'

gem 'devise'
gem 'rails', '4.2.5'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
```

Giving an exact version number fixes that version, so only
version 4.2.5 of rails will be allowed here. Using the "greater-or-equal-than" sign
you can require any version greater or equal to 1.3.0. So 1.2.7 is forbidden,
but 1.3.2 or 1.4.0 or 2.2.0 is allowed.

The arrow `~>` will only allow an increase in the
last (right most) number, so `~> 4.1.0` does allow `4.1.17` but not `4.2`.
This is called a pessimistic version constraint, read more about
it in [the rubygem documentation](http://guides.rubygems.org/patterns/#pessimistic-version-constraint).

There now is a common standard on how to use version numbers called
[semantic versioning](http://semver.org/). In short: Use three numbers
for your version number: MAJOR dot MINOR dot PATCH. For example 3.1.0.

- a new '''major''' version number means incompatible API changes,
- a new '''minor''' version number means added functionality in a backwards-compatible manner, and
- a new '''patch''' version means backwards-compatible bug fixes.

But not all projects adher to this standard yet.

### Keeping Up To Date

Let's assume you list 12 dependencies in your project. This might result in 36 dependencies
being installed in all. Now assume each dependency releases a new version once a year. You
have to be prepared for updating several dependencies each month!

To update the versions you need to override the lock-file and allow a change in version numbers.

For each dependency system we discussed there are services out there that will tell
you about new version or -- even more important -- new security updates for your dependencies.

## Dependencies always imply Risk

Using a third party library will make you more
productive today. But it could well harm you in the long run:

- It might change drastically in the future, like Angular 2 did. See [Ceddias article on upgrading von Angular 1 to Angular 2](https://daveceddia.com/angular-2-should-you-upgrade/)
- It might be discontinued and disappear completely, like Parse did three years after it was [aquired by facebook](https://www.crunchbase.com/organization/parse#/entity). See [their final announcement](http://blog.parse.com/announcements/moving-on/)
- It might disappear and be replaced, causing havoc in the meantime, like left_pad did. See [article in theregister on left_pad](http://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/)

These examples were taken from [a longer article](https://medium.freecodecamp.com/code-dependencies-are-the-devil-35ed28b556d#.4a7d59i6u) that discusses ways to minimize the risk.

- Use [bundlephobia](https://bundlephobia.com/) to measure the size of javascript dependencies

## Quick Start Guides

### apt for Linux

The Advanced Package Tool, or APT, handles the installation and removal
of software on the Debian, Ubuntu and other Linux distributions.
It installs both complete programs (like apache in the example below)
and libraries (like libssl in the example below) that can be used to build programs.

```
apt install apache2
apt install libssl-dev
```

The software is downloaded from a file system (e.g. a DVD) or an FTP server.
Each Linux distribution keeps their own server.
You can search for software with `apt search`

```
$ apt search xml
[...]
xmlto/xenial 0.0.28-0.1 amd64
  XML-to-any converter

xmltoman/xenial,xenial 0.4-3 all
  simple XML to man converter

xmltooling-schemas/xenial,xenial 1.5.6-2 all
  XML schemas for XMLTooling
[...]
```

The software is installed into the usual folder used in UNIX
(see also the [Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard):

- `/etc` for configuration files
- `/bin` and `/lib` for essential binaries and libraries
- `/usr/bin` and `/usr/lib` for non-essential (=most) binaries and libraries

You can find out what exactly got installed by running the `dpkg` command:

```
$ dpkg -L libmagickcore
/.
/usr
/usr/lib
/usr/lib/x86_64-linux-gnu
/usr/lib/x86_64-linux-gnu/libMagickCore-6.Q16.so.2.0.0
/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9
/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/modules-Q16
/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/modules-Q16/filters
/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/modules-Q16/filters/analyze.so
/usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/modules-Q16/filters/analyze.la
[...]
```

As apt installs many types of software, there are many ways to use this software:

- command line tools: you just run them on the command line, like `wget http://io9.com`
- daemons: you start and stop them with the service command, like `service apache2 start`
- c libraries: include the header-file in your own c program, like `#include <PCSC/winscard.h>` and then link the library
- other libraries: depends on the programming language

### brew for mac os

Homebrew is a package manager for Mac OS. It builds
software from source, applying patches to make the software
mac compatible.

It installs both complete programs (like postgresql in the example below)
and libraries (like libyaml in the example below) that can be used to build programs.

```
brew install postgresql
brew install libyaml
```

You can search for software with `brew search`:

```
$ brew search xml
[...]
homebrew/php/php54-wbxml               libxml++3
homebrew/php/php54-xmldiff             libxml2 ✔
homebrew/php/php55-wbxml               libxmlsec1
[...]
```

Homebrew is a git repository in `/usr/local/Homebew`. It installs
software into `/usr/local/Cellar` and then creates links from
`/usr/local/bin` or `/usr/local/lib` as appropriate.

You can find out what exactly got installed by running the `brew list` command:

```
$ brew list libyaml
/usr/local/Cellar/libyaml/0.1.7/include/yaml.h
/usr/local/Cellar/libyaml/0.1.7/lib/libyaml-0.2.dylib
/usr/local/Cellar/libyaml/0.1.7/lib/pkgconfig/yaml-0.1.pc
/usr/local/Cellar/libyaml/0.1.7/lib/ (2 other files)

$ brew list postgresql
/usr/local/Cellar/postgresql/9.5.4_1/bin/clusterdb
/usr/local/Cellar/postgresql/9.5.4_1/bin/createdb
[...]
```

The executable programs in the last example can
be found as links in `/usr/local/bin/`

```
lrwxr-xr-x  user  clusterdb -> ../Cellar/postgresql/9.5.4_1/bin/clusterdb
lrwxr-xr-x  user  createdb -> ../Cellar/postgresql/9.5.4_1/bin/createdb
```

As brew installs many types of software, there are many ways to use this software:

- command line tools: you just run them on the command line, like `wget http://io9.com`
- daemons: you start and stop them with the service command, like `brew services start postgresql`
- c libraries: include the header-file in your own c program, like `#include <yaml.h>` and then link the library
- other libraries: depends on the programming language

### choco for windows

### gem and bundler for ruby

Libraries for ruby are called **gems** and can be installed using the command lin tool `gem`:

```
gem install pg
```

The gems are stored on a central server `https://rubygems.org`.
You can use `gem search` or the web interface to find gems.

```
$ gem search xml
[...]
klarna-xmlrpc (0.2.1)
koara-xml (0.13.0)
latexml-ruby (0.0.2)
libxml-ext (0.4.2)
[...]
```

Gems will normally be installed "globally" = in a way that they
can be used by several users for several projects.

- e.g. `C:/RailsInstaller/Ruby2.2.0/lib/ruby/gems/2.2.0` on Windows
- e.g. `/usr/lib/ruby/2.3.0/` on Linux

You can find out where a gem is installed by using `gem which`.

On many machines `rvm` - the ruby version manager - is used to switch
between different versions of the programming language. Then each version
of the language has it's own set of gems, and the paths include the
word `rvm`:

- `/usr/local/rvm/gems/ruby-2.2.3/gems/pg-0.18.4/lib/pg.rb` Unix, global rvm, ruby version 2.2.3, gem `pg` for postgresql
- `/Users/USERNAME/.rvm/rubies/ruby-2.3.0/gems/pg-0.18.4/lib/pg.rb` Windows, rvm installed for one user only, ruby version 2.3.0, gem `pg` for postgresql

To use gems in your ruby project you will write a `Gemfile` where you
list the gems (and maybe the versions) that you need, e.g.:

```
source 'https://rubygems.org'

gem 'activerecord'
gem 'pg'
gem 'mechanize'
```

To install all the gems and their dependencies run the command `bundle`.
The bundler will find a constellation of dependencies and versions
that work well together, and write this information to `Gemfile.lock`.

In a non-rails project you load the gems in the ruby files that need
them with `require`:

```
require 'active_record'
```

In a rails project this is not necessary, the gems are loaded by rails.

When using git with ruby you add `Gemfile` and `Gemfile.lock` to the
repository.

Keeping up to date:

- `bundle outdated` shows which gems can be updated
- [bummr](https://github.com/lpender/bummr) update each gem separately, removes failing updates
- [brakeman](https://github.com/presidentbeef/brakeman) check for security risks, incl

### npm for javascript and node.js

Libraries for javascript are called **packages** and can be installed using the command line tool `npm`:

```
npm install should
```

You can search for packages using `npm search` or the web search interface
at [https://www.npmjs.com/](https://www.npmjs.com/).

```
$ npm search xml
[...]
muxml-cli         Streaming XML parser and formatter      =t1st3
mxmlc             Node.js module to build ActionScript    =meekgeek
naive-request     Very simple xmlhttp library for the…    =kev_nz
named-items-rss   RSS feed generator.                     =jamierevans
[...]
```

Packages will normally be installed "locally" in the sub-folder `node_modules`.
If you want to install them globally add `-g` to the command:

```
npm install -g grunt
```

To use packages in your javascript project you will write a `package.json` file where you list the packages (and maybe the versions) that you need. To create
the first version of this file use `npm init`. Then you can use the `--save`
option to install packages and at the same time add them to the file:

```
$ npm install --save should
my_first_javascript_project@1.0.0 /Users/USERNAME/mfjsp
└─┬ should@11.1.1
  ├── should-equal@1.0.1
  ├── should-format@3.0.2
  ├── should-type@1.4.0
  ├── should-type-adaptors@1.0.1
  └── should-util@1.0.0

$ cat package.json
{
  "name": "my_first_javascript_project",
  "version": "1.0.0",
  "description": "reimplementation of leftpad",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Maria Musterfrau",
  "license": "ISC",
  "dependencies": {
    "should": "^11.1.1"
  }
}
```

In a serverside node.js project load the packages with `require`. Before ECMAScript2015:

```
const http = require('http');
```

In ECMAScript2015:

```
import { http } from 'http';
```

To fix the exact versions of all dependencies, use
`npm shrinkwrap`. This command creates a file `npm-shrinkwrap.json`.

When using git with a node.js project you add `packages.json` and `npm-shrinkwrap.json` to the repository, and `node_modules` to `.gitignore`.

### composer and packagist for php

One package manager for php is `composer`. It can be used to
install packages with `composer require`:

```
$ composer require friendsofphp/php-cs-fixer
Using version ^1.12 for friendsofphp/php-cs-fixer
./composer.json has been created
Loading composer repositories with package information
Updating dependencies (including require-dev)
  - Installing sebastian/diff (1.4.1)
    Downloading: 100%

  - Installing symfony/stopwatch (v3.1.6)
    Loading from cache
[...]
  - Installing friendsofphp/php-cs-fixer (v1.12.3)
    Downloading: 100%

Writing lock file
Generating autoload files
```

It installs the software and it's dependencies into the subfolder `vendor`. It also
generates a `composer.json` and a `composer.lock` file.

To install packages globally use global:

```
$ composer global require friendsofphp/php-cs-fixer
```

To use the packages in you php script you only need to
require one file: `autoload.php`. Then you can start using
the classes loaded from the packages:

```
require __DIR__ . '/vendor/autoload.php';

$log = new Monolog\Logger('name');
```

When using git with a php project you add `composer.json` and `composer.lock` to the repository, and `vendor` to `.gitignore`.

A word of warning: there are two older levels of dependencies:

- PECL [https://pecl.php.net/](https://pecl.php.net/) is a library of PHP extentions, that need to be compiled and linked to the php interpreter.
- PEAR [https://pear.php.net/](https://pear.php.net/) was the former package manager for php packages, see also [Fabien Potencier article: The rise of Composer and the fall of PEAR](http://fabien.potencier.org/the-rise-of-composer-and-the-fall-of-pear.html)

## References

- Package management for the operating system:
  - `apt` for Linux, e.g. for [Ubuntu](https://help.ubuntu.com/lts/serverguide/apt.html) and [Debian](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html)
  - `brew` for mac os [brew.sh](http://brew.sh/)
  - `choco` for windows [chocolatey.org](https://chocolatey.org/)
- Package management for a programming language:
  - `gem` and `bundler` for ruby [rubygems.org](http://guides.rubygems.org/rubygems-basics/) and [bundler.io](http://bundler.io/)
  - `npm` for javascript and node.js [npmjs.org](https://www.npmjs.com/)
  - `composer` for php [getcomposer.org](https://getcomposer.org/) and [packagist.org](https://packagist.org/)
