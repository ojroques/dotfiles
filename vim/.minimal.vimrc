" Minimal VIM config
" github.com/ojroques
" vim: foldmethod=marker foldlevel=1
"
set nocompatible

" MAPPINGS {{{
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <F3> :set wrap!<bar>:set linebreak!<bar>:set breakindent!<CR>
nnoremap <F4> :set spell!<CR>
nnoremap <F5> :checktime<CR>
nnoremap <leader>i :confirm qall<CR>
nnoremap <leader>o m`o<Esc>``
nnoremap <leader>u :update<CR>
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>
nnoremap j gj
nnoremap k gk
" }}}

" GENERAL {{{
filetype indent on                    " Load filetype indentation
filetype plugin on                    " Load filetype plugin
syntax enable                         " Enable syntax processing
set autoread                          " Reload buffers modified outside vim
set hidden                            " Enable background buffers
set splitbelow splitright             " Change position of new windows
set updatetime=400                    " Delay before swap file is saved
set visualbell                        " Disable sounds
" }}}

" APPEARANCE {{{
colorscheme desert                    " Color scheme
set background=dark                   " Dark background
set list                              " Show trailing blanks
set listchars=tab:>\ ,trail:-,nbsp:+  " Strings to use in list
set nowrap                            " Disable wrap lines
set number relativenumber             " Relative line number
set scrolloff=4                       " Show lines of context
set termguicolors                     " True color support
" }}}

" INDENTATION {{{
set autoindent                        " Copy indentation from previous line
set backspace=indent,eol,start        " Intuitive backspacing in insert mode
set expandtab                         " Tabs are spaces
set pastetoggle=<F2>                  " Aid in pasting text
set shiftround                        " Round indent
set shiftwidth=2                      " Number of shifts
set smartindent                       " Automatically inserts indentation
set softtabstop=2                     " Number of spaces in tab when editing
set tabstop=2                         " Number of visual spaces per tab
" }}}

" SEARCH {{{
set hlsearch                          " Highlight search terms...
set incsearch                         " ...dynamically as they are typed
set ignorecase                        " Ignore case when searching...
set smartcase                         " ...unless an uppercase character is used
" }}}

" COMPLETION {{{
set complete=.,w,b,u,t                " Where to search for keywords
set completeopt=menu,longest          " How completion occurs
set wildmenu                          " Command-line completion
set wildmode=longest:full,full        " Complete to the longest common string
" }}}
