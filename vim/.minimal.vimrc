" Minimal VIM config
" github.com/ojroques

set nocompatible

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <F3> :set wrap!<bar>:set linebreak!<bar>:set breakindent!<CR>
nnoremap <F4> :set spell!<CR>
nnoremap <F5> :checktime<CR>
nnoremap <leader>i :confirm qall<CR>
nnoremap <leader>o m`o<Esc>``
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
nnoremap <leader>u :update<CR>
nnoremap j gj
nnoremap k gk
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>

colorscheme desert                    " Color scheme
filetype indent on                    " Load filetype indentation
filetype plugin on                    " Load filetype plugin
set autoindent                        " Copy indentation from previous line
set autoread                          " Reload buffers modified outside vim
set background=dark                   " Dark background
set backspace=indent,eol,start        " Intuitive backspacing in insert mode
set complete=.,w,b,u,t                " Where to search for keywords
set completeopt=menu,longest          " How completion occurs
set expandtab                         " Tabs are spaces
set hidden                            " Enable background buffers
set hlsearch                          " Highlight search terms
set ignorecase                        " Ignore case when searching
set incsearch                         " Dynamic highlight
set laststatus=2                      " Always display status line
set list                              " Show trailing blanks
set listchars=tab:>\ ,trail:-,nbsp:+  " Characters to show for spaces
set listchars+=extends:>,precedes:<   " Characters delimiting lines
set nowrap                            " Disable wrap lines
set number relativenumber             " Relative line number
set pastetoggle=<F2>                  " Aid in pasting text
set ruler                             " Show cursor line and column
set scrolloff=4                       " Lines of context
set shiftround                        " Round indent
set shiftwidth=2                      " Number of shifts
set sidescrolloff=8                   " Columns of context
set smartcase                         " Case-sensitive with uppercase letters
set smartindent                       " Automatically inserts indentation
set softtabstop=2                     " Number of spaces in tab when editing
set splitbelow splitright             " Change position of new windows
set tabstop=2                         " Number of visual spaces per tab
set termguicolors                     " True color support
set updatetime=400                    " Delay before swap file is saved
set wildmenu                          " Command-line completion
set wildmode=longest:full,full        " Complete to the longest common string
syntax enable                         " Enable syntax processing
