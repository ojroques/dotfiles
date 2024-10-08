#################### VARIABLES #############################
SHELL = /bin/bash
LOG = /dev/stdout

#################### COMMANDS ##############################
.PHONY: install-base
install-base: update base

.PHONY: install-cli
install-cli: install-base cli

.PHONY: install-gui
install-gui: install-base gui

.PHONY: install-lsp
install-lsp: install-base lsp

.PHONY: install-latex
install-latex: install-base latex

.PHONY: update
update:
	@echo "Updating packages..."
	@apt-get update > $(LOG)
	@apt-get -y upgrade > $(LOG)

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@apt-get -y autoremove > $(LOG)

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
		vim \
		> $(LOG)

.PHONY: cli
cli: delta gdb-dashboard go neovim
	@echo "Installing cli packages..."
	@apt-get -y install \
		bat \
		direnv \
		fd-find \
		fzf \
		keychain \
		ripgrep \
		shellcheck \
		tmux \
		zsh \
		zsh-syntax-highlighting \
		> $(LOG)

.PHONY: gui
gui: alacritty
	@echo "Installing gui packages..."
	@apt-get -y install \
		arc-theme \
		firefox \
		fonts-jetbrains-mono \
		papirus-icon-theme \
		viewnior \
		vlc \
		xfce4-taskmanager \
		> $(LOG)

.PHONY: alacritty
alacritty:
	@echo "Installing alacritty..."
	@add-apt-repository -y ppa:aslatter/ppa > $(LOG)
	@apt-get update > $(LOG)
	@apt-get -y install alacritty > $(LOG)

.PHONY: delta
delta:
	@echo "Installing delta v0.17.0..."
	@curl -fsSL -o /tmp/delta.dpkg \
		https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb > $(LOG)
	@dpkg -i /tmp/delta.dpkg > $(LOG)
	@rm -f /tmp/delta.dpkg

.PHONY: gdb-dashboard
gdb-dashboard:
	@echo "Installing gdb-dashboard..."
	@curl -fsSL --create-dirs -o /etc/gdb/gdbinit \
		https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit > $(LOG)

.PHONY: go
go:
	@echo "Installing go v1.22..."
	@curl -fsSL -o /tmp/go.tar.gz \
		https://go.dev/dl/go1.22.4.linux-amd64.tar.gz > $(LOG)
	@rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz > $(LOG)
	@rm -f /tmp/go.tar.gz

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@add-apt-repository -y ppa:neovim-ppa/unstable > $(LOG)
	@apt-get update > $(LOG)
	@apt-get -y install neovim > $(LOG)

#################### LANGUAGE SERVERS ######################
.PHONY: lsp
lsp: bashls gols pythonls

.PHONY: bashls
bashls:
	@echo "Installing bash language server..."
	@apt-get -y install nodejs npm > $(LOG)
	@npm install -g bash-language-server > $(LOG)

.PHONY: gols
gols: go
	@echo "Installing go language server..."
	@GOBIN=/usr/local/go/bin /usr/local/go/bin/go install golang.org/x/tools/gopls@latest > $(LOG)

.PHONY: pythonls
pythonls:
	@echo "Installing python3 language server..."
	@pip3 install --break-system-packages jedi python-lsp-server[pyflakes,pycodestyle,yapf] > $(LOG)

#################### LATEX #################################
.PHONY: latex
latex:
	@echo "Installing latex..."
	@apt-get -y install latexmk texlive-full > $(LOG)
