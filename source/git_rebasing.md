Git Rebasing
=============

This Guide will elaborate on teamwork in git 
and using branches.

After reading this guide, you will know:

* Hot to rebase

----------------------------------------------------------------

What is a commit, what is a branch.
---------

Every commit is just a small change that
points to the commit before.

A branch is just a pointer to a certain commit.

If you create a branch called `a3` and add
a few commits W, X, Y, and Z to it, it might look like this:

![](images/git_branch.svg)

If you merge back into master now everything will be fine.

But what if the master moves on?  
Let's say three other commits are added to the master: B, C and D:


![](images/git_branches.svg)

If you merge this, the merge might get complicated.
A new Commit is created that contains all the necessary changes:

![](images/git_merge.svg)


But there's a better approach: First you rebase your branch onto the master:


```
git checkout a4
git rebase master
```

This will try to apply the new commits in a4 on top
of the current state of master, leading to this situation:

![](images/git_rebase.svg)

After the rebase a merge into master will be simple.

### Resources 

* [Git Book: Chapter 3.6](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
