#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -e ~/.bashrc_custom ]] && . ~/.bashrc_custom

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

gocol() {
  go doc "$@" | vim -Rnc "setf go" -
}

vagrant-ssh-options() {
  vagrant ssh-config | grep -vE '^$|^Host ' | awk -v ORS=' ' '{print "-o " $1 "=" $2}'
}

vagrant-scp() {
  scp $(vagrant-ssh-options) "$@"
}

docker-cleanup() {
  docker rm -v $(docker ps -a -q -f status=exited)
  docker rmi $(docker images -q -f dangling=true)
}

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignorespace:ignoredups

# Store at most 5000 lines of history.
HISTSIZE=10000
unset HISTFILESIZE

# Append to the history file, don't overwrite it.
shopt -s histappend

# Disable special handling of !
set +o histexpand

PS1="\n\[\e[3${PROMPT_COLOR:-2}m\]\u@\h \[\e[33m\]\w\[\e[0m\] \$(parse_git_branch)\n\\$ "

eval "$(dircolors -b)"
alias grep='grep --color'

alias info='info --vi-keys'
alias godeps="comm -2 -3 <(go list -f '{{join .Deps \"\n\"}}' | sort) <(go list std | sort)"

which >/dev/null 2>&1 nvim && alias vim=nvim
