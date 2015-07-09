                                                                         

# initialization                                                         
BLACK="\033[0;30m"    
DARK_GRAY="\033[1;30m"                                                   
BLUE="\033[0;34m"                                                        
LIGHT_BLUE="\033[1;34m"                                                  
GREEN="\033[0;32m"                                                       
LIGHT_GREEN="\033[1;32m"                                                 
CYAN="\033[0;36m"                                                        
LIGHT_CYAN="\033[1;36m"                                                  
RED="\033[0;31m"                                                         
LIGHT_RED="\033[1;31m"                                                   
PURPLE="\033[0;35m"                                                      
LIGHT_PURPLE="\033[1;35m"                                                
BROWN_ORANGE="\033[0;33m"                                                
YELLOW="\033[1;33m"                                                      
LIGHT_GRAY="\033[0;37m"                                                  
WHITE="\033[1;37m"                                                       
NC="\033[0m" # No Color                                                  

error() { echo -e "\n${RED}[ERROR]  $@ {NC}"; }                          
notify() { echo -e "\n${WHITE}[NOTIFY] $@${NC}"; }                       
_() { echo -e "\n${GREEN}\$ $@" ; "$@" ; echo -e "${NC}" ; }             

notify "Removing old '.dotfiles'...";
_ yes | rm -r ~/.dotfiles

notify "Cloning fresh copy of davydany/dotfiles to ~/.dotfiles...";
_ git clone https://github.com/davydany/dotfiles.git ~/.dotfiles
_ cd ~/.dotfiles

notify "Setting up proper permissions before running...";
_ chmod +x ./dd.sh

notify "Executing Pre-Install Setup...";
notify "You will need to enter your password for sudo access."
_ sudo ./dd.sh setup

notify "Executing Installation...";
_ ./dd.sh install

notify "Executing Configuration step WITH Root privileges...";
_ sudo ./dd.sh configure

notify "Executing Configuration step WITHOUT Root privileges...";
_ ./dd.sh configure

notify "Done."
