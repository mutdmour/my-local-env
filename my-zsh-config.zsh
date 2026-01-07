#!/usr/bin/env zsh

CURRENT_DIR="$(dirname "$0")"

# Set up fzf key bindings and fuzzy completion
# https://github.com/junegunn/fzf
source <(fzf --zsh)

# Open VS Code in current repository 
alias c="code ."

alias yolo="claude --dangerously-skip-permissions"

source "$CURRENT_DIR/my-git-functions.zsh"

# todo add readme
# todo add rest of zsh config
# todo use ZSH_CUSTOM ?