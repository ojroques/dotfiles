" VIM config by Olivier Roques
" github.com/ojroques
" vim: foldmethod=marker foldlevel=1

set nocompatible  " Use Vim default options

" PLUGINS {{{
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'google/vim-searchindex'
Plug 'joshdick/onedark.vim'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'
if has("nvim")
    Plug 'airblade/vim-rooter'
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
    Plug 'junegunn/fzf.vim'
    Plug 'lervag/vimtex'
    Plug 'sheerun/vim-polyglot'
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
endif
call plug#end()
" }}}

" PLUGIN CONFIGURATION {{{
let g:airline_powerline_fonts = 1                     " Enable powerline symbols
let g:airline#extensions#tabline#enabled = 1          " Display all buffers
let g:airline#extensions#tabline#fnamemod = ':p:t'    " Buffer naming scheme
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_section_x = ''
let g:airline_section_y = airline#section#create_right(['filetype'])
let g:airline_section_z = airline#section#create([
            \ '%#__accent_bold#%3l%#__restore__#/%L', ' ',
            \ '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}', ' ',
            \ '%3p%%',
            \ ])
let g:gitgutter_map_keys = 0
let g:indentLine_fileType = ['c', 'cpp', 'python', 'sh']
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
runtime macros/sandwich/keymap/surround.vim           " Use vim-surround mappings
" }}}

" NEOVIM SPECIFIC {{{
if has("nvim")
    " Fuzzy finder (fzf)
    nnoremap <C-p> :Files<CR>
    nnoremap <leader>p :Rg<CR>
    nnoremap <leader>g :Commits<CR>
    nnoremap s :Buffers<CR>

    " Autocompletion (deoplete)
    let g:deoplete#enable_at_startup = 1                 " Run deoplete at startup
    call deoplete#custom#option('ignore_case', v:false)  " Case is not ignored
    call deoplete#custom#option('max_list', 10)          " Number of candidates

    " Language server protocol (languageclient-neovim)
    let g:LanguageClient_useVirtualText = "Diagnostics"
    let g:LanguageClient_serverCommands = {
        \ 'c': ['ccls'],
        \ 'cpp': ['ccls'],
        \ 'python': ['pyls'],
        \ 'sh': ['bash-language-server', 'start'],
        \ }
    nnoremap <F10> :call LanguageClient_contextMenu()<CR>
    nnoremap <leader>d :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>f :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>r :call LanguageClient#textDocument_references()<CR>
    vnoremap <leader>f :call LanguageClient#textDocument_rangeFormatting()<CR>

    " LaTeX (vimtex)
    let g:tex_flavor = "latex"              " Change default tex flavor
    let g:vimtex_quickfix_mode = 0          " Quickfix window stays closed
    let g:vimtex_view_method = 'zathura'    " Default PDF viewer
    let g:vimtex_compiler_progname = 'nvr'  " Path to nvim executable
    call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
endif
" }}}

" MAPPINGS {{{
" Disable mappings
nnoremap Q :echohl WarningMsg<bar>echo "WARNING: Caps Lock may be on"<bar>echohl None<CR>
nmap U Q
" Cycle between completion entries
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Exit insert mode
inoremap jj <ESC>
" Remove search highlights
nnoremap <C-l> :nohlsearch<CR>
" Toggle word wrap
nnoremap <F3> :set wrap!<bar>:set linebreak!<bar>:set breakindent!<CR>
" Toggle spell check
nnoremap <F4> :set spell!<CR>
" Reload buffers
nnoremap <F5> :checktime<CR>
" Scroll binding
nnoremap <F6> :set scrollbind!<CR>
" Toggle netrw
nnoremap <F9> :Lexplore<CR>
" Quickfix list
nnoremap <leader><Down> :cclose<CR>
nnoremap <leader><Left> :cprev<CR>
nnoremap <leader><Right> :cnext<CR>
nnoremap <leader><Up> :copen<CR>
" Resize window
nnoremap <S-Up> <C-w>2>
nnoremap <S-Down> <C-w>2<
" Close buffer (without closing window)
nnoremap <expr><leader>w len(getbufinfo("")[0].windows) > 1 ?
    \ ":close<CR>" :
    \ (bufnr("") == getbufinfo({"buflisted": 1})[-1].bufnr ? ":bp" : ":bn")."<bar>bd #<CR>"
" Quit
nnoremap <leader>i :confirm qall<CR>
" Insert blank new line
nnoremap <leader>o m`o<Esc>``
" Save buffer
nnoremap <leader>u :update<CR>
" Toggle fold
nnoremap <space> za
" Substitute
nnoremap S :%s//gc<Left><Left><Left>
vnoremap S :s//gc<Left><Left><Left>
" Move accross display lines
nnoremap j gj
nnoremap k gk
" Copy to system clipboard
vnoremap <leader>c "+y
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
colorscheme onedark                   " Color scheme
set background=dark                   " Dark background
set colorcolumn=80                    " Line length marker
set cursorline                        " Highlight current line
set list                              " Show trailing blanks
set listchars=tab:>\ ,trail:-,nbsp:+  " Strings to use in list
set nowrap                            " Disable wrap lines
set number relativenumber             " Relative line number
set scrolloff=4                       " Show lines of context
set signcolumn=yes                    " Show sign column
set termguicolors                     " True color support
" }}}

" INDENTATION {{{
set autoindent                        " Copy indentation from previous line
set backspace=indent,eol,start        " Intuitive backspacing in insert mode
set expandtab                         " Tabs are spaces
set pastetoggle=<F2>                  " Aid in pasting text
set shiftround                        " Round indent
set shiftwidth=4                      " Number of shifts
set smartindent                       " Automatically inserts indentation
set softtabstop=4                     " Number of spaces in tab when editing
set tabstop=4                         " Number of visual spaces per tab
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
