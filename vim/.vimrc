" vim config
" github.com/ojroques

set nocompatible

" MAPPINGS
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <expr> <S-Tab> pumvisible() ? '\<C-p>' : '\<Tab>'
inoremap <expr> <Tab> pumvisible() ? '\<C-n>' : '\<Tab>'
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <C-w>ts :split<bar>terminal ++curwin<CR>
nnoremap <C-w>tv :vsplit<bar>terminal ++curwin<CR>
nnoremap <F3> :ToggleWrap<CR>
nnoremap <F4> :set spell!<CR>
nnoremap <F5> :checktime<CR>
nnoremap <F6> :set scrollbind!<CR>
nnoremap <F9> :Lexplore<CR>
nnoremap <S-Down> <C-w>2<
nnoremap <S-Left> <C-w>2-
nnoremap <S-Right> <C-w>2+
nnoremap <S-Up> <C-w>2>
nnoremap <leader><Down> :cclose<CR>
nnoremap <leader><Left> :cprev<CR>
nnoremap <leader><Right> :cnext<CR>
nnoremap <leader><Up> :copen<CR>
nnoremap <leader>i :conf qa<CR>
nnoremap <leader>o m`o<Esc>``
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
nnoremap <leader>t :terminal ++curwin<CR>
nnoremap <leader>u :update<CR>
nnoremap <leader>w :CloseBuffer<CR>
nnoremap Q :WarnCaps<CR>
nnoremap S :bn<CR>
nnoremap U :WarnCaps<CR>
nnoremap X :bp<CR>
noremap <leader>c "+y
tnoremap <ESC> <C-\><C-n>
tnoremap jj <C-\><C-n>
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>

" PLUGIN OPTIONS
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20

" VIM-SPECIFIC OPTIONS
filetype plugin indent on
syntax enable
set autoindent                        " Copy indent from previous line
set autoread                          " Reload file modified outside vim
set background=dark                   " Adjust default color groups
set backspace=indent,eol,start        " Enhanced backspace in insert mode
set complete=.,w,b,u,t                " Location of completion keywords
set hlsearch                          " Highlight search terms
set incsearch                         " Highlight search patterns
set laststatus=2                      " Always display status line
set listchars=tab:>\ ,trail:-,nbsp:+  " Characters to show for spaces
set ruler                             " Show cursor line and column
set shortmess=filnxtToOF              " Configure vim messages
set showcmd                           " Show current command
set wildmenu                          " Enhanced command-line completion

" OPTIONS
colorscheme desert
set completeopt=menuone,noinsert,noselect  " Completion options
set expandtab              " Use spaces instead of tabs
set formatoptions=tcrqnj   " Automatic formatting options
set hidden                 " Enable background buffers
set ignorecase             " Ignore case
set list                   " Show some invisible characters
set nojoinspaces           " No double spaces with join
set nowrap                 " Disable line wrap
set number relativenumber  " Relative line numbers
set pastetoggle='<F2>'     " Paste mode
set scrolloff=4            " Lines of context
set shiftround             " Round indent
set shiftwidth=2           " Size of an indent
set sidescrolloff=8        " Columns of context
set smartcase              " Don't ignore case with capitals
set smartindent            " Insert indents automatically
set splitbelow splitright  " Location of new windows
set tabstop=2              " Number of spaces tabs count for
set termguicolors          " True color support
set textwidth=80           " Maximum width of text
set updatetime=200         " Delay before swap file is saved
set wildmode=list:longest  " Command-line completion mode

" COMMANDS
function! s:close_buffer()
  if len(getbufinfo('')[0].windows) > 1 | close | return | endif
  let l:buflisted = getbufinfo({'buflisted': 1})
  if len(l:buflisted) < 2 | confirm quit | return | endif
  if bufnr('') == l:buflisted[-1].bufnr | bp | else | bn | endif
  if getbufvar('#', '&buftype') == 'terminal' | bd! # | return | end
  bd #
endfunction

function! s:toggle_wrap()
  set breakindent!
  set linebreak!
  set wrap!
endfunction

function! s:warn_caps()
  echohl WarningMsg
  echo 'Caps Lock may be on'
  echohl None
endfunction

command! CloseBuffer call s:close_buffer()
command! ToggleWrap call s:toggle_wrap()
command! WarnCaps call s:warn_caps()
