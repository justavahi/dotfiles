# Requirements  
git stow  
niri ( + wayland, swww, swaylock, batsignal, brightnessctl, zzz )  
quickshell, fuzzel  
foot, nvim, zsh ( + ohmyzsh, curl, fzf )  
yazi( + ImageMagick, wl-clipboard )  
zen-browser
  
# Install dependings
1) Install dependings(xbps):
```bash
sudo xbps-install -S git stow
sudo xbps-install -S niri wayland swww swaylock batsignal brightnessctl zzz
sudo xbps-install -S quickshell fuzzel
sudo xbps-install -S foot neovim zsh curl fzf
sudo xbps-install -S yazi ImageMagick wl-clipboard
```
2) Install ohmyzsh:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
3) Install flatpak:
```bash
sudo xbps-install -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
4) Install zen-browser:
Install
```bash
flatpak install flathub app.zen_browser.zen # Install
```
Run
```bash
flatpak run app.zen_browser.zen # Run
```
  
# Installation  
1) Copy repository:
```bash
git clone https://github.com/prilter/dotfiles
cd dotfiles
stow .
```
2) doas configuration:  
  2.1) edit doas.conf(set username)  
  2.2) copy files  
```bash
sudo cp ignorepkgs.conf /etc/xbps.d/ignorepkgs.conf
sudo cp doas.conf /etc/doas.conf
```  
  2.3) remove sudo
```bash
doas xbps-remove -R sudo
```  
4) Install all neovim requirements:  
```bash
nvim
```
5) Install all zsh requirements:  
```bash  
export ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}  
  
git clone https://github.com/zsh-users/zsh-autosuggestions         $ZSH_CUSTOM/plugins/zsh-autosuggestions  
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting  
git clone https://github.com/jeffreytse/zsh-vi-mode                $ZSH_CUSTOM/plugins/zsh-vi-mode  
git clone https://github.com/Aloxaf/fzf-tab                        $ZSH_CUSTOM/plugins/fzf-tab  
  
source ~/.zshrc
```
