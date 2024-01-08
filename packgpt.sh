#!/bin/bash

passdebian='DebianUserPasswordHere'

execute_as_sudo() {
    echo "$passdebian" | sudo -S $@
}

install_system_packages() {
    execute_as_sudo apt update
    execute_as_sudo apt upgrade -y
    execute_as_sudo apt install -y curl git wget python3 python3-venv python3-pip links2 gcc perl make ffmpeg openssl locate htop tree lxde-core xorg xserver-xorg libgtk-3-0 libnotify4 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0 libnss3 libxss1 libasound2 libpulse0 libportaudio2 chromium snapd unzip bzip2 libncurses5-dev libffi-dev libreadline-dev libssl-dev libbz2-dev libsqlite3-dev tk-dev liblzma-dev libgoogle-perftools-dev google-perftools
}

install_pyenv() {
    local pyenvRoot="$HOME/.pyenv"
    if [ -d "$pyenvRoot" ]; then
        rm -rf "$pyenvRoot"
    fi
    curl https://pyenv.run | bash
    export PYENV_ROOT="$pyenvRoot"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}

install_biniou() {
    local pathBiniou="$HOME/packgpt/biniou"
    mkdir -p $pathBiniou
    git clone https://github.com/Woolverine94/biniou.git $pathBiniou
    pushd $pathBiniou
    bash install.sh
    popd
}

install_pinokio() {
    local pathPinokio="$HOME/packgpt/pinokio"
    local pinokioDebURL="https://github.com/pinokiocomputer/pinokio/releases/download/0.2.16/Pinokio_0.2.16_amd64.deb"
    mkdir -p $pathPinokio
    wget -P $pathPinokio $pinokioDebURL
    execute_as_sudo dpkg -i $pathPinokio/$(basename $pinokioDebURL)
}

install_buzz() {
    local pathBuzz="$HOME/packgpt/buzz"
    mkdir -p $pathBuzz
    execute_as_sudo apt-get install -y libportaudio2
    execute_as_sudo snap install buzz --classic
}

install_final2x() {
    local pathFinal2x="$HOME/packgpt/final2x"
    local final2xDebURL="https://github.com/Tohrusky/Final2x/releases/download/2024-01-02/Final2x-linux-pip-x64-deb.deb"
    mkdir -p $pathFinal2x
    wget -P $pathFinal2x $final2xDebURL
    execute_as_sudo dpkg -i $pathFinal2x/$(basename $final2xDebURL)
    execute_as_sudo apt --fix-broken install -y
}

install_fooocus() {
    local pathFooocus="$HOME/packgpt/fooocus"
    mkdir -p $pathFooocus
    git clone https://github.com/lllyasviel/Fooocus.git $pathFooocus
    pushd $pathFooocus
    python3 -m venv fooocus_env
    source fooocus_env/bin/activate
    pip install -r requirements_versions.txt
    popd
}

install_gpt4all() {
    local pathGpt4all="$HOME/packgpt/gpt4all"
    local gpt4allInstallerURL="https://github.com/nomic-ai/gpt4all/releases/download/v2.5.4/gpt4all-installer-linux-v2.5.4.run"
    mkdir -p $pathGpt4all
    wget -P $pathGpt4all $gpt4allInstallerURL
    execute_as_sudo apt install -y libxcb-icccm4 libxcb-image0
    chmod +x $pathGpt4all/gpt4all-installer-linux-v2.5.4.run
    execute_as_sudo $pathGpt4all/gpt4all-installer-linux-v2.5.4.run
}

install_lmstudio() {
    local pathLMStudio="$HOME/packgpt/lmstudio"
    local lmStudioURL="https://s3.amazonaws.com/releases.lmstudio.ai/prerelease/LM+Studio-0.2.8-beta-v1.AppImage"
    mkdir -p $pathLMStudio
    wget -P $pathLMStudio $lmStudioURL
    chmod +x $pathLMStudio/$(basename $lmStudioURL)
}

install_localGPT() {
    local pathLocalGPT="$HOME/packgpt/localGPT"
    mkdir -p $pathLocalGPT
    git clone https://github.com/PromtEngineer/localGPT.git $pathLocalGPT
    pushd $pathLocalGPT
    python3 -m venv localgpt_env
    source localgpt_env/bin/activate
    pip install -r requirements.txt
    popd
}

install_ollama() {
    local pathOllama="$HOME/packgpt/ollama"
    mkdir -p $pathOllama
    pushd $pathOllama
    execute_as_sudo curl https://ollama.ai/install.sh | sh
    popd
}

install_ollamagui() {
    local pathOllamaGui="$HOME/packgpt/ollamagui"
    mkdir -p $pathOllamaGui
    pushd $pathOllamaGui
    git clone https://github.com/ollama-ui/ollama-ui .
    execute_as_sudo make
    popd
}

install_chatd() {
    local pathChatd="$HOME/packgpt/chatd"
    local chatdZipURL="https://github.com/BruceMacD/chatd/releases/download/v1.0.1/chatd-linux-x64.zip"
    mkdir -p $pathChatd
    wget -P $pathChatd $chatdZipURL
    pushd $pathChatd
    unzip $(basename $chatdZipURL)
    chmod +x chatd-linux-x64/chatd
    popd
}

install_privategpt() {
    local pathPrivateGPT="$HOME/packgpt/privategpt"
    export PATH="$HOME/.pyenv/bin:$PATH"
    mkdir -p $pathPrivateGPT
    git clone https://github.com/imartinez/privateGPT $pathPrivateGPT
    pushd $pathPrivateGPT
    execute_as_sudo apt install -y make gcc
    pyenv install 3.11
    pyenv local 3.11
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    poetry install --with ui
    poetry install --with local
    poetry run python scripts/setup
    popd
}

install_replay() {
    local pathReplay="$HOME/packgpt/replay"
    local replayDebURL="https://www.tryreplay.io/download?platform=linux"
    mkdir -p $pathReplay
    wget -P $pathReplay $replayDebURL
    execute_as_sudo dpkg -i $pathReplay/$(basename $replayDebURL)
}

install_rvcgui() {
    local pathRvcgui="$HOME/packgpt/rvcgui"
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    mkdir -p $pathRvcgui
    git clone https://github.com/Tiger14n/RVC-GUI.git $pathRvcgui || { echo "Cloning failed"; exit 1; }
    pushd $pathRvcgui
    pyenv install 3.10.6
    pyenv local 3.10.6
    python3 -m venv rvcgui_env
    source rvcgui_env/bin/activate
    pip install -U pip setuptools wheel
    pip install -U torch torchaudio
    pip install -r requirements.txt
    wget -P $pathRvcgui https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt
    popd
}

install_stablediffusion_webui() {
    local pathStableDiffusionWebUI="$HOME/packgpt/stablediffusion_webui"
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    mkdir -p $pathStableDiffusionWebUI
    wget -q -P $pathStableDiffusionWebUI https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
    chmod +x $pathStableDiffusionWebUI/webui.sh
    export COMMANDLINE_ARGS="--skip-torch-cuda-test"
    pushd $pathStableDiffusionWebUI
    ./webui.sh
    popd
}

install_textgenwebui() {
    local pathTextGenWebUI="$HOME/packgpt/textgenwebui"
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    mkdir -p $pathTextGenWebUI
    git clone https://github.com/oobabooga/text-generation-webui.git $pathTextGenWebUI || { echo "Cloning failed"; exit 1; }
    pushd $pathTextGenWebUI
    python3 -m venv textgenwebui_env
    source textgenwebui_env/bin/activate
    pip install -r requirements.txt
    popd
}

install_videocrafter() {
    local pathVideocrafter="$HOME/packgpt/videocrafter"
    if ! command -v conda &> /dev/null; then
        execute_as_sudo apt install -y wget
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
        bash ~/miniconda.sh -b -p $HOME/miniconda
        export PATH="$HOME/miniconda/bin:$PATH"
        conda init
    fi
    mkdir -p $pathVideocrafter
    git clone https://github.com/AILab-CVC/VideoCrafter.git $pathVideocrafter || { echo "Cloning failed"; exit 1; }
    pushd $pathVideocrafter
    conda create -n videocrafter python=3.8.5 -y
    conda activate videocrafter
    pip install torch torchvision
    pip install -r requirements.txt
    popd
}

install_system_packages
install_pyenv
install_biniou
install_pinokio
install_buzz
install_final2x
install_fooocus
install_gpt4all
install_lmstudio
install_localGPT
install_ollama
install_ollamagui
install_chatd
install_privategpt
install_replay
install_rvcgui
install_stablediffusion_webui
install_textgenwebui
install_videocrafter
