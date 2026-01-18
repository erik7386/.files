
setopt autocd

alias l="ls -FGl"
alias ll="ls -AFGl"
alias lll="ls -aFGl"
alias g="$(which git)"
alias .files="$(which git) --git-dir=${HOME}/.local/share/dotfiles/.files.git/ --work-tree=${HOME}"
alias v="$(which nvim)"
#alias vk="NVIM_APPNAME=nvim-kickstart $(which nvim)"
#alias vkm="NVIM_APPNAME=nvim-kickstart-modular $(which nvim)"

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
source <(fzf --zsh)

autoload -Uz compinit && compinit

eval "$(starship init zsh)"
