#!/bin/bash

# Import post installs
source post_installs.sh

# Creates a temporary folder for created and/or downloaded files
mkdir temp
cd temp

# Clean up created and/or downloaded files
cleanup() {
  cd ../
  rm -rf temp
}

# Log a message with green foreground
log_green() {
    echo -e "\e[38;2;113;247;159m$1\e[0m"
}

# Log a message with green foreground
log_red() {
    echo -e "\e[38;2;237;37;78m$1\e[0m"
}

# Log a message with yellow foreground
log_yellow() {
    echo -e "\e[38;2;249;220;92m$1\e[0m"
}

# Install and configure yay
install_yay() {
    sudo pacman -Syyu
    sudo pacman -S yay
}

# Run post install from csv
run_post_install() {
    {
        echo -e "\nRunning post install for $1"
        $2
    } || {
        log_red "There was an error running post install for $1"
    }
}

# Install packages from packages.csv
install_packages() {
    while IFS=, read -r package post_install force; do
        # Ignore header
        if [ "$package" == 'PACKAGE' ]; then
            continue
        fi        

        # Start installation
        log_green "\nInstalling $package"
        
        {
            # Check if package isn't already installed
            if yay -Qs $package > /dev/null; then
                echo "$package is already installed"

                # Check if it should force post install (case when package comes with the system, like Git)
                if [ "$force" == '1' ]; then
                    run_post_install $package $post_install
                fi
            else
                # Install the package
                yay -Sy $package --noconfirm
                
                # Check if post install is empty
                if [ -z "$post_install" ]; then
                    continue
                fi                

                # Run post install for package
                run_post_install $package $post_install
            fi
        } || {
            log_red "Failed to install $package"
        }
    done < ../packages.csv
}

{
    # Guarantee yay is installed
    install_yay

    # Install packages from packages.csv
    install_packages

    # Remove downloaded and/or created files
    cleanup
} || {
    cleanup
}
