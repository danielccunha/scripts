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

setup_code() {
    log_yellow '\nDownload VSCode files from gist'
    curl https://gist.githubusercontent.com/danielccunha/b58b4d6b6ead4458e494565c1d18e685/raw/e2ee8e151f7515a3eafb07899f5717fb9c64575b/extensions.txt --output extensions.txt
    curl https://gist.githubusercontent.com/danielccunha/b58b4d6b6ead4458e494565c1d18e685/raw/e2ee8e151f7515a3eafb07899f5717fb9c64575b/keybindings.json --output keybindings.json
    curl https://gist.githubusercontent.com/danielccunha/b58b4d6b6ead4458e494565c1d18e685/raw/e2ee8e151f7515a3eafb07899f5717fb9c64575b/settings.json --output settings.json

    # Get VSCode config directory
    readonly VSCODE_CONFIG=~/.config/Code/User
    echo $VSCODE_CONFIG
    
    log_yellow '\nSetting up VSCode settings and keybindings'
    cp settings.json $VSCODE_CONFIG 
    cp keybindings.json $VSCODE_CONFIG

    log_yellow '\nInstalling VSCode extensions'
    while read extension; do
	    code --install-extension $extension
    done < extensions.txt
}

setup_zsh() {
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
