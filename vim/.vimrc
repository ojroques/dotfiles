" VIM config
" By Olivier Roques
" github.com/ojroques

" ===================== GENERAL ============================
set nocompatible    " Use Vim settings instead of Vi settings
set history=100     " Command line history
set visualbell      " Disable sounds
set autoread        " Reload buffers modified outside vim
set hidden          " Buffers can exist in background
set updatetime=300  " Delay before swap file is written to disk

" ===================== PLUGINS ============================
filetype off
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'google/vim-searchindex'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
if has("nvim")
    Plug 'airblade/vim-rooter'
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
    Plug 'junegunn/fzf.vim'
    Plug 'lervag/vimtex'
    Plug 'neoclide/coc.nvim', {'do': {-> coc#util#install()}}
else
    Plug 'ctrlpvim/ctrlp.vim'
endif
call plug#end()

" Display only the filename unless two buffers have the same name
let g:airline#extensions#tabline#fnamemod = ':p:t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_idx_mode = 1  " Display buffer index
let g:airline#extensions#tabline#enabled = 1          " Display all buffers
let g:gitgutter_map_keys = 0                          " Disable all gitgutter mappings
let g:netrw_liststyle = 3                             " Tree style listing

if has("nvim")
    " Fuzzy finder support (fzf)
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'  " Change fzf command
    nmap <C-p> :Files<CR>
    nmap <leader>p :Rg<CR>

    " Autocompletion support (coc.nvim)
    nmap <leader>d <Plug>(coc-definition)
    nmap <leader>r <Plug>(coc-references)

    " Latex support (vimtex)
    let g:polyglot_disabled = ['latex']    " Disable polyglot for latex
    let g:vimtex_quickfix_mode = 0         " Quickfix window stays closed
    let g:vimtex_view_method = 'zathura'   " Default PDF viewer
else
    " Fuzzy finder support (ctrlp)
    let g:ctrlp_open_multiple_files = 'i'  " Open files as hidden buffers
    let g:ctrlp_show_hidden = 1            " Display hidden files
endif

" ===================== MAPPINGS ===========================
" 'j' and 'k' move accross diplay lines
map j gj
map k gk
" Toggle word wrap and spell check
nmap <F3> :set wrap!<bar>:set linebreak!<bar>:set spell!<CR>
" Cycle between completion entries
imap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Toggle fold
nmap <space> za
" Change buffer
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>u <Plug>AirlineSelectPrevTab
nmap <leader>i <Plug>AirlineSelectNextTab
" Copy to system clipboard
vmap <leader>c "+y
" Paste from system clipboard
nmap <leader>v "+p
" Close buffer (without closing window)
nmap <leader>w :bp<bar>sp<bar>bn<bar>bd<CR>
" Save buffer
nmap <leader>n :update<CR>
" Save buffer and quit
nmap <leader>m :x<CR>
" Move up linewise
map <leader>j <Plug>(easymotion-j)
" Move down linewise
map <leader>k <Plug>(easymotion-k)
" Insert blank new line
nmap <leader>; o<Esc>
" Quickfix list
nmap <Up> :copen<CR>
nmap <Down> :cclose<CR>
nmap <Right> :cnext<CR>
nmap <Left> :cprev<CR>
" Location list
nmap <S-Up> :lopen<CR>
nmap <S-Down> :lclose<CR>
nmap <S-Right> :lnext<CR>
nmap <S-Left> :lprev<CR>

" ===================== INTERFACE ==========================
filetype plugin on              " Load filetype plugin
filetype indent on              " Load filetype indentation
syntax enable                   " Enable syntax processing
set background=dark             " Dark background
set termguicolors               " True color support
colorscheme onedark             " Color scheme
set colorcolumn=80              " Line length marker
set cursorline                  " Highlight current line
set nowrap                      " Disable wrap lines
set number                      " Relative line number
set scrolloff=4                 " Show lines of context
set showcmd                     " Show incomplete commands
set showmode                    " Show current mode
set signcolumn=yes              " Show sign column

" ===================== INDENTATION ========================
set expandtab                   " Tabs are spaces
set tabstop=4                   " Number of visual spaces per tab
set softtabstop=4               " Number of spaces in tab when editing
set shiftwidth=4                " Number of shifts
set autoindent                  " Copy the indentation from the previous line
set smartindent                 " Automatically inserts indentation
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set pastetoggle=<F2>            " Aid in pasting text from other applications

" ===================== SEARCH =============================
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital
set hlsearch                    " Highlight search terms...
set incsearch                   " ...dynamically as they are typed

" ===================== COMPLETION =========================
set complete=.,w,b,u,t                " Where to search for keywords
set completeopt=menu,longest,preview  " How completion occurs
set wildmode=list:longest             " Complete to the point of ambiguity

" ===================== GVIM ===============================
set guifont=Consolas:h11              " Change default font
set guioptions-=T                     " Remove toolbar
