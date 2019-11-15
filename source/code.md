Tools to keep your Code Clean
=======================

With this guide will get to know some tools
that will help you produce good code, and keep
the quality up.

You will get to know tools for Ruby for

* linting
* best practices
* security

---------------------------------------------------------------------------


Static Code Analysis
------------------

Any automatic analysis done on the **source code** of a program
is called **static** analysis.  The simplest form is a check
of coding conventions. This is called "linting". 


## Coding Convention

A Style Guide or Coding Convention places
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

![rubocop in vscode](/images/rubocop-in-vscode.png)

## Example Linter for Ruby: Rubocop

When you run `rubocop` it will examine all the files
in the current directory, and in subdirectories.

The rules that rubocop follows are called "cops". The default
rules are [documented here](https://github.com/rubocop-hq/rubocop/blob/master/config/default.yml).

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

## Example Linter for JavaScript: ESLint

When you run `eslint` it will examine all the files
in the current directory, and in subdirectories.

The rules that eslint follows are configured
in an `.eslintrc.*` file or an `eslintConfig` field in a `package.json` file.

Especially important are parser options because eslint can be used
on different version of JavaScript and TypeScript. See [the documentation](https://eslint.org/docs/user-guide/configuring#specifying-parser-options).


You can also configure rule just for a few lines of code
by writing comments in your source code. The following example
was taken from [Jeff Lowreys article](https://hackernoon.com/eslint-configuration-comments-e6f274a16f96)


```
const getFinalContext = (context) => {
        /* eslint-disable-next-line no-unused-vars */
        const { calls, ...finalContext } = context;
        return finalContext;
    }
```

The above code does a destructuring assignment from a passed-in context parameter. The function is only interested in the rest assignment to finalContext, and “discards” the first assignment, calls. Jeff Lowrey  disables the rule that
would complain about having an unused variable `call` by using the comment `/* eslint-disable-next-line no-unused-vars */`. This only applies to the next code line, though, and the rule will remain in effect for the rest of the file.


Best Practices
-----------

For the framework Rails there exists a collection of "best pracices" - 
hints how to use the framworks.  They are doumented on [rails-bestpractices.com](https://rails-bestpractices.com/)

There is a command line tool that checks your Rails projects against
these best pracices and can also fix some of the problems:

* [rails_best_pracices](https://github.com/railsbp/rails_best_practices)


Security
----------

Brakeman is a static analysis tool that specializes in security
problems for Ruby on Rails.  Use it on your rails project to find and fix security problems:

* [brakeman](https://github.com/presidentbeef/brakeman)


For JavaScript there are some ESLint rules you can install for
checking for security problems:

* [eslint-config-scanjs](https://github.com/mozfreddyb/eslint-config-scanjs)
* [eslint-plugin-security](https://github.com/nodesecurity/eslint-plugin-security) for node.js


