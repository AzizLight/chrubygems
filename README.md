chrubygems
==========

This project contains `chruby` and `chgems` ported to the Fish shell.

Installation
------------

First, clone the repository in your home directory:

```
% cd
% git clone https://github.com/AzizLight/chrubygems.git $HOME/.chrubygems
```

Next, source the `init` script from you `config.fish` file:

```
. $HOME/.chrubygems/init.fish
```

*NOTE: You can put the `chrubygems` directory wherever you want.*

Global gems
-----------

It is possible to have "global" gems. Those gems will be installed automatically by `chgems` in each new project. You need to create a file with names of gems to install (one per line), and tell `chgems` where that file is by adding the path to the file to the `CHGEMS_GLOBAL_GEMS` environment variable.

There is an example file in this repository, called [`chgems_global_gems.example`](https://github.com/AzizLight/chrubygems/blob/master/chgems_global_gems.example). You can copy it anywhere you want and store it location in the environment variable. For example, copy the file to your home directory:

```
% cp $CHRUBYGEMS_DIR/chgems_global_gems.example $HOME/.chgems_global_gems
```

And then add the following line to you Fish config file (`config.fish`):

```
set -gx CHGEMS_GLOBAL_GEMS "$HOME/.chgems_global_gems"
```

Now everytime you run `chgems`, it will install the global gems (unless they are already installed).

*NOTE: The name of the global gems list file is not important.*

Credits
-------

- [Postmodern](https://github.com/postmodern): Created `chruby` and `chgems`
- [Jean Mertz](https://github.com/JeanMertz): Ported `chruby` to the Fish shell
- [Aziz Light](https://github.com/AzizLight): Ported `chgems` to the Fish shell
