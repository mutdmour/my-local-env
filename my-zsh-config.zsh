#!/usr/bin/env zsh

CURRENT_DIR="$(dirname "$0")"

source "$CURRENT_DIR/my-git-functions.zsh"

# Open VS Code in current repository 
alias c="code ."

alias yolo="claude --dangerously-skip-permissions"


# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export ZSH="$HOME/.oh-my-zsh"

# # Set name of the theme to load --- if set to "random", it will
# # load a random theme each time oh-my-zsh is loaded, in which case,
# # to know which specific one was loaded, run: echo $RANDOM_THEME
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# # zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# # zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 13

# # Set up fzf key bindings and fuzzy completion
# # https://github.com/junegunn/fzf
# source <(fzf --zsh)

# # Which plugins would you like to load?
# # Standard plugins can be found in $ZSH/plugins/
# # Custom plugins may be added to $ZSH_CUSTOM/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# #plugins=(git z kube-ps1)
# plugins=(git z) # todo enable kube-ps1 only for work env

# source $ZSH/oh-my-zsh.sh

# # ensure autocomplete works for zsh-z
# setopt COMPLETE_ALIASES