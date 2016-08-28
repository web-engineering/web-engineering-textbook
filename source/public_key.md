Public Key Cryptography
==========================

If you want to  use git, ssh or mail encryption you need
to understand how public key cryptography works.

After working through this guide you should be able to

* understand when to use a private and when to use  a public key
* generate a key pair for use in ssh and git

-------------------------------------------------------------

Public Key Authentication in SSH
---------------------

(See also [Railsbridge Installfest](http://installfest.railsbridge.org/installfest/create_an_ssh_key))


![public key login](images/public_key_crypto.svg)

* [learn about ssh](http://dougvitale.wordpress.com/2012/02/20/ssh-the-secure-shell/)
* if you have a public + private key pair
  * `id_rsa`
  * `id_rsa.pub`
* and your private key is on your local computer
  * stored in `~/.ssh/id_rsa`
* and your public key is on the server
  * stored in `~/.ssh/authorized_keys2`
* then ssh will let you log in without giving a password

![public key login](images/ssh_login_with_public_key.svg)


### authorized_keys2

```
ssh-rsa AAAAB3NzaC...2EAAAABI== alice@fh-salzburg.ac.at
ssh-rsa AAAAB8NzaC...DVj3R4Ww== bob@fh-salzburg.ac.at
```


