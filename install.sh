# Update and Upgrade the distro
sudo apt update && sudo apt upgrade -y

# Install all of the needed software to use Brew and interact with WSL
sudo apt install build-essential zsh git curl wslu -y 

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
mkdir ~/.nvm

# Install Go, NVM, NeoVim and all of it's needed dependencies for NvChad
brew install go fd nvm gopls neovim stylua ripgrep prettier shellcheck typescript-language-server vscode-langservers-extracted

# Configure NVM and Node
export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

nvm install lts/*
nvm use lts/*

# Install ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install NvChad
git clone https://github.com/Bare7a/NvChad ~/.config/nvim --depth 1

# Add default configs for zshrc and p10k
export WIN_HOME_FOLDER="$(wslpath "$(wslvar USERPROFILE)")/home/."
cp -r $WIN_HOME_FOLDER ~/
chmod 644 ~/.zshrc
chmod 777 ~/.p10k.zsh

# Add the needed SSH keys and start the SSH Agent
export WIN_SSH_FOLDER="$(wslpath "$(wslvar USERPROFILE)")/.ssh"
cp -r $WIN_SSH_FOLDER ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
eval `ssh-agent`
ssh-add

# Set the default terminal to ZSH and start itt
sudo chsh -s $(which zsh) $USER
zsh
