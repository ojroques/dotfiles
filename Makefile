#################### COMMANDS ##################################################
.PHONY: system-cli-apps
system-cli-apps: cli-pkg go neovim tree-sitter

.PHONY: system-gui-apps
system-gui-apps: gui-pkg

.PHONY: user-apps
user-apps: difftastic fzf jetbrains-mono uv

.PHONY: language-servers
language-servers: go-ls python-ls terraform-ls

.PHONY: apt-update
apt-update:
	@echo "Updating packages..."
	@apt update
	@apt -y upgrade

.PHONY: apt-clean
apt-clean:
	@echo "Removing unneeded packages..."
	@apt -y autoremove

#################### SYSTEM APPS ###############################################
.PHONY: cli-pkg
cli-pkg: apt-update
	@echo "Installing cli packages..."
	@apt -y install \
		7zip \
		bat \
		build-essential \
		curl \
		direnv \
		fd-find \
		git \
		ripgrep \
		shellcheck \
		software-properties-common \
		stow \
		tmux \
		trash-cli \
		tree \
		unrar \
		unzip \
		vim \
		xsel \
		zsh \
		zsh-syntax-highlighting

.PHONY: gui-pkg
gui-pkg: apt-update
	@echo "Installing gui packages..."
	@apt -y install \
		alacritty \
		arc-theme \
		firefox \
		mpv \
		papirus-icon-theme

# renovate: datasource=golang-version depName=go
go_version := "1.26.1"

.PHONY: go
go:
	@echo "Installing go v$(go_version)..."
	@curl -fsSL -o go.tar.gz https://go.dev/dl/go$(go_version).linux-amd64.tar.gz
	@rm -rf /opt/go && mkdir -p /opt/go
	@tar -C /opt/go --strip-components=1 -xzf go.tar.gz && rm -f go.tar.gz
	@ln -sf /opt/go/bin/go /usr/local/bin/go
	@ln -sf /opt/go/bin/gofmt /usr/local/bin/gofmt

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@curl -fsSL -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
	@rm -rf /opt/nvim && mkdir -p /opt/nvim
	@tar -C /opt/nvim --strip-components=1 -xzf nvim.tar.gz && rm -f nvim.tar.gz
	@ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# renovate: datasource=github-releases depName=tree-sitter/tree-sitter
tree_sitter_version := "v0.26.7"

.PHONY: tree-sitter
tree-sitter:
	@echo "Installing tree-sitter $(tree_sitter_version)..."
	@curl -fsSL -o tree-sitter.zip https://github.com/tree-sitter/tree-sitter/releases/download/$(tree_sitter_version)/tree-sitter-cli-linux-x64.zip
	@unzip -d /usr/local/bin -oq tree-sitter.zip && rm -f tree-sitter.zip
	@chmod +x /usr/local/bin/tree-sitter

#################### USER APPS #################################################
# renovate: datasource=github-releases depName=wilfred/difftastic
difftastic_version := "0.67.0"

.PHONY: difftastic
difftastic:
	@echo "Installing difftastic v$(difftastic_version)..."
	@curl -fsSL -o difftastic.tar.gz https://github.com/Wilfred/difftastic/releases/download/$(difftastic_version)/difft-x86_64-unknown-linux-gnu.tar.gz
	@mkdir -p ~/.local/bin
	@tar -C ~/.local/bin -xzf difftastic.tar.gz && rm -f difftastic.tar.gz

.PHONY: fzf
fzf:
	@echo "Installing fzf..."
	@rm -rf ~/.fzf ~/.fzf-git
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git
	@~/.fzf/install --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish

# renovate: datasource=github-releases depName=ryanoasis/nerd-fonts
jetbrains_mono_version := "v3.3.0"

.PHONY: jetbrains-mono
jetbrains-mono:
	@echo "Installing jetbrains mono $(jetbrains_mono_version)..."
	@curl -fsSL -o jetbrains-mono.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/$(jetbrains_mono_version)/JetBrainsMono.tar.xz
	@rm -rf ~/.local/share/fonts/JetBrainsMono && mkdir -p ~/.local/share/fonts/JetBrainsMono
	@tar -C ~/.local/share/fonts/JetBrainsMono -xJf jetbrains-mono.tar.xz && rm -f jetbrains-mono.tar.xz
	@fc-cache -f

# renovate: datasource=github-releases depName=astral-sh/uv
uv_version := "0.11.6"

.PHONY: uv
uv:
	@echo "Installing uv v$(uv_version)..."
	@curl -fsSL -o uv.tar.gz https://releases.astral.sh/github/uv/releases/download/$(uv_version)/uv-x86_64-unknown-linux-gnu.tar.gz
	@mkdir -p ~/.local/bin
	@tar -C ~/.local/bin --strip-components=1 -xzf uv.tar.gz && rm -f uv.tar.gz

#################### LANGUAGE SERVERS ##########################################
.PHONY: go-ls
go-ls:
	@echo "Installing go language server..."
	@go install golang.org/x/tools/gopls@latest

.PHONY: python-ls
python-ls:
	@echo "Installing python language server..."
	@uv tool install ty@latest

# renovate: datasource=github-releases depName=hashicorp/terraform-ls
terraform_ls_version := "0.38.4"

.PHONY: terraform-ls
terraform-ls:
	@echo "Installing terraform language server v$(terraform_ls_version)..."
	@curl -fsSL -o terraform-ls.zip https://releases.hashicorp.com/terraform-ls/$(terraform_ls_version)/terraform-ls_$(terraform_ls_version)_linux_amd64.zip
	@mkdir -p ~/.local/bin
	@unzip -d ~/.local/bin -oq terraform-ls.zip terraform-ls && rm -f terraform-ls.zip
