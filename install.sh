
# setup bash
ln -s bash/bashrc ~/.bashrc

# setup vim
ln -s vim/vimrc ~/.vimrc
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# setup zsh
if which zsh > /dev/null; then
	curl -L http://install.ohmyz.sh | sh
else
	echo "ZSH not installed. Not setting it up. Run this after setting up ZSH."
fi

