echo "Removing old '.dotfiles'...";
yes | rm -r ~/.dotfiles

echo "Cloning fresh copy of davydany/dotfiles to ~/.dotfiles...";
git clone https://github.com/davydany/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

echo "Setting up proper permissions before running...";
chmod +x ./dd.sh

echo "Executing Pre-Install Setup...";
sudo ./dd.sh setup

echo "Executing Installation...";
./dd.sh install

echo "Executing Configuration step WITH Root privileges...";
sudo ./dd.sh configure

echo "Executing Configuration step WITHOUT Root privileges...";
./dd.sh configure

echo "Done."
