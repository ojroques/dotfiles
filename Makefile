#################### COMMANDS ##############################
.PHONY: install-base
install-base: update base

.PHONY: install-cli
install-cli: install-base cli

.PHONY: install-gui
install-gui: install-base gui

.PHONY: install-lsp
install-lsp: install-base lsp

.PHONY: update
update:
	@echo "Updating packages..."
	@apt-get update
	@apt-get -y upgrade

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@apt-get -y autoremove

#################### APPS ##################################
.PHONY: base
base:
	@echo "Installing base packages..."
	@apt-get -y install \
		build-essential \
		curl \
		git \
		htop \
		manpages-posix \
		python3-pip \
		software-properties-common \
		stow \
		tree \
		unzip \
		vim

.PHONY: cli
cli: go neovim
	@echo "Installing cli packages..."
	@apt-get -y install \
		7zip \
		bat \
		direnv \
		fd-find \
		git-delta \
		keychain \
		ripgrep \
		shellcheck \
		tmux \
		zsh \
		zsh-syntax-highlighting

.PHONY: gui
gui:
	@echo "Installing gui packages..."
	@apt-get -y install \
		alacritty \
		arc-theme \
		firefox \
		mpv \
		nomacs \
		papirus-icon-theme \
		xfce4-taskmanager

.PHONY: go
go:
	@echo "Installing go v1.24..."
	@curl -fsSL -o go.tar.gz https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
	@rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz
	@rm -f go.tar.gz

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@curl -fsSL -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
	@install nvim-linux-x86_64.appimage /usr/bin/nvim
	@rm -f nvim-linux-x86_64.appimage

.PHONY: jetbrains-mono
jetbrains-mono:
	@echo "Installing jetbrains mono..."
	@curl -fsSL -o jetbrains-mono.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
	@mkdir -p ~/.local/share/fonts/JetBrainsMono
	@tar -C ~/.local/share/fonts/JetBrainsMono -xJf jetbrains-mono.tar.xz
	@rm -f jetbrains-mono.tar.xz ~/.local/share/fonts/JetBrainsMono/{*.md,*.txt}
	@fc-cache -f

.PHONY: fzf
fzf:
	@echo "Installing fzf..."
	@rm -rf ~/.fzf ~/.fzf-git
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git
	@~/.fzf/install --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish

#################### LANGUAGE SERVERS ######################
.PHONY: lsp
lsp: bashls gols pythonls

.PHONY: bashls
bashls:
	@echo "Installing bash language server..."
	@apt-get -y install nodejs npm
	@npm install -g bash-language-server

.PHONY: gols
gols: go
	@echo "Installing go language server..."
	@GOBIN=/usr/local/go/bin /usr/local/go/bin/go install golang.org/x/tools/gopls@latest

.PHONY: pythonls
pythonls:
	@echo "Installing python3 language server..."
	@pip3 install --break-system-packages jedi python-lsp-server[pyflakes,pycodestyle,yapf]
