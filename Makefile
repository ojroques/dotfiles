#################### VARIABLES #############################
SHELL = /bin/bash
LOG = /dev/stdout

#################### COMMANDS ##############################
.PHONY: install-base
install-base: update base

.PHONY: install-cli
install-cli: install-base cli

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
cli: bat delta gdb-dashboard go neovim ripgrep
	@echo "Installing cli packages..."
	@apt-get -y install \
		fd-find \
		fzf \
		keychain \
		shellcheck \
		tmux \
		zsh \
		> $(LOG)

.PHONY: bat
bat:
	@echo "Installing bat v0.22.1..."
	@curl -fsSL -o /tmp/bat.dpkg \
		https://github.com/sharkdp/bat/releases/download/v0.22.1/bat_0.22.1_amd64.deb > $(LOG)
	@dpkg -i /tmp/bat.dpkg > $(LOG)
	@rm -f /tmp/bat.dpkg

.PHONY: delta
delta:
	@echo "Installing delta v0.15.1..."
	@curl -fsSL -o /tmp/delta.dpkg \
		https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb > $(LOG)
	@dpkg -i /tmp/delta.dpkg > $(LOG)
	@rm -f /tmp/delta.dpkg

.PHONY: gdb-dashboard
gdb-dashboard:
	@echo "Installing gdb-dashboard..."
	@curl -fsSL --create-dirs -o /etc/gdb/gdbinit \
		https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit > $(LOG)

.PHONY: go
go:
	@echo "Installing go v1.19.4..."
	@curl -fsSL -o /tmp/go.tar.gz \
		https://go.dev/dl/go1.19.4.linux-amd64.tar.gz > $(LOG)
	@rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz > $(LOG)
	@rm -f /tmp/go.tar.gz

.PHONY: neovim
neovim:
	@echo "Installing neovim nightly..."
	@add-apt-repository -y ppa:neovim-ppa/unstable > $(LOG)
	@apt-get update > $(LOG)
	@apt-get -y install neovim > $(LOG)

.PHONY: ripgrep
ripgrep:
	@echo "Installing ripgrep v13.0.0..."
	@curl -fsSL -o /tmp/ripgrep.dpkg \
		https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb > $(LOG)
	@dpkg -i /tmp/ripgrep.dpkg > $(LOG)
	@rm -f /tmp/ripgrep.dpkg

#################### LANGUAGE SERVERS ######################
.PHONY: lsp
lsp: bashls cls gols pythonls

.PHONY: bashls
bashls:
	@echo "Installing bash language server..."
	@apt-get -y install nodejs npm > $(LOG)
	@npm install -g bash-language-server > $(LOG)

.PHONY: cls
cls:
	@echo "Installing c/c++ language server..."
	@apt-get -y install clangd-14 > $(LOG)
	@update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-14 100 > $(LOG)

.PHONY: gols
gols: go
	@echo "Installing go language server..."
	@go install golang.org/x/tools/gopls@latest > $(LOG)

.PHONY: pythonls
pythonls:
	@echo "Installing python3 language server..."
	@pip3 install jedi python-lsp-server[pyflakes,pycodestyle,yapf] > $(LOG)

#################### LATEX #################################
.PHONY: latex
latex:
	@echo "Installing latex..."
	@apt-get -y install latexmk texlive-full > $(LOG)
