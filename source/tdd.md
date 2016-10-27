Test Driven Development
=======================

This guide will explain why you should write your
tests before your code.
By referring to this guide, you will be able to:

* Understand what test driven development is

---------------------------------------------------------------------------


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


