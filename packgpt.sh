#!/bin/bash
myname=$(whoami)
mypass='myPassword1234'
execute_as_sudo() {
    echo "$mypass" | sudo -S "$@"
}
system_update() {
    execute_as_sudo apt update -y
}
system_upgrade() {
    execute_as_sudo apt upgrade -y
}
install_nvidia() {
    execute_as_sudo apt update -y
    execute_as_sudo apt upgrade -y
    execute_as_sudo sed -i \
        -e 's#deb http://deb.debian.org/debian/ bookworm main#deb http://deb.debian.org/debian/ bookworm main non-free contrib#' \
        -e 's#deb-src http://deb.debian.org/debian/ bookworm main#deb-src http://deb.debian.org/debian/ bookworm main non-free contrib#' \
        -e 's#deb http://security.debian.org/debian-security bookworm-security main#deb http://security.debian.org/debian-security bookworm-security main non-free contrib#' \
        -e 's#deb-src http://security.debian.org/debian-security bookworm-security main#deb-src http://security.debian.org/debian-security bookworm-security main non-free contrib#' \
        -e 's#deb http://deb.debian.org/debian/ bookworm-updates main#deb http://deb.debian.org/debian/ bookworm-updates main non-free contrib#' \
        -e 's#deb-src http://deb.debian.org/debian/ bookworm-updates main#deb-src http://deb.debian.org/debian/ bookworm-updates main non-free contrib#' \
        /etc/apt/sources.list
    execute_as_sudo apt update -y
    execute_as_sudo apt install -y nvidia-detect
    execute_as_sudo nvidia-detect
    execute_as_sudo apt install -y nvidia-driver
    # execute_as_sudo systemctl reboot
    # Si probleme pendant installation nvidia, redémarrer votre serveur et éxecutez sudo dpkg --configure -a, puis relancer packgpt et install_nvidia, puis reboot du serveur.
}
install_packgpt() {
    execute_as_sudo apt install -y git tree htop nvtop locate chromium libtcmalloc-minimal4
    cd /home/$myname/ || exit
    git clone https://github.com/JeanSebastienBash/PackGPT.git
}
install_pinokio() {
    # START : shell-1 : pinokio
    local pathPinokio="$HOME/PackGPT/pinokio"
    mkdir -p $pathPinokio
    wget -P $pathPinokio "https://github.com/pinokiocomputer/pinokio/releases/download/1.0.16/Pinokio_1.0.16_amd64.deb"
    execute_as_sudo dpkg -i $pathPinokio/$(basename "https://github.com/pinokiocomputer/pinokio/releases/download/1.0.16/Pinokio_1.0.16_amd64.deb")
    execute_as_sudo apt-get install -y -f
    execute_as_sudo apt --fix-broken -y install
    execute_as_sudo apt install --reinstall -y libasound2
}
install_biniou() {
    # START : shell-1 : cd biniou ; ./webgui.sh
    # START : shell-2 : chromium https://0.0.0.0:7860
    local pathBiniou="$HOME/PackGPT/biniou"
    mkdir -p $pathBiniou
    execute_as_sudo apt install -y python3.11-venv build-essential python3-dev
    git clone https://github.com/Woolverine94/biniou.git $pathBiniou
    pushd $pathBiniou
    bash install.sh
    popd
}
install_final2x() {
    # START : shell-1 : final2x
    local pathFinal2x="$HOME/PackGPT/final2x"
    chmod 777 -Rv $pathFinal2x
    local final2xDebURL="https://github.com/Tohrusky/Final2x/releases/download/2024-01-02/Final2x-linux-pip-x64-deb.deb"
    mkdir -p $pathFinal2x
    wget -P $pathFinal2x $final2xDebURL
    execute_as_sudo dpkg -i $pathFinal2x/$(basename $final2xDebURL)
}
install_fooocus() {
    # START : shell-1 : cd foocus ; source fooocus_env/bin/activate ; python entry_with_update.py
    # START : shell-2 : chromium http://127.0.0.1:7865/
    local pathFooocus="$HOME/PackGPT/fooocus"
    mkdir -p $pathFooocus
    git clone https://github.com/lllyasviel/Fooocus.git $pathFooocus
    pushd $pathFooocus
    python3 -m venv fooocus_env
    source fooocus_env/bin/activate
    pip install -r requirements_versions.txt
    popd
}
install_gpt4all() {
    # START : shell-1 : ./gpt4all/bin/chat
    local pathGpt4all="$HOME/PackGPT/gpt4all"
    local gpt4allInstallerURL="https://github.com/nomic-ai/gpt4all/releases/download/v2.5.4/gpt4all-installer-linux-v2.5.4.run"
    mkdir -p $pathGpt4all
    wget -P $pathGpt4all $gpt4allInstallerURL
    execute_as_sudo apt install -y libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0
    chmod +x $pathGpt4all/gpt4all-installer-linux-v2.5.4.run
    $pathGpt4all/gpt4all-installer-linux-v2.5.4.run
}
install_lmstudio() {
    # START : shell-1 : cd lmstudio ; ./LM+Studio-0.2.8-beta-v1.AppImage
    local pathLMStudio="$HOME/PackGPT/lmstudio"
    local lmStudioURL="https://s3.amazonaws.com/releases.lmstudio.ai/prerelease/LM+Studio-0.2.8-beta-v1.AppImage"
    mkdir -p $pathLMStudio
    wget -P $pathLMStudio $lmStudioURL
    execute_as_sudo apt install -y fuse
    # execute_as_sudo apt install -y modprobe fuse # if problem
    chmod +x $pathLMStudio/$(basename $lmStudioURL)
}
install_localgpt() {
    # START : shell-1 : cd localgpt ; source localgpt_env/bin/activate ; python run_localGPT_API.py
    # START : shell-2 : cd localgpt ; source localgpt_env/bin/activate ; cd localGPTUI/ ; python localGPTUI.py
    # START : shell-3 : chromium http://127.0.0.1:5111
    local pathLocalGPT="$HOME/PackGPT/localgpt"
    mkdir -p $pathLocalGPT
    git clone https://github.com/PromtEngineer/localGPT.git $pathLocalGPT
    pushd $pathLocalGPT
    execute_as_sudo apt install -y python3-wheel python3-venv python3-pip ninja-build nvidia-cuda-toolkit
    python3 -m venv localgpt_env
    source localgpt_env/bin/activate
    pip install -r requirements.txt
    export CUDA_HOME=/home/drp/PackGPT/localgpt/localgpt_env/lib/python3.11/site-packages/torch
    pip install wheel
    pip install llama-cpp-python
    pip install --use-pep517 auto-gptq==0.2.2
    popd
}
install_ollama() {
    # START : shell-1 : ollama
    local pathOllama="$HOME/PackGPT/ollama"
    mkdir -p $pathOllama
    execute_as_sudo apt install -y curl
    pushd $pathOllama
    execute_as_sudo curl https://ollama.ai/install.sh | sh
    popd
}
install_ollamagui() {
    # START : shell-1 : cd ollamagui ; python3 -m http.server --bind 127.0.0.1
    # START : shell-2 : chromium http://127.0.0.1:8000/
    local pathOllamaGui="$HOME/PackGPT/ollamagui"
    mkdir -p $pathOllamaGui
    pushd $pathOllamaGui
    git clone https://github.com/ollama-ui/ollama-ui .
    execute_as_sudo make
    popd
}
install_chatd() {
    # START : shell-1 : cd chatd/chatd-linux-x64 ; ./chatd
    local pathChatd="$HOME/PackGPT/chatd"
    local chatdZipURL="https://github.com/BruceMacD/chatd/releases/download/v1.0.1/chatd-linux-x64.zip"
    mkdir -p $pathChatd
    execute_as_sudo apt install -y unzip
    wget -P $pathChatd $chatdZipURL
    pushd $pathChatd
    unzip $(basename $chatdZipURL)
    chmod +x chatd-linux-x64/chatd
    popd
}

system_update
system_upgrade

#install_nvidia

#install_packgpt
#install_pinokio
#install_biniou
#install_final2x
#install_fooocus
#install_gpt4all
#install_lmstudio
#install_localgpt
#install_ollama
#install_ollamagui
#install_chatd
