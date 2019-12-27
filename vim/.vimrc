" VIM config
" By Olivier Roques
" github.com/ojroques

" ===================== GENERAL ============================
set nocompatible    " Use Vim settings instead of Vi settings
set autoread        " Reload buffers modified outside vim
set hidden          " Enable background buffers
set history=1000    " Command line history
set updatetime=300  " Delay before swap file is written to disk
set visualbell      " Disable sounds

" ===================== PLUGINS ============================
filetype off
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'google/vim-searchindex'
Plug 'joshdick/onedark.vim'
Plug 'machakann/vim-sandwich'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
if has("nvim")
    Plug 'airblade/vim-rooter'
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
    Plug 'junegunn/fzf.vim'
    Plug 'lervag/vimtex'
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
endif
call plug#end()

let g:airline#extensions#tabline#enabled = 1          " Display all buffers
let g:airline#extensions#tabline#buffer_idx_mode = 1  " Display buffer index
let g:airline#extensions#tabline#fnamemod = ':p:t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#wordcount#filetypes = ['markdown', 'plaintex', 'tex', 'text']
let g:gitgutter_map_keys = 0                          " Disable gitgutter mappings
let g:netrw_liststyle = 3                             " Tree style listing
runtime macros/sandwich/keymap/surround.vim           " Use vim-surround mappings

if has("nvim")
    " Fuzzy finder (fzf)
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'  " Change fzf command
    nnoremap <C-p> :Files<CR>
    nnoremap <leader>p :Rg<CR>
    nnoremap <leader>g :Commits<CR>

    " Autocompletion (deoplete)
    let g:deoplete#enable_at_startup = 1                 " Run deoplete at startup
    call deoplete#custom#option('ignore_case', v:false)  " Case is not ignored
    call deoplete#custom#option('max_list', 10)          " Number of candidates

    " Language Server Protocol (languageclient-neovim)
    let g:LanguageClient_serverCommands = {
        \ 'c': ['ccls'],
        \ 'cpp': ['ccls'],
        \ 'go': ['gopls'],
        \ 'python': ['pyls'],
        \ }
    let g:LanguageClient_settingsPath = "~/.config/nvim/settings.json"
    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
    nnoremap <leader>d :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>r :call LanguageClient#textDocument_references()<CR>
    nnoremap <leader>f :call LanguageClient#textDocument_formatting()<CR>

    " LaTeX (vimtex)
    let g:polyglot_disabled = ['latex']  " Disable polyglot for latex
    let g:vimtex_quickfix_mode = 0       " Quickfix window stays closed
    let g:vimtex_view_method = 'zathura' " Default PDF viewer
    call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
endif

" ===================== MAPPINGS ===========================
" Exit insert mode
inoremap jj <ESC>
" Move accross diplay lines
noremap j gj
noremap k gk
" Insert blank new line
nnoremap <leader>O m`O<Esc>``
nnoremap <leader>o m`o<Esc>``
" Toggle word wrap
nnoremap <F3> :set wrap!<bar>:set linebreak!<bar>:set breakindent!<CR>
" Toggle spell check
nnoremap <F4> :set spell!<CR>
" Cycle between completion entries
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Toggle fold
nnoremap <space> za
" Copy to system clipboard
vnoremap <leader>c "+y
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
" Close buffer (without closing window)
nnoremap <expr><leader>w len(getbufinfo("")[0].windows) > 1 ?
  \ ":close<CR>" :
  \ (bufnr("") == getbufinfo({"buflisted": 1})[-1].bufnr ? ":bp" : ":bn")."<bar>bd #<CR>"
" Close all buffers except current
nnoremap <leader>W :%bd<bar>e #<bar>bd #<bar>normal `"<CR>
" Save buffer
nnoremap <leader>n :update<CR>
" Save buffer and quit
nnoremap <leader>m :x<CR>
" Save read-only buffer
cnoremap w!! w !sudo tee % > /dev/null
" Quickfix list
nnoremap <Up> :copen<CR>
nnoremap <Down> :cclose<CR>
nnoremap <Right> :cnext<CR>
nnoremap <Left> :cprev<CR>
" Location list
nnoremap <S-Up> :lopen<CR>
nnoremap <S-Down> :lclose<CR>
nnoremap <S-Right> :lnext<CR>
nnoremap <S-Left> :lprev<CR>

" ===================== INTERFACE ==========================
filetype plugin on                    " Load filetype plugin
filetype indent on                    " Load filetype indentation
syntax enable                         " Enable syntax processing
set background=dark                   " Dark background
set termguicolors                     " True color support
colorscheme onedark                   " Color scheme
set colorcolumn=80                    " Line length marker
set cursorline                        " Highlight current line
set list                              " Show trailing blanks
set listchars=tab:>\ ,trail:-,nbsp:+  " Strings to use in list
set nowrap                            " Disable wrap lines
set number relativenumber             " Relative line number
set scrolloff=4                       " Show lines of context
set showcmd                           " Show commands
set showmode                          " Show current mode
set signcolumn=yes                    " Show sign column

" ===================== INDENTATION ========================
set autoindent                        " Copy indentation from previous line
set backspace=indent,eol,start        " Intuitive backspacing in insert mode
set expandtab                         " Tabs are spaces
set pastetoggle=<F2>                  " Aid in pasting text
set shiftround                        " Round indent
set shiftwidth=4                      " Number of shifts
set smartindent                       " Automatically inserts indentation
set softtabstop=4                     " Number of spaces in tab when editing
set tabstop=4                         " Number of visual spaces per tab

" ===================== SEARCH =============================
set hlsearch                          " Highlight search terms...
set incsearch                         " ...dynamically as they are typed
set ignorecase                        " Ignore case when searching...
set smartcase                         " ...unless we type a capital

" ===================== COMPLETION =========================
set complete=.,w,b,u,t                " Where to search for keywords
set completeopt=menu,longest          " How completion occurs
set wildmenu                          " Command-line completion
set wildmode=longest:full,full        " Complete to the longest common string
