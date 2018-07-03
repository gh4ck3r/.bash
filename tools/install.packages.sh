#!/bin/bash

PACKAGES=(
  ack-grep
  autoconf
  bison
  curl
  cscope
  exuberant-ctags
  flex
  fonts-font-awesome
  git
  git-svn
  gnome-tweaks
  gperf
  libncurses5-dev
  libsecret-tools
  libtool-bin
  net-tools
  qemu-kvm
  silversearcher-ag
  subversion
  terminator
  tree
  ubuntu-make
  vim
  wmctrl
  xclip
);

sudo apt install ${PACKAGES[@]}

declare -A UMAKE_PACKAGES=(
  [web]=firefox-dev
)
for cmd in ${!UMAKE_PACKAGES[@]};do
  for pkg in ${UMAKE_PACKAGES[$cmd]};do
    [[ -d $HOME/.local/share/umake/$cmd/$pkg ]] || umake $cmd $pkg
  done
done

################################################################################
# Perform close window with search key which used to be on top of Logitech mice
function isCustomCommandInstalled()
{
  local keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings);
  [[ $keybindings =~ ^\[.*]$ ]] || return 1;

  declare -a path=($(echo ${keybindings:1:-1} | tr -d ,))
  for p in ${path[@]};do
    local schema_path=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${p:1:-1}
    [[ $(gsettings get $schema_path name) == "'$1'" ]] && return 0
  done
  return 1
}

function installCustomCommand()
{
  local keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings);
  [[ $keybindings =~ ^\[.*]$ ]] || keybindings=[];

  declare -a path=($(echo ${keybindings:1:-1} | tr -d ,));

  local cmd_order=${#path[@]}
  path[$cmd_order]="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$cmd_order/'"

  function join() {
    local IFS="$1"; shift;echo "$*";
  }

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$(join , "[${path[@]}]")"

  local custom_command=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path[$cmd_order]:1:-1}
  gsettings set $custom_command name "$1"
  gsettings set $custom_command command "$2"
  gsettings set $custom_command binding "$3"
}

isCustomCommandInstalled 'Close window' ||
  installCustomCommand 'Close window' "wmctrl -c :ACTIVE:" Search

# Perform close window with search key which used to be on top of Logitech mice
################################################################################
