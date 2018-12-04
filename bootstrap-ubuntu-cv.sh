#!/bin/bash
#
# Bootstrap a new Debian/Ubuntu installation for Computer Vision.
#
#   One command to install all mandatory dependencies.
#

echo '** Updating'
sudo apt-get update && sudo apt-get upgrade -y

echo ''
echo '** Bootstrapping essentials'
sudo apt-get install -y curl direnv flake8 fortune git htop mosh openssl \
    openconnect silversearcher-ag snap tmux zsh

## Applications
echo 'Installing App: GitHub Desktop, Sublime Text, Syncthing, VLC'
wget https://github.com/shiftkey/desktop/releases/download/release-1.5.0-linux5/GitHubDesktop-linux-1.5.0-linux5.deb
sudo dpkg -i GitHubDesktop-linux-1.5.0-linux5.deb
sudo apt-get install -f -y
rm -f GitHubDesktop-linux-1.5.0-linux5.deb

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list

sudo apt-get update
sudo apt-get install sublime-text
sudo apt-get install syncthing
sudo systemctl enable syncthing@$USER.service
sudo systemctl start syncthing@$USER.service
sudo snap install vlc

## Oh-My-Zsh!
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# dot files
cp ./dotfiles/.direnvrc $HOME/.direnvrc
cp ./dotfiles/.zshrc $HOME/.zshrc

## tmux configuration
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# Fancy tmux with p key binded to past
echo 'set-option -g default-shell /bin/zsh' >> $HOME/.tmux/.tmux.conf.local
echo 'set -g history-limit 30000' >> $HOME/.tmux/.tmux.conf.local
echo 'set-option -g mouse on' >> $HOME/.tmux/.tmux.conf.local
echo 'setw -g alternate-screen on' >> $HOME/.tmux/.tmux.conf.local
echo 'bind ] run "tmux set-buffer \"$(xclip -o -sel clipboard)\" && tmux paste-buffer"' >> $HOME/.tmux/.tmux.conf.local

## Python3
sudo apt-get install python3-dev python3-pip virtualenv -y
pip3 install virtualenvwrapper

echo ''
echo '** Setting up the cv virtualenv'
mkdir ~/Sync
mkdir ~/Sync/GitHub
mkvirtualenv -p python3 cv
workon cv

## Basic Computer Vision - OpenCV with contrib >= 3.4.3
pip3 install camera-fusion

echo '** Done!'