#!/usr/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"

#variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
user=$(whoami)

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Exiting...\n${endColour}"
    exit 1
}


if [ "$user" == "root" ]; then
    echo -e "\n\n${redColour}[!] No deberias correr el script como root!\n${endColour}"
    exit 1
else
    sleep 1
    echo -e "\n\n${yellowColour}[*] Instalando paquetes necesarios para el entorno...\n${endColour}"
    sleep 2
    sudo apt install -y kitty rofi feh xclip ranger i3lock-fancy scrot scrub wmname imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf lsd bat pamixer flameshot
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar algunos paquetes!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${yellowColour}[*] Instalando dependencias necesarias para el entorno...\n${endColour}"
    sleep 0.5
    
    echo -e "\n${blueColour}[*] Instalando dependecias para el bspwm...\n${endColour}"
    sleep 2
    sudo apt install -y build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1-dev
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar algunas dependencias para bspwm!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${blueColour}[*] Instalando dependencias para polybar...\n${endColour}"
    sleep 2
    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar dependencias para polybar!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${blueColour}[*] Instalando dependencias para picom...\n${endColour}"
    sleep 2
    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar algunas dependencias para picom!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${yellowColour}[*] Iniciando instalación de herramientas...\n${endColour}"
    sleep 0.5
    mkdir ~/tools && cd ~/tools
    
    echo -e "\n${blueColour}[*] Instalando bspwm...\n${endColour}"
    sleep 2
    git clone https://github.com/baskerville/bspwm.git
    cd bspwm
    make -j$(nproc)
    sudo make install
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar bspwm!\n${endColour}"
        exit 1
    else
        sudo apt install bspwm -y
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    cd ..
    
    echo -e "\n${blueColour}[*] Instalando sxhkd...\n${endColour}"
    sleep 2
    git clone https://github.com/baskerville/sxhkd.git
    cd sxhkd
    make -j$(nproc)
    sudo make install
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar sxhkd!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    cd ..
    
    echo -e "\n${blueColour}[*] Instalando polybar...\n${endColour}"
    sleep 2
    git clone --recursive https://github.com/polybar/polybar
    cd polybar
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar polybar!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    cd ../../
    
    echo -e "\n${blueColour}[*] Instalando picom...\n${endColour}"
    sleep 2
    git clone https://github.com/ibhagwan/picom.git
    cd picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    sudo ninja -C build install
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar picom!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    cd ..
    
    echo -e "\n${blueColour}[*] Instalando Oh My Zsh y Powerlevel10k para el usuario $user...\n${endColour}"
    sleep 2
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar Oh My Zsh and Powerlevel10k para el usuario $user!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${blueColour}[*] Instalando Oh My Zsh and Powerlevel10k para el usuario root...\n${endColour}"
    sleep 2
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Fallo al instalar Oh My Zsh y Powerlevel10k para el usuario root!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] OK\n${endColour}"
        sleep 1.5
    fi
    
    echo -e "\n${yellowColour}[*] Iniciando configuracion de fuentes, wallpapers, dot file y scripts...\n${endColour}"
    sleep 0.5
    
    echo -e "\n${blueColour}[*] copiando fuentes...\n${endColour}"
    sleep 2
    if [[ -d "$fdir" ]]; then
        cp -rv $dir/fonts/* $fdir
    else
        mkdir -p $fdir
        cp -rv $dir/fonts/* $fdir
    fi
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Copiando wallpapers...\n${endColour}"
    sleep 2
    if [[ -d "~/Wallpapers" ]]; then
        cp -rv $dir/wallpapers/* ~/Wallpapers
    else
        mkdir ~/Wallpapers
        cp -rv $dir/wallpapers/* ~/Wallpapers
    fi
    wal -nqi ~/Wallpapers/wallpaper15.png
    sudo wal -nqi ~/Wallpapers/wallpaper15.png
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Copiando dot files...\n${endColour}"
    sleep 2
    cp -rv $dir/config/* ~/.config/
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Configurando archivos .zshrc and .p10k.zsh ...\n${endColour}"
    sleep 2
    cp -v $dir/.zshrc ~/.zshrc
    sudo ln -sfv ~/.zshrc /root/.zshrc
    cp -v $dir/.p10k.zsh ~/.p10k.zsh
    sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Configurando scripts...\n${endColour}"
    sleep 2
    sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
    mkdir ~/scripts
    mv -v $dir/scripts/random-wall.sh ~/scripts
    cp -rv $dir/scripts/*.sh ~/.config/polybar/cuts/scripts/
    touch ~/.config/polybar/cuts/scripts/target
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Configurando permisos necesarios y enlaces simbolicos...\n${endColour}"
    sleep 2
    chmod -R +x ~/.config/bspwm/
    chmod +x ~/.config/polybar/launch.sh
    chmod +x ~/.config/polybar/cuts/scripts/*
    chmod +x ~/scripts/random-wall.sh
    sudo chmod +x /usr/local/bin/whichSystem.py
    sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
    sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
    sudo mkdir -p /root/.config/polybar/cuts/scripts/
    sudo touch /root/.config/polybar/cuts/scripts/target
    sudo ln -sfv ~/.config/polybar/cuts/scripts/target /root/.config/polybar/cuts/scripts/target
    cd ..
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${blueColour}[*] Eliminando repositorios...\n${endColour}"
    sleep 2
    rm -rfv ~/tools
    rm -rfv $dir
    echo -e "\n${greenColour}[+] OK\n${endColour}"
    sleep 1.5
    
    echo -e "\n${greenColour}[+] Entorno configurado :D\n${endColour}"
    sleep 1.5
    
    while true; do
        echo -en "\n${yellowColour}[?] Es necesario reinciar el sistema. ¿Quieres reiniciar ahora?? ([y]/n) ${endColour}"
        read -r
        REPLY=${REPLY:-"y"}
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "\n\n${greenColour}[+] Reiniciando...\n${endColor}"
            sleep 1
            sudo reboot
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
            exit 0
        else
            echo -e "\n${redColour}[!] operacion no valida, Intenta nuevamente\n${endColour}"
        fi
    done
fi
