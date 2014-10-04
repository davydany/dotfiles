pwd=`pwd`

# setup bash
echo "Setting up 'bash'"
ln -sf $pwd/bash/bashrc ~/.bashrc

# setup vim
echo "Setting up 'vim'"
ln -sf $pwd/vim/vimrc ~/.vimrc
[ -d ~/.vim/bundle/Vundle.vim ] && rm -rf ~/.vim/bundle/Vundle.vim 
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1

# setup zsh
echo "Setting up 'zsh'"
if which zsh > /dev/null; then
    [ ! -d ~/.oh-my-zsh ] && rm -rf ~/.oh-my-zsh
	curl -L http://install.ohmyz.sh | sh
	rm ~/.zshrc
	ln -sf $pwd/zsh/zshrc ~/.zshrc
else
	echo "ZSH not installed. Not setting it up. Run this after setting up ZSH."
fi
