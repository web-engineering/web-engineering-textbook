Tools to keep your Code Clean
=======================

With this guide will get to know some tools
that will help you produce good code, and keep
the quality up.

* this
* that

---------------------------------------------------------------------------


Static Code Analysis
------------------

Any automatic analysis done on the **source code** of a program
is called **static** analysis.  The simplest form is a check
of coding conventions. This is called "linting". 


## Style Guide

A Style Guide or Coding Convention tells places
restrictions on the way you write your code: it tells
you how deep indentation should be, whether to put
spaces inside brackts, and so on.

You can invest a lot of emotional energy in this, and fight
with your co-workers over the details of formatting.  Or
you can just decide on a style guide to follow, and be done
with the discussions.

* [ruby style guide](https://github.com/bbatsov/ruby-style-guide)
* [airbnb style guide](https://github.com/airbnb/javascript)
* [javascript standard stlye](https://standardjs.com/)
* [PHP Standards Recommendations: PSR-2](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md)

## Linting 

To lint is to check if code follows a style guide.
Linting tools are available for all languages:

* [rubocop](https://github.com/bbatsov/rubocop)
* [ES Lint](http://eslint.org/)
* [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer)

You can incorporate linting into your editor, this
way you will never stray far from the style guide.

## Example Linter for Ruby: Rubocop

When you run `rubocop` it will examine all the files
in the current directory, and in subdirectories.

The rules that rubocop follows are called "cops". The default
rules are [documented here](https://github.com/bbatsov/rubocop/blob/master/config/enabled.yml).

You can configure rubocop by writing a file `.rubocop.yml` in your
projects root folder.

Run  `rubocop -d` to find out which rules the code is breaking.
You can disable rules for all files, you can exempt some files from
completely, or you can deactivate a rule just for a few lines of code:


```
# rubocop:disable Metrics/LineLength, Style/StringLiterals
# [... ugly code ...]
# rubocop:enable Metrics/LineLength, Style/StringLiterals
```

Best Practices
-----------

* [rails_best_pracices](https://github.com/railsbp/rails_best_practices)


Security
----------

* [brakeman](https://github.com/presidentbeef/brakeman)
