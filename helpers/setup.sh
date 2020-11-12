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
    git config --global alias.cm '!git add . && git commit -m'
    git config --global alias.ps push
    git config --global alias.cf 'config --global --list'
    git config --global alias.ad 'add .'
    git config --global alias.un 'reset HEAD --'
    git config --global alias.lo 'log --oneline'
}

setup_jetbrains_toolbox() {
    # Download brazilian dictionaries if system isn't in brazilian portuguese
    if ! [ $LANG == 'pt_BR.UTF-8' ] && ! [ -d $HOME/Dictionaries ]; then
        git clone https://github.com/danielccunha/IntelliJ.Portuguese.Brazil.Dictionary.git
        cd IntelliJ.Portuguese.Brazil.Dictionary
        rm -rf doc/ README.md && cd ..
        mkdir Dictionaries && cd Dictionaries
        mkdir Portuguese && cd ..
        mv IntelliJ.Portuguese.Brazil.Dictionary/* Dictionaries/Portuguese/
        rm -rf IntelliJ.Portuguese.Brazil.Dictionary
        mv Dictionaries $HOME
    fi
}

setup_zsh() {
    log_yellow '\nSetting up ZSH'

    # New user settings
    zsh /usr/share/zsh/unctions/Newuser/zsh-newuser-install -f

    # Install oh my zsh
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    
    # Makes ZSH default shell
    sudo chsh -s $(which zsh)

    # Spaceship theme
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
}

setup_docker() {
    log_yellow 'Pulling common docker images'
    docker image pull node:14-alpine
    docker image pull mongo
    docker image pull postgres
}
