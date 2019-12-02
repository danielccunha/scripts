# Setup git
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

# Setup flutter
setup_flutter() {
    # Configure flutter
    sudo groupadd flutterusers
    sudo gpasswd -a $USER flutterusers
    sudo chown -R :flutterusers /opt/flutter
    sudo chmod -R g+w /opt/flutter
    sudo newgrp flutterusers
}

# Setup JetBrains Toolbox
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

# Setup PostgreSQL
setup_postgresql() {
    # Configure PostgreSQL
    sudo su - postgres
    initdb --locale $LANG -D /var/lib/postgres/data
    exit
    sudo systemctl start postgresql
    sudo systemctl status postgresql
    sudo systemctl enable postgresql
}

# Merge Visual Studio Code json files (settings and keybindingss)
merge_vscode_files() {
    # Ensure destiny file exists
    touch $1

    # Copy destiny file and remove comments if there is any
    cp $1 curr.json
    strip-json-comments curr.json

    # Merge files into a temp file
    jq -s add curr.json $2 > temp.json

    # Copy created file to destiny
    cp temp.json $1

    # Remove created files
    rm temp.json curr.json
}

# Setup Visual Studio Code
setup_vscode() {
    # Install Visual Studio Code extensions
    while IFS= read -r extension; do
        code --install-extension $extension
    done < ../vscode/extensions.txt

    # Merge user settings with current file
    merge_vscode_files $HOME/.config/Code/User/settings.json ../vscode/settings.json
    merge_vscode_files $HOME/.config/Code/User/keybindings.json ../vscode/keybindings.json
}

# Setup NPM
setup_npm() {
    # Install default packages
    sudo npm install -g nodemon
    sudo npm install -g expo-cli
    sudo npm install -g strip-json-comments-cli
}

# Setup ZSH
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

    # Spaceship settings
    echo -e "\nSPACESHIP_PROMPT_ORDER=(
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    hg            # Mercurial section (hg_branch  + hg_status)
    exec_time     # Execution time
    line_sep      # Line break
    vi_mode       # Vi-mode indicator
    jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL=\"❯\"
SPACESHIP_CHAR_SUFFIX=\" \"" >> $HOME/.zshrc

    # Plugins
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
    zplugin light zdharma/fast-syntax-highlighting
    zplugin light zsh-users/zsh-autosuggestions
    zplugin light zsh-users/zsh-completions
}