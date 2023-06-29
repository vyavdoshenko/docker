export ZSH="${HOME}/.oh-my-zsh"
export LANG=en_US.UTF-8
export CLICOLOR_FORCE=1

ZSH_THEME="simple"

CASE_SENSITIVE="true"

plugins=(git
         zsh-interactive-cd
         vi-mode
         alias-finder
         command-not-found
         extract
         fd
         ripgrep
         history-substring-search
         zsh-syntax-highlighting
         zsh-autosuggestions
         )

source ${ZSH}/oh-my-zsh.sh

export EDITOR='nvim'
export VIEWER='nvim'

source ${HOME}/veego/env
