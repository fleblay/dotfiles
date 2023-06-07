#setxkbmap -layout us -option ctrl:nocaps
#xmodmap -e "keycode 9 = grave asciitilde"

alias ls="ls --color=auto"

set -o vi

#Make sure to get it first before sourcing it : https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/git-completion.bash
export PATH=$HOME/.brew/bin:$PATH
shopt -s globstar
