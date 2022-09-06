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
		manpages-posix \
		python3-pip \
		software-properties-common \
		stow \
		tree \
		unzip \
		vim \
		> $(LOG)

.PHONY: cli
cli: bat delta gdb-dashboard neovim python ripgrep
	@echo "Installing CLI packages..."
	@apt-get -y install \
		fd-find \
		fzf \
		htop \
		shellcheck \
		> $(LOG)

.PHONY: gui
gui: kitty
	@echo "Installing GUI packages..."
	@apt-get -y install \
		arc-theme \
		firefox \
		papirus-icon-theme \
		redshift-gtk \
		rofi \
		viewnior \
		vlc \
		> $(LOG)

.PHONY: bat
bat:
	@echo "Installing bat v0.21.0..."
	@curl -fsSL -o /tmp/bat.dpkg \
		https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb > $(LOG)
	@dpkg -i /tmp/bat.dpkg > $(LOG)
	@rm -f /tmp/bat.dpkg

.PHONY: delta
delta:
	@echo "Installing delta v0.14.0..."
	@curl -fsSL -o /tmp/delta.dpkg \
		https://github.com/dandavison/delta/releases/download/0.14.0/git-delta_0.14.0_amd64.deb > $(LOG)
	@dpkg -i /tmp/delta.dpkg > $(LOG)
	@rm -f /tmp/delta.dpkg

.PHONY: gdb-dashboard
gdb-dashboard:
	@echo "Installing gdb-dashboard..."
	@curl -fsSL --create-dirs -o /etc/gdb/gdbinit \
		https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit > $(LOG)

.PHONY: kitty
kitty:
	@echo "Installing kitty.."
	@curl -fsSL -o /tmp/kitty.sh \
		https://sw.kovidgoyal.net/kitty/installer.sh > $(LOG)
	@bash /tmp/kitty.sh > $(LOG)
	@rm -f /tmp/kitty.sh

.PHONY: neovim
neovim:
	@echo "Installing Neovim nightly..."
	@add-apt-repository -y ppa:neovim-ppa/unstable > $(LOG)
	@apt-get update > $(LOG)
	@apt-get -y install neovim > $(LOG)

.PHONY: python
python:
	@echo "Installing Python3 packages..."
	@pip3 install matplotlib neovim-remote numpy scipy > $(LOG)

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
	@echo "Installing Bash language server..."
	@apt-get -y install nodejs npm > $(LOG)
	@npm install -g bash-language-server > $(LOG)

.PHONY: cls
cls:
	@echo "Installing C/C++ language server..."
	@apt-get -y install clangd-12 > $(LOG)
	@update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100 > $(LOG)

.PHONY: gols
gols:
	@echo "Installing Go language server..."
	@apt-get -y install golang > $(LOG)

.PHONY: pythonls
pythonls:
	@echo "Installing Python3 language server..."
	@pip3 install jedi python-lsp-server[pyflakes,pycodestyle,yapf] > $(LOG)

#################### LATEX #################################
.PHONY: latex
latex:
	@echo "Installing LaTeX..."
	@apt-get -y install \
		latexmk \
		texlive-full \
		xdotool \
		> $(LOG)
