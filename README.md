# Requirements  
niri ( + wayland, swww, dunst, waypaper, swaylock, batsignal )  
quickshell, fuzzel  
foot, nvim, zsh ( + ohmyzsh, fzf )  
yazi( + telegram-send, imagemagick, wl-clipboard )  
zen-browser
  
# Installation  
1) Copy repository:
```bash
git clone https://github.com/justavahi/dotfiles
mv dotfiles/* .
```  
2) Install all yazi requirements:  
```bash
cd ~/.config/yazi
ya pkg install
```  
3) Install all neovim requirements:  
 3.1) open nvim  
 3.2) prompt ```:Lazy install```
4) Install all zsh requirements:  
```bash  
export ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}  
  
git clone https://github.com/zsh-users/zsh-autosuggestions         $ZSH_CUSTOM/plugins/zsh-autosuggestions  
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting  
git clone https://github.com/jeffreytse/zsh-vi-mode                $ZSH_CUSTOM/plugins/zsh-vi-mode  
git clone https://github.com/Aloxaf/fzf-tab                        $ZSH_CUSTOM/plugins/fzf-tab  
  
source ~/.zshrc
```
