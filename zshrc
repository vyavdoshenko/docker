export ZSH="${HOME}/.oh-my-zsh"
export LANG=en_US.UTF-8
export TERM=xterm-256color
export CLICOLOR_FORCE=1


ZSH_THEME="robbyrussell"

CASE_SENSITIVE="true"

plugins=(git
         zsh-interactive-cd
         vi-mode
         alias-finder
         command-not-found
         extract
         fd
         ripgrep
         rust
         history-substring-search
         zsh-syntax-highlighting
         zsh-autosuggestions
         )

source ${ZSH}/oh-my-zsh.sh

export EDITOR='nvim'
export VIEWER='nvim'

alias zshconfig="${EDITOR} ~/.zshrc"
alias ohmyzsh="${EDITOR} ~/.oh-my-zsh"
alias vimconfig="${EDITOR} ~/.vim/vimrc"
