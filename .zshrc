autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

typeset -U path

export GIT_ROOT_BRANCH="main"

alias cl="clear"
alias gcm="git checkout "$GIT_ROOT_BRANCH""
alias gl="git pull"
alias current_branch="git rev-parse --abbrev-ref HEAD"

format_current_branch() {
    current_branch 2> /dev/null | sed "s/\(.*\)/[\1] /"
}

set_prompt() {
    PROMPT="%B%F{green}%1d $(format_current_branch)➤➤➤ %b%f"
}

precmd_functions+=(set_prompt)

# auto commit
acm() {
    git add .
    local message="$*"
    if [[ -z "$message" ]]; then
        message="auto commit"
    fi
    git commit -m "$message"
    git push
}

get_latest() {
    local curr=$(current_branch)
    gcm
    gl
    git checkout "$curr"
}

# allows for tab autocomplete with only local git branches
_git_checkout_local_completer() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local branches=$(git branch --list | sed 's/^\*//;s/^[ ]*//')

    COMPREPLY=($(compgen -W "${branches}" -- ${cur}))
}

complete -F _git_checkout_local_completer git checkout

purge_git_branches() {
    gcm
    git branch | grep -v "$GIT_ROOT_BRANCH" | xargs git branch -D
}

# if using zsh-autosuggestions, need to source it
# install with brew -> brew install zsh-autosuggestions
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
