#!/bin/bash

oh_my_zsh=$HOME/.oh-my-zsh
name=`whoami`

msg() {
    printf "%b\n" "$1" >&2
}

oh_my_zsh() {
    if [[ ! -e $oh_my_zsh ]]; then
        wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
        plugins_install
    else
        printf "have oh-my-zsh directory on you $HOME."
        printf "exit ..."
        exit
    fi
}

plugins_install() {
    if [ -d $oh_my_zsh/plugins ]; then

        if [ ! -e $oh_my_zsh/plugins/zsh-autosuggestions ]; then
            git clone git://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
        fi

        if [ ! -e $oh_my_zsh/custom/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi

    fi
}

config_link_files() {
    if [ -e ~/.zshrc ]; then
        sed -i "s/plugins=(git.*)/plugins=(zsh-autosuggestions zsh-syntax-highlighting git brew z nmap ruby rails)/g" ~/.zshrc
    fi
    add_plugins_config
    ln -s $HOME/dotfiles/ruby/.gemrc ~/
    ln -s $HOME/dotfiles/.gitconfig ~/
    ln -s $HOME/dotfiles/tmux/.tmux.conf ~/
}

add_plugins_config() {
        if [ ! -e $HOME/dotfiles/custom/$name.zsh ]; then
            echo "bindkey '^ ' autosuggest-accept" >> $HOME/.oh-my-zsh/custom/$name.zsh
            echo "alias vi=vim" >> $oh_my_zsh/custom/$name.zsh
            echo "#sources configuration{" >> $oh_my_zsh/custom/$name.zsh
            echo -e "\tsource ${HOME}/.rvm/scripts/rvm" >> $oh_my_zsh/custom/$name.zsh
            echo -e "\tsource $HOME/dotfiles/zsh/.aliases" >> $oh_my_zsh/custom/$name.zsh
            echo "#}" >> $oh_my_zsh/custom/$name.zsh
        fi
}

############################################################################################################## Main

oh_my_zsh

add_plugins_config
config_link_files
