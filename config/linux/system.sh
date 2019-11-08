#!/bin/bash

## Creates a temporary folder for created and/or downloaded files
mkdir temp
cd temp

# Clean up created and/or downloaded files
cleanup() {
  cd ../
  rm -rf temp
}

# Install and configure yay
install_yay() {
    if pacman -Qs yay > /dev/null; then
        echo 'yay is already installed'
    else
        pacman -S yay
        yay -Syyu
    fi
}

# Generic function for installing packages
install_packages() {
    for package in "$@"
    do
        if yay -Qs $package > /dev/null; then
            echo "$package is already installed"
        else
            yay -Sy $package --noconfirm
        fi
    done    
}

# Install and configure git
install_git() {
    if yay -Qs git > /dev/null; then
        echo "git is already installed"
    else
        yay -Sy git --noconfirm
    fi

    # Configure git user
    read -p "git username: " name
    read -p "git email: " email

    git config --global user.name "$name"
    git config --global user.email "$email"

    # Configure git aliases
    git config --global alias.st status
    git config --global alias.br branch
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
}

# Install and configure flutter
install_and_configure_flutter() {
    if yay -Qs flutter > /dev/null; then
        echo "flutter is already installed"
    else
        yay -Sy flutter --noconfirm

        # Configure flutter
        sudo groupadd flutterusers
        sudo gpasswd -a $USER flutterusers
        sudo chown -R :flutterusers /opt/flutter
        sudo chmod -R g+w /opt/flutter
        sudo newgrp flutterusers
    fi
}

# Merge JSON files
merge_json_files() {
    # Ensure destiny file exists
    touch $1

    # Merge files into a temp file
    jq -s add $1 $2 > temp.json

    # Remove current file and copy merged content to destiny
    rm $1
    cp temp.json $1 && rm temp.json
}

# Download Brazilian dictionaries for working with JetBrains IDEs
download_brazilian_dictionaries() {
    git clone https://github.com/danielccunha/IntelliJ.Portuguese.Brazil.Dictionary.git
    cd IntelliJ.Portuguese.Brazil.Dictionary
    rm -rf doc/ README.md && cd ..
    mkdir Brazilian\ Dictionaries
    mv IntelliJ.Portuguese.Brazil.Dictionary/* Brazilian\ Dictionaries/
    rm -rf IntelliJ.Portuguese.Brazil.Dictionary
    mv Brazilian\ Dictionaries $HOME
}

# Install VSCode extensions and set up user settings
configure_vscode() {
    if yay -Qs visual-studio-code-bin > /dev/null; then
        while IFS= read -r extension; do
            code --install-extension $extension
        done < ../vscode/extensions.txt

        {
            # Configure user settigs
            merge_json_files $HOME/.config/Code/User/settings.json ../vscode/settings.json

            # Configure keybindings
            merge_json_files $HOME/.config/Code/User/keybindings.json ../vscode/keybindings.json    
        } || {
            echo 'There was an error setting up Visual Studio Code settings and keybinds';
        }
    fi        
}

{
    install_yay
    install_git
    install_packages brave google-chrome visual-studio-code-bin nodejs yarn python dart gitkraken spotify sublime-text-3-imfix discord postman jetbrains-toolbox redshift flameshot dotnet-sdk-bin dotnet-runtime-bin dotnet-host-bin aspnet-runtime aspnet-runtime-bin jq
    install_and_configure_flutter
    download_brazilian_dictionaries
    configure_vscode
    cleanup
} || {
    cleanup
}
