" vim config
" github.com/ojroques

set nocompatible

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <F3> :set wrap!<bar>:set linebreak!<bar>:set breakindent!<CR>
nnoremap <F4> :set spell!<CR>
nnoremap <F5> :checktime<CR>
nnoremap <F6> :set scrollbind!<CR>
nnoremap <F9> :Lexplore<CR>
nnoremap <S-Up> <C-w>2>
nnoremap <S-Down> <C-w>2<
nnoremap <S-Left> <C-w>2-
nnoremap <S-Right> <C-w>2+
nnoremap <expr><leader>w len(getbufinfo("")[0].windows) > 1 ?
    \ ":close<CR>" :
    \ (bufnr("") == getbufinfo({"buflisted": 1})[-1].bufnr ? ":bp" : ":bn")."<bar>bd #<CR>"
nnoremap <leader>W :%bd<bar>e #<bar>bd #<bar>normal `"<CR>
nnoremap <leader>i :confirm qall<CR>
nnoremap <leader>o m`o<Esc>``
nnoremap <leader>u :update<CR>
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>
vnoremap <leader>c "+y

filetype plugin indent on
syntax enable
colorscheme desert
set autoindent                        " Copy indent from previous line
set autoread                          " Reload file modified outside vim
set background=dark                   " Adjust default color groups
set backspace=indent,eol,start        " Enhanced backspacing in insert mode
set complete=.,w,b,u,t                " Location of completion keywords
set completeopt=menu,longest          " Insert mode completion
set expandtab                         " Use spaces instead of tabs
set hidden                            " Enable background buffers
set hlsearch                          " Highlight search terms
set ignorecase                        " Ignore case
set incsearch                         " Highlight search patterns
set laststatus=2                      " Always display status line
set list                              " List mode
set listchars=tab:>\ ,trail:-,nbsp:+  " Characters to show for spaces
set nowrap                            " Disable line wrap
set number relativenumber             " Relative line number
set pastetoggle=<F2>                  " Paste mode
set ruler                             " Show cursor line and column
set shiftround                        " Round indent
set shiftwidth=2                      " Number of spaces when indenting
set shortmess=filnxtToOF              " Configure vim messages
set showcmd                           " Show current command
set sidescrolloff=10                  " Columns of context
set smartcase                         " Do not ignore case with uppercase character
set smartindent                       " Insert indents automatically
set softtabstop=2                     " Number of spaces for tabs when editing
set splitbelow splitright             " Change position of new windows
set tabstop=2                         " Number of spaces tabs count for
set termguicolors                     " True color support
set wildmenu                          " Enhanced command-line completion
set wildmode=longest:full,full        " Command-line completion mode
