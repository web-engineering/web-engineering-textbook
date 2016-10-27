Testing and Refactoring
=======================

This guide will explain why you should write automatic tests
for your web application. 
By referring to this guide, you will be able to:

* Understand testing terminology
* Write unit and integration tests for your application
* Know what test driven development is
* Know what refactoring is

---------------------------------------------------------------------------

Testing Software
----------------

There are two ways to test software:  have an actual person
use the software or have a program automatically test the software.

People who test software "by hand" often do this under the heading
"Quality Assurance" or "QA".  See [jobs in Salzburg](http://www.karriere.at/jobs/software-quality-assurance-tester/salzburg)  or [jobs in Berlin](http://de.indeed.com/Software-Quality-Assurance-Jobs-in-Berlin).

But even if you have a QA department for your project, as a developer
you still will write automated tests too.


### Why write automatic tests?

There are many reasons why you would want to write test for your program:

* when you first write the program: to know if the program works (as specified)
* to know if it still works after adding a new feature
* to know if it still works after refactoring the code
* to know if it still works after updating the dependencies


### Example test

This simple example in Javascript tests a function foo:

    describe('foo function', function() {
      
      it('converts number 1 correctly', function() {
        let input = { value: 1, language: english };
        assert.equal(foo(input), 'one');
      });

    });

The test framework gives you the possibility to group your
tests. In this example this is done with `describe` and `it`.

This test of the function `foo` consists of:

* a setup phase, where we prepare a data strucure we need later
* the calling of the function foo with the prepared input
* comparing the output of foo to the expected output

For the last step often the word `assert`  or Assertion is used.

### Types of Tests

As a beginner you should distinguish at least two types of tests:

* unit test - tests the function of one unit (be it a class, a package, one model, one view....)
* integration test - tests the whole program from the perspective of a user

Integration tests give you more valuable insights from a users
perspective, e.g.: "the shopping cart checkout does not work".
Unit tests help developers find the part of the program that is
responsible for a problem: "the cookie store class is broken".


Test Driven Development (TDD)
-------------------------------

### what is "test first" ?

1. write a test (it fails)
2. write the implementation (test still fails)
3. fix the implementation 
4. test passes: you're done!


### what is "TDD" ?

1. Q: what should the program do? 
2. A: integration test. (write it. it fails)
3. Q: how should the program do it?
4. A: unit test. (write it. it fails)
5. implement the unit 
6. does the unit test pass? if not, got back to 5
7. does the integration test pass? if not, go back to 3


Code Refactoring
------------------


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


