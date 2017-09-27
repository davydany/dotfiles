import logging
import os
from sultan.api import Sultan

PWD = os.path.dirname(os.path.abspath('__file__'))
HOME = os.path.expanduser('~')

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

def main():
    setup_symlinks()

if __name__ == "__main__":

    main()