#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

docker-cleanup() {
  docker rm -v $(docker ps -a -q -f status=exited)
  docker rmi $(docker images -q -f dangling=true)
}

_ssh_add() {
  [ "$SSH_CONNECTION" ] && return
  local key=$HOME/.ssh/id_rsa
  ssh-add -l >/dev/null || ssh-add $key
}

ssh() {
  _ssh_add
  command ssh "$@"
}

scp() {
  _ssh_add
  command scp "$@"
}

git() {
  case $1 in
    push|pull|fetch)
      _ssh_add
      ;;
  esac

  command git "$@"
}

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignorespace:ignoredups

# Store at most 5000 lines of history.
HISTSIZE=10000
unset HISTFILESIZE

# Append to the history file, don't overwrite it.
shopt -s histappend

PS1='\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] $(parse_git_branch)\n\$ '

eval "$(dircolors -b)"
alias grep='grep --color'
alias ll='ls -alFh'
alias info='info --vi-keys'

if which >/dev/null 2>&1 nvim
then
  alias vim=nvim
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
