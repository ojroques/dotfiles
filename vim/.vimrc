" vim config
" github.com/ojroques

set nocompatible

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
set showcmd                           " Show current command
set wildmenu                          " Enhanced command-line completion

" OPTIONS
set completeopt=menuone,noinsert,noselect  " Completion options
set expandtab              " Use spaces instead of tabs
set formatoptions=crqnj    " Automatic formatting options
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
set updatetime=100         " Delay before swap file is saved
set wildmode=list:longest  " Command-line completion mode
colorscheme desert

" MAPPINGS
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap jj <ESC>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <C-w>T :tabclose<CR>
nnoremap <C-w>t :tabnew<CR>
nnoremap <F3> :ToggleWrap<CR>
nnoremap <F4> :set scrollbind!<CR>
nnoremap <F5> :checktime<CR>
nnoremap <S-Down> <C-w>2<
nnoremap <S-Left> <C-w>2-
nnoremap <S-Right> <C-w>2+
nnoremap <S-Up> <C-w>2>
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
nnoremap <leader>t :terminal ++curwin<CR>
nnoremap <leader>u :update<CR>
nnoremap <leader>w :CloseBuffer<CR>
nnoremap <leader>x :conf qa<CR>
nnoremap Q :WarnCaps<CR>
nnoremap U :WarnCaps<CR>
nnoremap [<space> m`O<Esc>0D``
nnoremap [b :bprevious<CR>
nnoremap ]<space> m`o<Esc>0D``
nnoremap ]b :bnext<CR>
noremap <leader>c "+y
tnoremap <ESC> <C-\><C-n>
tnoremap jj <C-\><C-n>
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>

" COMMANDS
function! s:close_buffer()
  let l:buflisted = getbufinfo({'buflisted': 1})
  let [l:cur_winnr, l:cur_bufnr] = [winnr(), bufnr()]
  if len(l:buflisted) < 2 | confirm qall | return | endif
  for l:winid in getbufinfo(l:cur_bufnr)[0].windows
    execute(win_id2win(l:winid) . 'wincmd w')
    if l:cur_bufnr == l:buflisted[-1].bufnr | bp | else | bn | endif
  endfor
  execute(l:cur_winnr . 'wincmd w')
  let l:is_terminal = getbufvar(l:cur_bufnr, '&buftype') == 'terminal'
  if l:is_terminal | bd! # | else | silent! confirm bd # | endif
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
