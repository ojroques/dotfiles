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
		git \
		manpages-posix \
		software-properties-common \
		stow \
		tmux \
		unzip \
		vim

.PHONY: cli
cli: go neovim
	@echo "Installing cli packages..."
	@apt -y install \
		7zip \
		bat \
		btop \
		direnv \
		fd-find \
		nodejs \
		npm \
		ripgrep \
		shellcheck \
		trash-cli \
		tree \
		zsh \
		zsh-syntax-highlighting

.PHONY: gui
gui:
	@echo "Installing gui packages..."
	@apt -y install \
		alacritty \
		arc-theme \
		firefox \
		gparted \
		mpv \
		nomacs \
		papirus-icon-theme \
		xfce4-taskmanager

.PHONY: go
go:
	@echo "Installing go v1.24..."
	@curl -fsSL -o go.tar.gz https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
	@rm -rf /usr/local/go
	@tar -C /usr/local -xzf go.tar.gz && rm -f go.tar.gz

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@curl -fsSL -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
	@tar -C /usr --strip-components=1 -xzf nvim.tar.gz && rm -f nvim.tar.gz

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
.PHONY: difftastic
difftastic:
	@echo "Installing difftastic v0.64..."
	@curl -fsSL -o difftastic.tar.gz https://github.com/Wilfred/difftastic/releases/download/0.64.0/difft-x86_64-unknown-linux-gnu.tar.gz
	@mkdir -p ~/.local/bin
	@tar -C ~/.local/bin -xzf difftastic.tar.gz
	@rm -f difftastic.tar.gz

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
