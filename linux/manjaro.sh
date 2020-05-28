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
  log_yellow '\nInstalling packages from Gist downloaded file'

  while IFS=, read -r package; do
    log_green "\nInstalling $package"
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

  log_green '\nDownloading packages to install from Gist'
  curl https://gist.githubusercontent.com/danielccunha/f82506bb392503889d282442804483ba/raw/df55b0c5cecc5e18d437490354885595674bee54/manjaro-packages --output packages.txt
  install_packages

  cleanup
} || {
  cleanup
}