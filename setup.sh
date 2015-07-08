yes | rm -r ~/.dotfiles
git clone https://github.com/davydany/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x dd.sh

sudo dd.sh setup
dd.sh install
sudo dd.sh configure
dd.sh configure