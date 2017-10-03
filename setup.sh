
PURPLE="\033[0;35m"
NC="\033[0m" # No Color

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

PYTHON_VERSION="3.6.2"

# preliminary setup
if [ -x "$(which pyenv)" ]; then
    notify "[OK]  - pyenv is installed."
else
    notify "[ERR] - pyenv is not installed. Setting it up..."
    _ curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
fi

export PATH="${HOME}/.pyenv/bin:${PATH}";
_ eval "$(pyenv init -)"
_ eval "$(pyenv virtualenv-init -)"
INSTALLED_PYTHON=$(python --version);
if [ "${INSTALLED_PYTHON}" == "Python ${PYTHON_VERSION}" ]; then
    notify "[OK]  - python==${PYTHON_VERSION} installed"
else
    notify "[ERR] - Using 'pyenv' to install Python ${PYTHON_VERSION}. Currently installed: |$(python --version)|"
    _ pyenv install 3.6.2
fi

_ pyenv rehash
_ pyenv local 3.6.2
_ pip install sultan
_ python setup.py
