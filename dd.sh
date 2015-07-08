#!/bin/bash

ACTION=$1;

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


# exports
_ export ANSIBLE_INVENTORY=$PWD/ansible_hosts
notify "Ansible Inventory: $ANSIBLE_INVENTORY";

_ export ANSIBLE_CONFIG=$PWD/ansible.cfg
notify "Ansible Config: $ANSIBLE_CONFIG";

if [ -d "./ansible" ]; then
    _ export ANSIBLE_HOME=`pwd`/ansible;
    _ export PATH=$ANSIBLE_HOME/bin:$PATH;
    notify "Ansible Home: $ANSIBLE_HOME";
    notify "Path: $PATH";
fi

# utility methods
basic_install() {
    # yes | rm -rf ./ansible;
    if [ "$(uname)" == "Darwin" ]; then
        if ! type "brew" > /dev/null; then 
            notify "Revoking sudo access."
            _ sudo -k 
            notify "Homebrew isn't installed. Attempting to install Homebrew."
            _ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            notify "Homebrew should have been installed. Please run this script again with sudo access."
        fi
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under Linux platform
        if ! type "yum" > /dev/null; then 
            notify "You're not running this on a Redhat/Centos system."
            notify "This script only supports Mac or Redhat/Centos at the moment."
            exit;
        fi
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under Windows NT platform
        notify "This script only supports Mac or Redhat/Centos at the moment."
        exit;
    fi

}

install() {
    if [ "$(uname)" == "Darwin" ]; then
        _ brew install git
        _ easy_install pip
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under Linux platform
        _ yum install -y git vim
        _ easy_install pip
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under Windows NT platform
        notify "> This script only supports Mac or Redhat/Centos at the moment."
        exit;
    fi
}

setup_ssh() {
    if [ "$(uname)" == "Darwin" ]; then
        export user_home="$HOME";
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        export user_home="/root";  
    fi
    
    if [ ! -d "$user_home/.ssh" ]; then
        _ mkdir $user_home/.ssh;
    fi

    if [ ! -f "$user_home/.ssh/id_rsa.pub" ]; then
        _ cd $user_home/.ssh;
        _ ssh-keygen -t rsa -f id_rsa -P '';
    fi

    if [ ! -f "$user_home/.ssh/authorized_keys" ]; then 
        _ cat $user_home/.ssh/id_rsa.pub > $user_home/.ssh/authorized_keys;
    fi
}

# pre-launch checks
runchecks() {
    # if [ "$EUID" -ne 0 ]; then
    #     error "Please run as root."
    #     exit;
    # fi

    if ! type "git" > /dev/null; then
        error "You need to install GIT before continuing."
        return 0;
    fi

    if ! type "pip" > /dev/null; then
        error "You need to install PIP (python) before continuing."
        return 0;
    fi
}

if [ "$ACTION" == "setup" ]; then
    if [ "$EUID" -ne 0 ]; then
        error "You can run setup only as root user."
        exit -1;
    else 
        basic_install;
        if ! runchecks; then 
            install;
            if ! runchecks; then 
                error "Unable to proceed. Please check the errors listed above."
                exit -1;
            fi;
        fi
    fi
elif [ "$ACTION" == "install" ]; then

    if [ "$EUID" -ne 0 ]; then

        # install ansible
        _ git clone git://github.com/ansible/ansible.git --recursive
        _ cd ./ansible
        _ source ./hacking/env-setup
        _ sudo pip install 
        _ sudo pip install paramiko PyYAML Jinja2 httplib2 six 

        # setup ssh-keyless login
        notify "Setting up SSH for keyless login."
        setup_ssh;

        # test ansible
        notify "Testing if Ansible is installed properly..."
        if ansible all -m ping; then 
            notify "Installation was successful."
         else
            error "Installation Failed."
        fi
    else
        error "You can't call as a sudo-user but have the ability to go sudo."
        exit -1;
    fi
elif [ "$ACTION" == "configure" ]; then 

    _ cd $ANSIBLE_HOME;
    _ source ./hacking/env-setup


    if [ "$EUID" -ne 0 ]; then   
        # non sudo actions 
        if [ "$(uname)" == "Darwin" ]; then
            _ ansible-playbook -i "localhost," -c local ../playbooks/mac_playbook.yml;
            _ ansible-playbook -i "localhost," -c local ../playbooks/work_mac_playbook.yml;

        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            echo "No Non-Sudo Linux Tasks."
        fi
    else 

        # sudo actions
        if [ "$(uname)" == "Darwin" ]; then

            _ ansible-playbook -i "localhost," -c local ../playbooks/default.yml;

        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

            _ ansible-playbook -i "localhost," -c local ../playbooks/default.yml;
            _ ansible-playbook -i "localhost," -c local ../playbooks/linux_playbook.yml;
            _ ansible-playbook -i "localhost," -c local ../playbooks/work_linux_playbook.yml;

        fi
    fi
    # else
    #     error "You can't call as a sudo-user but have the ability to go sudo."
    #     exit -1;
    # fi

else
    error "Invalid action provided."
    echo "Usage: dd.sh (setup|install|configure)";
    echo "NOTE: dd.sh setup must be run as root."
    exit;
fi;


