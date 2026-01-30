#!/bin/bash

[[ -x $(which gpg) ]] || return

grep --quiet --no-messages --fixed-string enable-ssh-support \
  ~/.gnupg/gpg-agent.conf || return

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
