pwd=`pwd`

# setup bash
echo "Setting up 'bash'"
ln -sf $pwd/bash/bashrc ~/.bashrc
touch ~/.work.bashrc

# setup vim
echo "Setting up 'vim'"
yes | sudo pip install jedi
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

# setup pypi
echo "Setting up PyPI"
ln -sf $pwd/pypi/pypirc ~/.pypirc

# setup homebrew
echo "Setting up Homebrew"
if [ `uname` == "Darwin" ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# setup iterm2
ln -s $pwd/iterm2/inputrc ~/.inputrc

# setup git
ln -s $pwd/git/gitconfig ~/.gitconfig
