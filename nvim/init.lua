-- neovim config
-- github.com/ojroques

-- HELPERS
local api, cmd, fn = vim.api, vim.cmd, vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then for k, v in pairs(opts) do options[k] = v end end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- PLUGINS
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq 'airblade/vim-gitgutter'
paq 'airblade/vim-rooter'
paq 'joshdick/onedark.vim'
paq 'junegunn/fzf'
paq 'junegunn/fzf.vim'
paq 'lervag/vimtex'
paq 'machakann/vim-sandwich'
paq 'neovim/nvim-lspconfig'
paq 'nvim-treesitter/nvim-treesitter'
paq 'ojroques/nvim-lspfuzzy'
paq 'ojroques/vim-oscyank'
paq 'shougo/deoplete-lsp'
paq 'shougo/deoplete.nvim'
paq 'tpope/vim-commentary'
paq 'tpope/vim-fugitive'
paq 'vim-airline/vim-airline'
paq 'yggdroot/indentLine'
paq {'savq/paq-nvim', opt = true}

-- PLUGIN CONFIGURATION
-- airline
g['airline#extensions#tabline#enabled'] = 1
g['airline#extensions#tabline#fnamemod'] = ':p:t'
g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
g['airline_section_x'] = ''
g['airline_section_y'] = fn['airline#section#create_right'] {'filetype'}
g['airline_section_z'] = fn['airline#section#create'] {
  '%#__accent_bold#%3l%#__restore__#/%L', ' ',
  '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}', ' ',
  '%3p%%',
}
-- deoplete
o.completeopt = 'menuone,noinsert,noselect'
g['deoplete#enable_at_startup'] = 1
fn['deoplete#custom#option']('ignore_case', false)
fn['deoplete#custom#option']('max_list', 10)
-- fzf
map('n', '<C-p>', '<cmd>Files<CR>')
map('n', '<leader>g', '<cmd>Commits<CR>')
map('n', '<leader>p', '<cmd>Rg<CR>')
map('n', 's', '<cmd>Buffers<CR>')
-- gitgutter
g['gitgutter_map_keys'] = 0
-- indentline
g['indentLine_fileType'] = {'c', 'cpp', 'lua', 'python', 'sh'}
-- netrw
g['netrw_banner'] = 0
g['netrw_liststyle'] = 3
g['netrw_winsize'] = 20
-- vim-sandwich
cmd 'runtime macros/sandwich/keymap/surround.vim'
-- vimtex
g['vimtex_quickfix_mode'] = 0
g['vimtex_view_method'] = 'zathura'

-- OPTIONS
local indent = 2
cmd 'colorscheme onedark'
bo.expandtab = true               -- Use spaces instead of tabs
bo.shiftwidth = indent            -- Size of an indent
bo.smartindent = true             -- Insert indents automatically
bo.tabstop = indent               -- Number of spaces tabs count for
o.hidden = true                   -- Enable background buffers
o.ignorecase = true               -- Ignore case
o.joinspaces = false              -- No double spaces after a dot with join
o.pastetoggle = '<F2>'            -- Paste mode
o.scrolloff = 4                   -- Lines of context
o.shiftround = true               -- Round indent
o.sidescrolloff = 8               -- Columns of context
o.smartcase = true                -- Don't ignore case with capital letters
o.splitbelow = true               -- Put new windows below current one
o.splitright = true               -- Put new windows right of current one
o.termguicolors = true            -- True color support
o.updatetime = 100                -- Delay before swap file is saved
o.wildmode = 'longest:full,full'  -- Command-line completion mode
wo.colorcolumn = '80'             -- Line length marker
wo.cursorline = true              -- Highlight cursor line
wo.list = true                    -- Show invisible characters
wo.number = true                  -- Print line number
wo.relativenumber = true          -- Relative line numbers
wo.signcolumn = 'yes'             -- Show sign column
wo.wrap = false                   -- Disable line wrap

-- MAPPINGS
map('', '<leader>c', '"+y')
map('i', '<C-u>', '<C-g>u<C-u>')
map('i', '<C-w>', '<C-g>u<C-w>')
map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', {expr = true})
map('i', 'jj', '<ESC>')
map('n', '<C-l>', '<cmd>noh<CR>')
map('n', '<F3>', '<cmd>lua toggle_wrap()<CR>')
map('n', '<F4>', '<cmd>set spell!<CR>')
map('n', '<F5>', '<cmd>checkt<CR>')
map('n', '<F6>', '<cmd>set scb!<CR>')
map('n', '<F9>', '<cmd>Lexplore<CR>')
map('n', '<S-Down>', '<C-w>2<')
map('n', '<S-Left>', '<C-w>2-')
map('n', '<S-Right>', '<C-w>2+')
map('n', '<S-Up>', '<C-w>2>')
map('n', '<leader><Down>', '<cmd>cclose<CR>')
map('n', '<leader><Left>', '<cmd>cprev<CR>')
map('n', '<leader><Right>', '<cmd>cnext<CR>')
map('n', '<leader><Up>', '<cmd>copen<CR>')
map('n', '<leader><space>', 'za')
map('n', '<leader>i', '<cmd>conf qa<CR>')
map('n', '<leader>o', 'm`o<Esc>``')
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>')
map('n', '<leader>u', '<cmd>update<CR>')
map('n', '<leader>w', '<cmd>lua close_buffer()<CR>')
map('n', 'Q', '<cmd>lua warn_caps_lock()<CR>')
map('n', 'S', '<cmd>bn<CR>')
map('n', 'U', '<cmd>lua warn_caps_lock()<CR>')
map('n', 'X', '<cmd>bp<CR>')
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-- LSP
local lsp = require 'lspconfig'
local lspconfigs = require'lspconfig/configs'
local lspfuzzy = require'lspfuzzy'
lspconfigs.luals = {
  default_config = {
    cmd = {'lua-lsp'},
    filetypes = {'lua'},
    root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
  }
}
lsp.bashls.setup {}
lsp.ccls.setup {}
lsp.jsonls.setup {}
lsp.luals.setup {}
lsp.pyls.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
lspfuzzy.setup {}
map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-- TREE-SITTER
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-- AUTOCOMMANDS & FUNCTIONS
function close_buffer()
  if #fn.getbufinfo('')[1]['windows'] > 1 then cmd 'close'; return end
  local buflisted = fn.getbufinfo {buflisted = 1}
  local last_bufnr = buflisted[#buflisted]['bufnr']
  if fn.bufnr '' == last_bufnr then cmd 'bp' else cmd 'bn' end
  cmd 'bd #'
end

function toggle_wrap()
  wo.wrap = not wo.wrap
  wo.linebreak = not wo.linebreak
  wo.breakindent = not wo.breakindent
end

function warn_caps_lock()
  cmd 'echohl WarningMsg'
  cmd 'echo "Caps Lock may be on"'
  cmd 'echohl None'
end

cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'
cmd 'au TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | call YankOSC52(getreg("+")) | endif'
