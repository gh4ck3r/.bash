#!/bin/bash
# vim:set fdm=marker:

set -e
declare -a APT_PACKAGES=(#{{{
  ack-grep
  autoconf
  bison
  build-essential
  cscope
  curl
  exuberant-ctags
  flameshot
  flex
  fonts-font-awesome
  gawk
  git
  git-svn
  gnome-tweaks
  gperf
  jq
  libncurses5-dev
  libsecret-tools
  libtool-bin
  libxml2-utils
  net-tools
  qemu-kvm
  ripgrep
  sdcv
  silversearcher-ag
  subversion
  terminator
  tmux
  tree
  ubuntu-make
  vim
  wmctrl
  xclip
  xsltproc
); #}}}

sudo add-apt-repository -y ppa:lyzardking/ubuntu-make
sudo apt update
sudo apt install -y ${APT_PACKAGES[@]}

declare -a SNAP_PACKAGES=(
  wavebox
);
sudo snap install ${SNAP_PACKAGES[@]}

declare -a SNAP_CLASSIC_PACKAGES=(
);
#sudo snap install ${SNAP_CLASSIC_PACKAGES[@]} --classic

git submodule init && git submodule update

if ! type fzf 2>&- >/dev/null;then
  declare fzf_installer=$(dirname $BASH_SOURCE)/fzf/install;
  if [[ -x $fzf_installer ]]; then
    echo 'Install fzf'
    declare fzf_install_param='--all --no-update-rc'
    type zsh 2>&- >/dev/null  || fzf_install_param+=' --no-zsh'
    type fish 2>&- >/dev/null || fzf_install_param+=' --no-fish'
    $fzf_installer $fzf_install_param
  else
    echo "no installer: $fzf_installer $BASH_SOURCE"
  fi
fi

if ! which fd; then
  pkg=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest \
    | jq -r '.assets[].browser_download_url | select(contains("musl") | not) | select(endswith("amd64.deb"))')
  curl -LJO $pkg
  sudo dpkg -i $(basename $pkg)
  rm -f $(basename $pkg)
fi

if ! fc-list | grep Hack; then
  pkg=$(curl -s https://api.github.com/repos/source-foundry/Hack/releases/latest \
    | jq -r '.assets[].browser_download_url | select(endswith("ttf.tar.gz"))' \
    | head -n1)
  set -e
  mkdir -p ~/.local/share/fonts
  pushd ~/.local/share/fonts
  curl -LJ $pkg | tar zxv --strip 1 --wildcards ttf/*.ttf
  popd

  mkdir -p ~/.config/fontconfig/conf.d
  cat > ~/.config/fontconfig/conf.d/45-Hack.conf <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Declare Hack a monospace font -->
  <alias>
    <family>Hack</family>
    <default><family>monospace</family></default>
  </alias>
  <!-- if this file is put in user’s configuration, unset sans-serif family -->
  <match>
    <test compare="eq" name="family">
        <string>sans-serif</string>
    </test>
    <test compare="eq" name="family">
        <string>Hack</string>
    </test>
    <edit mode="delete" name="family"/>
  </match>
</fontconfig>
EOF
  set +e

  fc-cache -fv
fi

declare -A UMAKE_PACKAGES=(
  [web]=firefox-dev
)
for cmd in ${!UMAKE_PACKAGES[@]};do
  for pkg in ${UMAKE_PACKAGES[$cmd]};do
    [[ -d $HOME/.local/share/umake/$cmd/$pkg ]] || umake $cmd $pkg
  done
done

################################################################################
# {{{Perform close window with search key which used to be on top of Logitech mice
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

# }}}
################################################################################

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. ~/.bashrc
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cargo install alacritty bat

function installDelta()
{
  local URL=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r ".assets[] | select(.name | contains(\"git-delta_\") and endswith(\"_amd64.deb\")) | .browser_download_url");
  curl -OL $URL && sudo dpkg -i $(basename $URL);
  rm -f $(basename $URL)
}
installDelta
