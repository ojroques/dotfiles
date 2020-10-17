" neovim config
" github.com/ojroques
" vim: foldmethod=marker foldlevel=1

" PLUGINS {{{
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'machakann/vim-sandwich'
Plug 'sheerun/vim-polyglot'
Plug 'shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'yggdroot/indentLine'
call plug#end()
" }}}

" PLUGIN CONFIGURATION {{{
" airline
let g:airline#extensions#tabline#enabled = 1        " Display all buffers
let g:airline#extensions#tabline#fnamemod = ':p:t'  " Buffer naming scheme
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_section_x = ''
let g:airline_section_y = airline#section#create_right(['filetype'])
let g:airline_section_z = airline#section#create([
      \ '%#__accent_bold#%3l%#__restore__#/%L', ' ',
      \ '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}', ' ',
      \ '%3p%%',
      \ ])
" deoplete
let g:deoplete#enable_at_startup = 1                 " Run deoplete at startup
call deoplete#custom#option('ignore_case', v:false)  " Case is not ignored
call deoplete#custom#option('max_list', 10)          " Number of candidates
" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>p :Rg<CR>
nnoremap <leader>g :Commits<CR>
nnoremap s :Buffers<CR>
" gitgutter
let g:gitgutter_map_keys = 0  " Disable all mappings
" indentline
let g:indentLine_fileType = ['c', 'cpp', 'python', 'sh']
" languageclient-neovim
let g:LanguageClient_useVirtualText = "Diagnostics"
let g:LanguageClient_fzfOptions = [
      \ '--delimiter', ':', '--preview-window', '+{2}-6',
      \ '--preview', '~/.config/nvim/plugged/fzf.vim/bin/preview.sh {}'
      \ ]
let g:LanguageClient_serverCommands = {
      \ 'c': ['ccls'], 'cpp': ['ccls'],
      \ 'json': ['vscode-json-languageserver', '--stdio'],
      \ 'python': ['pyls'],
      \ 'sh': ['bash-language-server', 'start'],
      \ }
nmap <F10> <Plug>(lcn-menu)
nmap <leader>d <Plug>(lcn-definition)
nmap <leader>e <Plug>(lcn-explain-error)
nmap <leader>f <Plug>(lcn-format)
nmap <leader>h <Plug>(lcn-hover)
nmap <leader>r <Plug>(lcn-references)
nmap <leader>y <Plug>(lcn-symbols)
vnoremap <leader>f :call LanguageClient#textDocument_rangeFormatting()<CR>
" netrw
let g:netrw_banner = 0     " Suppress the banner
let g:netrw_liststyle = 3  " Tree style listing
let g:netrw_winsize = 20   " Window size
" vim-sandwich
runtime macros/sandwich/keymap/surround.vim  " Use vim-surround mappings
" vimtex
let g:tex_flavor = "latex"              " Change default tex flavor
let g:vimtex_quickfix_mode = 0          " Disable quickfix window popup
let g:vimtex_view_method = 'zathura'    " Default PDF viewer
let g:vimtex_compiler_progname = 'nvr'  " Path to nvim executable
call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
" }}}

" MAPPINGS {{{
" Disable mappings
nnoremap Q :echohl WarningMsg<bar>echo "WARNING: Caps Lock may be on"<bar>echohl None<CR>
nmap U Q
" Break undo sequence
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
" Cycle between completion entries
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
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
" Resize window
nnoremap <S-Up> <C-w>2>
nnoremap <S-Down> <C-w>2<
nnoremap <S-Left> <C-w>2-
nnoremap <S-Right> <C-w>2+
" Quickfix list
nnoremap <leader><Up> :copen<CR>
nnoremap <leader><Down> :cclose<CR>
nnoremap <leader><Left> :cprev<CR>
nnoremap <leader><Right> :cnext<CR>
" Close buffer (without closing window)
nnoremap <expr><leader>w len(getbufinfo("")[0].windows) > 1 ?
      \ ":close<CR>" :
      \ (bufnr("") == getbufinfo({"buflisted": 1})[-1].bufnr ? ":bp" : ":bn")."<bar>bd #<CR>"
" Close all buffers except current
nnoremap <leader>W :%bd<bar>e #<bar>bd #<bar>normal `"<CR>
" Quit
nnoremap <leader>i :confirm qall<CR>
" Insert blank new line
nnoremap <leader>o m`o<Esc>``
" Save buffer
nnoremap <leader>u :update<CR>
" Substitute
nnoremap <leader>s :%s//gcI<Left><Left><Left><Left>
vnoremap <leader>s :s//gcI<Left><Left><Left><Left>
" Toggle fold
nnoremap <space> za
" Next and previous buffer
nnoremap S :bn<CR>
nnoremap X :bp<CR>
" Copy to system clipboard
vnoremap <leader>c "+y
" }}}

" GENERAL {{{
filetype plugin indent on
syntax enable
colorscheme onedark
set colorcolumn=80              " Line length marker
set completeopt=menu,longest    " Insert mode completion
set cursorline                  " Highlight current line
set expandtab                   " Use spaces instead of tabs
set hidden                      " Enable background buffers
set ignorecase                  " Ignore case
set list                        " List mode
set nowrap                      " Disable line wrap
set number relativenumber       " Relative line number
set pastetoggle=<F2>            " Paste mode
set shiftround                  " Round indent
set shiftwidth=2                " Number of spaces when indenting
set sidescrolloff=10            " Columns of context
set signcolumn=yes              " Show sign column
set smartcase                   " Do not ignore case with uppercase character
set smartindent                 " Insert indents automatically
set softtabstop=2               " Number of spaces for tabs when editing
set splitbelow splitright       " Change position of new windows
set tabstop=2                   " Number of spaces tabs count for
set termguicolors               " True color support
set updatetime=100              " Delay before swap file is saved
set wildmode=longest:full,full  " Command-line completion mode
" }}}
