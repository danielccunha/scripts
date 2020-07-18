#!/bin/bash

# Import logging and setup functions 
source ../helpers/logging.sh
source ../helpers/setup.sh

# Create a temporary folder for download/created files
mkdir temp
cd temp

# Helper function to clean up after execution
cleanup() {
  cd ..
  rm -rf temp
}

# Install packages from Gist downloaded file
install_packages() {
  while IFS=, read -r package; do
    log_yellow "\nInstalling $package"
    yay -Sy $package --noconfirm
  done < packages.txt
}

{
  log_green 'Updating system packages'
  sudo pacman -Syyu

  log_green '\nInstalling yay'
  sudo pacman -S yay

  log_green '\nSetting up git'
  yay -S git
  setup_git

  log_green '\nInstalling packages from gist'
  curl https://gist.githubusercontent.com/danielccunha/f82506bb392503889d282442804483ba/raw/df55b0c5cecc5e18d437490354885595674bee54/manjaro-packages --output packages.txt
  install_packages

  log_green '\nCreating default directories'
  mkdir ~/Projects ~/Studies

  log_green '\nSetting up installed packages'
  setup_jetbrains_toolbox
  setup_docker
  setup_zsh

  cleanup
} || {
  cleanup
}
