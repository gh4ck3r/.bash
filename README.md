.bash
=====

My own bashrc and other utility scripts

## Files & Directories

### .bashrc
Bootstrap of this bashrc link this as ~/.bashrc to install

### config/
Terminal configuration related files(e.g. dircolors)

### dotfiles/
Configuration files, starts with dot(.) at $HOME. Each files under this
directory are automatically linked while login as softlink. It shows an warning
if there's existing files while the linking.

### profile.d/
Settings for individual tools or environment. e.g. Android, alias, cscope, etc.

### tools/
Tools to be used by this .bash setting. Functionalities are used to be
implemented as function or aliases. But, sometimes it needs a standalone
executable. e.g. for using `daemonize` like tools.

### wrappers/
Wrappers for some kind of executables.
