" INIT
set nocompatible
filetype plugin indent on
syntax enable

" OPTIONS
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set completeopt=menuone,noselect
set encoding=utf-8
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>\ ,trail:-,nbsp:+
set nojoinspaces
set nostartofline
set nowrap
set number relativenumber
set pumheight=12
set report=0
set ruler
set scrolloff=4
set shiftround
set shiftwidth=0
set showcmd
set sidescrolloff=12
set smartcase
set smartindent
set splitbelow splitright
set tabstop=2
set termguicolors
set textwidth=99
set updatetime=200
set wildmenu
set wildmode=list:longest
colorscheme desert

" MAPPINGS
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <leader>u :update<CR>
nnoremap <leader>x :conf qa<CR>
nnoremap H zh
nnoremap L zl
nnoremap Q @@
nnoremap Y y$
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
