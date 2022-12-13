" INIT
set nocompatible
filetype plugin indent on
syntax enable

" OPTIONS
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set complete=.,w,b,u,t
set completeopt=menu,menuone,noselect
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>\ ,trail:-,nbsp:+
set nojoinspaces
set nowrap
set number relativenumber
set pumheight=12
set report=0
set ruler
set scrolloff=4
set shiftround
set shiftwidth=2
set shortmess=atToOFc
set showcmd
set sidescrolloff=12
set smartcase
set smartindent
set splitbelow splitright
set tabstop=2
set termguicolors
set textwidth=80
set updatetime=100
set wildmenu
set wildmode=list:longest
colorscheme desert

" MAPPINGS
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap Q @@
nnoremap Y y$
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
