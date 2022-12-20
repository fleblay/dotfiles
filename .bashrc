setxkbmap -layout us -option ctrl:nocaps

xmodmap -e "keycode 9 = grave asciitilde"
alias ls="ls --color=auto"

set -o vi

source ~/git-completion.bash
export PATH=$HOME/.brew/bin:$PATH
shopt -s globstar
