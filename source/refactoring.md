Refactoring
=======================

This guide will explain how you can use refactoring 
to improve your code.
By referring to this guide, you will be able to:

* Understand how refactoring is different from changing code
* Know important code smells
* Know important refactorings
* Be able to refactor your code in ruby and javascript

---------------------------------------------------------------------------

Code Refactoring
------------------

As beginners, programmer often do a lot of things at once:
when they edit a file to implement a new feature, they will also
fix some problems at the same time and change the formatting of the
code.

Becoming a better programmer entails slowing down and untangeling this:
you stick to doing one thing at a time.  First fix this problem, test
if it acutally worked.  Then add the new feature, test if that actually
worked.  Then improve the code to be more easily readable, test if everything
still works.

When you are using git, you will do a commit for every single step
mentioned above.



### what is "code refactoring" ?

* "restructuring an existing body of code
* altering its internal structure
* without changing its external behavior"


or for short:

* change your code:
* but only **how** you do it,
* not **what** you do.


### Refactoring and Testing

Refactoring and Testing go hand in hand: having tests
gives you the assurance that you are not breaking things when
you are refactoring the code:


* run the test (it should be green)
* refactor
* run the test (it should still be green)
* done

### Code Smells

So what should you refactor?  You can look for "code smells" - common patterns
of "bad" code. In their Refactoring book, Fowler, Beck, Brant, Opdyke and Roberts give a list of such code smells. 


#### Simple Examples

The first code smell is **duplicated code**. "If you see the same code
structure in more than one place, you can be sure that your program will be better
if you find a way to unify them."

Some other code smells that are kind of selfexplanatory:

* Long Method
* Large Class
* Long Parameter List


#### Comments

Another intresting code smell is "comments".  This is not meant to imply that
comments are bad, but rather that a code area that needs a lot of comments
is probably in need of refactoring.

An easy way to get rid of comments is to extract a method with
a good name:

```
# output the header
puts "<head>"
puts "  <meta charset='utf-8'>"
puts "</head>"
```

turns into:

```
output_the_header()
```

### Catalog of Refactorings

Chapters 7 to 12 of the Refactoring book give a long catalog of Refactorings.
The first Refactoring is **Extract Method**





