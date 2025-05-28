#################### COMMANDS ##################################################
.PHONY: install-base
install-base: update base

.PHONY: install-cli
install-cli: install-base cli

.PHONY: install-gui
install-gui: install-base gui

.PHONY: install-ls
install-ls: bashls gols pythonls

.PHONY: update
update:
	@echo "Updating packages..."
	@apt update
	@apt -y upgrade

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@apt -y autoremove

#################### PACKAGES ##################################################
.PHONY: base
base:
	@echo "Installing base packages..."
	@apt -y install \
		build-essential \
		curl \
		direnv \
		git \
		manpages-posix \
		software-properties-common \
		stow \
		tmux \
		tree \
		unzip \
		vim

.PHONY: cli
cli: go neovim
	@echo "Installing cli packages..."
	@apt -y install \
		7zip \
		bat \
		btop \
		fd-find \
		git-delta \
		keychain \
		nodejs \
		npm \
		ripgrep \
		shellcheck \
		trash-cli \
		zsh \
		zsh-syntax-highlighting

.PHONY: gui
gui:
	@echo "Installing gui packages..."
	@apt -y install \
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
	@curl -fsSL -o go.tar.gz https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
	@rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz
	@rm -f go.tar.gz

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@curl -fsSL -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
	@install nvim-linux-x86_64.appimage /usr/bin/nvim
	@rm -f nvim-linux-x86_64.appimage

#################### LANGUAGE SERVERS ##########################################
.PHONY: bashls
bashls:
	@echo "Installing bash language server..."
	@npm install -g bash-language-server
	@go install mvdan.cc/sh/v3/cmd/shfmt@latest

.PHONY: gols
gols:
	@echo "Installing go language server..."
	@go install golang.org/x/tools/gopls@latest

.PHONY: pythonls
pythonls: uv
	@echo "Installing python language server..."
	@uv tool install ty@latest

#################### APPS ######################################################
.PHONY: aider
aider:
	@echo "Installing aider..."
	@uv tool install --with pip aider-chat@latest

.PHONY: fzf
fzf:
	@echo "Installing fzf..."
	@rm -rf ~/.fzf ~/.fzf-git
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git
	@~/.fzf/install --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish

.PHONY: jetbrains-mono
jetbrains-mono:
	@echo "Installing jetbrains mono..."
	@curl -fsSL -o jetbrains-mono.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
	@mkdir -p ~/.local/share/fonts/JetBrainsMono
	@tar -C ~/.local/share/fonts/JetBrainsMono -xJf jetbrains-mono.tar.xz
	@rm -f jetbrains-mono.tar.xz
	@fc-cache -f

.PHONY: tree-sitter
tree-sitter:
	@echo "Installing tree-sitter..."
	@npm install -g tree-sitter-cli

.PHONY: uv
uv:
	@echo "Installing uv..."
	@curl -fsSL https://astral.sh/uv/install.sh | sh
