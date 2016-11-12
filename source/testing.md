Testing 
=======

This guide will explain why you should write automatic tests
for your web application. 
By referring to this guide, you will be able to:

* Understand testing terminology
* Write unit and integration tests for your application

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

There are many reasons why you would want to write tests for your program:

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

For the last step the word `assert` or assertion is often used.

Here is a longer example in ruby:

```ruby
    describe Customer do

      before do
        @movie_1 = Movie.new("Iron Man 3", Movie::NEW_RELEASE)
        @movie_2 = Movie.new("Avatar",     Movie::REGULAR)
        @movie_3 = Movie.new("Brave",      Movie::CHILDRENS)
        @customer = Customer.new("Vroni")
      end

      describe "customer statement" do
        it "is printed correctly for a new release movie" do
          # [...]
        end
        it "is summed up correctly for 3 movies" do
          @customer.add_rental(Rental.new(@movie_1, 2))
          @customer.add_rental(Rental.new(@movie_2, 3))
          @customer.add_rental(Rental.new(@movie_3, 4))
          @customer.statement.must_match /Amount owed is 12.5/
          @customer.statement.must_match /You earned 4 frequent renter points/
        end 
      end
    end
```

Here the setup phase has been extracted to a `before` block.
This is run before every test inside the same `describe` block. 
The means that the variable will be reset before each test,
if you change `@movie_1` in the first test this will not affect
the second test.

In this example a more complex assertion is used: `must_match` will
do a pattern match on the resulting string.

### Types of Tests

As a beginner you should distinguish at least two types of tests:

* unit test - tests one specific unit of code (be it a class, a package, one model, one view....)
* integration test - tests the whole program from the perspective of a user

Integration tests give you more valuable insights from a users
perspective, e.g.: "the shopping cart checkout does not work".
Unit tests help developers find the part of the program that is
responsible for a problem: "the cookie store class breaks if you store an undefined value".



