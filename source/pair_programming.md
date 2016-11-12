Pair Programming
============

In this guide you will learn about a special form of teamwork
in programming: pair programming.

After reading this guide, you will:

* Know why you should try pair programming
* have a good starting point for your first try at pairing

-------------------------------------------------------------------

Pair Programming
----------------

In pair programming two programmers work together at one workstation. 
One, the driver, writes code while the other, the observer or navigator,
considers the "strategic" direction of the work, coming up with 
ideas for improvements and likely future problems to address.
The two programmers switch roles frequently.

* two developers, one computer
* a lot of talking. talk first!
* "driver" is typing
* "navigator" watches, thinks ahead, spots errors, keeps the big picture in mind
* take turns, switch around roles, after 20 minutes

### why pair?

* pairs are more productive than single developers (see Williams(2000))
* better quality of life through contact with other humans
* learn from each other
* part of agile methodologies, used today in industry

Pair Programming und git
------------------------

We want the log to show who worked as a pair

``` sh
$ git log
commit 38d4f10fe2fb3f4d13e12d75e70bc0a085f0753f
Author: Brigitte Jellinek + Xaviar Hyde <xhyde.lba@fh-salzburg.ac.at>
Date:   Fri Sep 14 10:52:41 2012 +0200
```

This follows the pattern:

``` sh
firstname lastname driver + firstname lastname navigator
e-mail address of the navigator
```


### git config

The configuration of git is saved on three levels:
For the repository you can find the configuration in the file `.git/config`.

You can set your own user-specific settings with the command line switch `--global`.
They will be saved to `~/.gitconfig`.  

And with the command line switch `--system` you can set global settings that
will be saved to `/etc/gitconfig`

This is what a `.git/config` file might look like:

``` 
[user]
    name = Brigitte Jellinek + Xaviar Hyde
    email = xhyde.lba@fh-salzburg.ac.at

[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
    ignorecase = true

[remote "origin"]
    url = ssh://repos.mediacube.at/opt/git/webpm/r1
    fetch = +refs/heads/*:refs/remotes/origin/*
```

