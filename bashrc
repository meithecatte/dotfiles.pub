export EDITOR=nvim
export GPG_TTY=$(tty)

function gc() {
    if [ $# = 0 ] ; then
        git commit
    else
        git commit -m "$@"
    fi
}

function gca() {
    if [ $# = 0 ] ; then
        git commit -a
    else
        git commit -am "$@"
    fi
}

alias gs="git status"
alias gco="git checkout"
alias gp="git push"
alias gpu="git pull"
alias ga="git add"
alias gd="git diff"
alias gg="git grep -n"
alias gb="git branch"
alias gr="git rebase"
alias vi="nvim"
alias lux="sudo tee /sys/class/backlight/intel_backlight/brightness <<<"

alias rebuild="sudo nixos-rebuild -I nixos-config=$HOME/.dotfiles/nixos/configuration.nix"
