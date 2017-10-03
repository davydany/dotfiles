import logging
import os
import platform
from sultan.api import Sultan

PWD = os.path.dirname(os.path.abspath('__file__'))
HOME = os.path.expanduser('~')
DOTFILES_HOME = os.path.join(HOME, '.dotfiles')

def define_logger(name, level, handlers=None):

    logger = logging.getLogger(name)
    logger.setLevel(level)

    # configure a default handler if there is no default handler
    if handlers:
        for handler in handlers:
            handler.setLevel(level)
            logger.addHandler(handler)
    else:
        formatter = logging.Formatter('%(message)s')
        default_handler = logging.StreamHandler()
        default_handler.setFormatter(formatter)
        default_handler.setLevel(level)
        logger.addHandler(default_handler)
    return logger


logger = define_logger(None, logging.DEBUG)

def setup_symlinks():
    '''
    Sets up the symlinks for the different files.
    '''
    link_map = {
        'bash/bashrc': '.bashrc',
        'git/gitconfig': '.gitconfig',
        'pypi/pypirc': '.pypirc',
        'tmux/tmux.conf': '.tmux.conf',
        'vim/vimrc': '.vimrc',
        'zsh/zshrc': '.zshrc'
    }

    with Sultan.load() as s:

        for source_path, destination_path in link_map.items():

            abs_source_path = os.path.join(PWD, 'data', source_path)
            abs_destination_path = os.path.join(HOME, destination_path)
            logger.info("Setting up '%s'" % (source_path))
            logger.info("    - Source: %s" % abs_source_path)
            logger.info("    - Destination: %s" % abs_destination_path)

            if os.path.exists(abs_destination_path):
                logging.info("    - Skipping '%s' since it already exists." % abs_destination_path)
            else:
                response = s.ln('-s', abs_source_path, abs_destination_path).run()
                logging.debug('\n'.join(response.stdout))

def setup_vim():
    '''
    Sets up vim.
    '''
    logger.info("Setting up Vundle")

    with Sultan.load(cwd=HOME) as s:
        
        PATH_TO_VUNDLE_BUNDLE = os.path.join(HOME, '.vim', 'bundle', 'Vundle.vim')
        if not os.path.exists(PATH_TO_VUNDLE_BUNDLE):
            s.mkdir('-p', os.path.dirname(PATH_TO_VUNDLE_BUNDLE)).run()
            s.git('clone', 'https://github.com/VundleVim/Vundle.vim.git', PATH_TO_VUNDLE_BUNDLE).run()
            logger.warning("Please remember to run Vim, and run ':PluginInstall'")
        else:
            logger.info("Vundle is already setup.")

def setup_rvm():
    '''
    Sets up 'rvm'.
    '''
    logger.info("Setting up RVM")
    with Sultan.load(cwd=HOME) as s:
        
        RVM_PATH = os.path.join(HOME, '.rvm')
        if not os.path.exists(RVM_PATH):
            s.curl('-sSL', 'https://get.rvm.io').pipe().bash('-s', 'stable', '--ruby').run()
        else:
            logger.info("RVM already exists.")

def setup_jenv():
    '''
    Set up 'jenv'
    '''
    if platform.system() == 'Windows':
        logger.info("Run this manually for installing jenv: set-executionpolicy remotesigned")
        logger.info("Run this manually for installing jenv: (new-object Net.WebClient).DownloadString(\"http://get.jenv.io/GetJenv.ps1\") | iex")
    else:
        with Sultan.load(cwd=HOME) as s:
            s.curl('-L', '-s', 'get.jenv.io').pipe().bash().run()



def main():
    setup_symlinks()
    setup_vim()
    setup_rvm()
    setup_jenv()


if __name__ == "__main__":

    main()