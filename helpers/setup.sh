setup_git() {
    # Check if git user isn't configured. If it's not, read user and e-mail and set it
    if [ -z "$(git config --global user.name)"  ]; then
	    # Configure git user
        read -p "git email: " email < /dev/tty
        read -p "git user:  " name < /dev/tty

        git config --global user.name "$name"
        git config --global user.email "$email"
    fi

    # Configure git aliases
    git config --global alias.st status
    git config --global alias.br branch
    git config --global alias.ck checkout
    git config --global alias.cm 'commit -m'
    git config --global alias.ps push
    git config --global alias.cf 'config --global --list'
    git config --global alias.ad 'add .'
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
}
