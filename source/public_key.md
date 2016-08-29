Public Key Cryptography
==========================

If you want to  use git, ssh or mail encryption you need
to understand how public key cryptography works.

After working through this guide you should be able to

* understand when to use a private and when to use  a public key
* generate a key pair for use in ssh and git

-------------------------------------------------------------

Public Key Cryptography
---------------------

In the 1970ies several cryptographers invented public-key cryptography independently
of each other.  With the low computing power available then it could not be used in practice.
Since the 1990 it is used widely in ssh, e-mail encryption and SSL/TLS.

The basic idea is to have an assymetric encryption system: two different keys
are used:  a public key for encryption and a private key for decryption

![public key login](images/public_key_crypto.svg)


ssh
----

We will be using public key cryptography for ssh and git.  For these
systems the keys are stored in a folder **.ssh**.

you have a public + private key pair

* `id_rsa` - your private key is stored on your local computer in `~/.ssh/id_rsa`
* `id_rsa.pub` - your public key is also stored on your local computer in `~/.ssh/id_rsa`

But how do you get those keys?

### Generating keys 

Decide which e-mail address you want to use - this address
will be your identity as a developer from now on.  (so maybe don't use
a really private one)

Type this in the terminal (with your own e-mail address:)

```
ssh-keygen -C exampleme@example.com -t rsa
```

Press enter to accept the default key save location.
Do not use a passphrase.

After key generation is complete, you'll have output that looks like this:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/student/.ssh/id_rsa):
Created directory '/Users/student/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/student/.ssh/id_rsa.
Your public key has been saved in /Users/student/.ssh/id_rsa.pub.
The key fingerprint is:
88:54:ab:11:fe:5a:c3:7s:14:37:28:8c:1d:ef:2a:8d exampleme@example.com
```


Now check if your two keys are really stored in `~/.ssh/id_rsa` and ` ~/.ssh/id_rsa.pub`!

### Using keys with ssh

If you want to use these keys for logging in to a server without
using a password, you have to copy over your public key to the server.

On the server your public key must be stored in `~/.ssh/authorized_keys2`,
then ssh will let you log in without giving a password

![public key login](images/ssh_login_with_public_key.svg)

The authorized_keys file can contain several public keys:

```
ssh-rsa AAAAB3NzaC...2EAAAABI== alice@fh-salzburg.ac.at
ssh-rsa AAAAB8NzaC...DVj3R4Ww== bob@fh-salzburg.ac.at
```


git 
-----------------

Git uses two different transport modes: http and ssh.

To upload (push) data to remote repository you should use ssh,
and this is where you need your key pair.

You need to tell your remote git repository about your
public key.  This works slightly differently for different servers:

### Useing keys with github

[Generate an account on github](https://github.com/join). Chose a username that is not embarassing (not now, and not in 3 years when you are a professional developer).  You can chose a synonym instead
of using your real name if you are not sure yet if you want to be identified on the interent.

Now you can [add your public key to your github account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).


### Useing keys on gitlab

Under **Profile settings** &rarrow; **SSH Keys** you can add your public key.


### remember to use ssh!

When you clone a remote repository remember to use the address that starts with `git@`, not
an address that starts with `http` !





See Also
------
* [creating an ssh key](http://installfest.railsbridge.org/installfest/create_an_ssh_key) as explained by railsbridge
* [learn about ssh](http://dougvitale.wordpress.com/2012/02/20/ssh-the-secure-shell/)
