" vim config
" github.com/ojroques

set nocompatible

" VIM-SPECIFIC OPTIONS
filetype plugin indent on
syntax enable
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set complete=.,w,b,u,t
set hidden
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set nojoinspaces
set ruler
set showcmd
set wildmenu

" OPTIONS
set completeopt=menu,menuone,noselect
set expandtab
set ignorecase
set list
set nowrap
set number relativenumber
set pastetoggle='<F2>'
set pumheight=12
set scrolloff=4
set shiftround
set shiftwidth=2
set shortmess="atToOFc"
set sidescrolloff=8
set smartcase
set smartindent
set splitbelow splitright
set tabstop=2
set termguicolors
set textwidth=80
set updatetime=100
set wildmode=list:longest
colorscheme desert

" MAPPINGS
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <S-Down> <C-w>2<
nnoremap <S-Left> <C-w>2-
nnoremap <S-Right> <C-w>2+
nnoremap <S-Up> <C-w>2>
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
nnoremap <leader>u :update<CR>
nnoremap <leader>w :conf bd<CR>
nnoremap <leader>x :conf qa<CR>
nnoremap Q @@
nnoremap U <NOP>
nnoremap Y y$
nnoremap [<space> m`O<Esc>0D``
nnoremap [b :bprevious<CR>
nnoremap ]<space> m`o<Esc>0D``
nnoremap ]b :bnext<CR>
nnoremap s :ls<CR>:b<Space>
noremap <leader>c "+y
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>
