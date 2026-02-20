export ZSH="$HOME/.oh-my-zsh"
export LS_COLORS="di=38;2;224;181;68"
ZSH_THEME="nicoulaj" # arrow bureau cypher fino-time gnzh half-life jnrowe linuxonly nicoulaj kardan

alias e='nvim'
alias rm='rm -rf'
alias sudo="doas"
alias niri="dbus-run-session niri"
alias reboot="doas reboot"
alias poweroff="doas poweroff"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
  zsh-vi-mode
  fzf-tab
)

source $ZSH/oh-my-zsh.sh
export MANPATH="/usr/local/man:$MANPATH"
