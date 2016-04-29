# enable color support of ls and also add handy aliases
type dircolors >/dev/null 2>&1 || return

function set_dircolors()
{
  config_file=$__bashrc_dir/config/.dircolors;
  [[ -r $config_file ]] || unset config_file
  eval "$(dircolors -b $config_file)"
}
set_dircolors
unset set_dircolors

alias ls='ls --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
