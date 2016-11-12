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
* or for short:
* change your code:
* but only how you do it,
* not what you do.


### refactoring and testing


* run the unit test (it should be green)
* refactor
* run the unit test (it should still be green)
* done


