-- neovim config
-- github.com/ojroques

-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'airblade/vim-gitgutter'}
paq {'airblade/vim-rooter'}
paq {'joshdick/onedark.vim'}
paq {'junegunn/fzf'}
paq {'junegunn/fzf.vim'}
paq {'justinmk/vim-dirvish'}
paq {'kosayoda/nvim-lightbulb'}
paq {'lervag/vimtex'}
paq {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}
paq {'machakann/vim-sandwich'}
paq {'michaeljsmith/vim-indent-object'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'ojroques/nvim-bufbar'}
paq {'ojroques/nvim-bufdel'}
paq {'ojroques/nvim-buildme'}
paq {'ojroques/nvim-hardline'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'ojroques/vim-oscyank'}
paq {'savq/paq-nvim', opt = true}
paq {'shougo/deoplete-lsp'}
paq {'shougo/deoplete.nvim'}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-fugitive'}

-------------------- PLUGIN SETUP --------------------------
-- bufbar
require('bufbar').setup {show_bufname = 'visible', show_flags = false}
-- bufdel
map('n', '<leader>w', '<cmd>BufDel<CR>')
require('bufdel').setup {next = 'alternate'}
-- buildme
map('n', '<leader>bb', '<cmd>BuildMe<CR>')
map('n', '<leader>be', '<cmd>BuildMeEdit<CR>')
map('n', '<leader>bs', '<cmd>BuildMeStop<CR>')
-- deoplete
g['deoplete#enable_at_startup'] = 1
fn['deoplete#custom#option']('ignore_case', false)
fn['deoplete#custom#option']('max_list', 10)
-- dirvish
g['dirvish_mode'] = [[:sort ,^.*[\/],]]
-- fzf
map('n', '<leader>f', '<cmd>Files<CR>')
map('n', '<leader>g', '<cmd>Commits<CR>')
map('n', '<leader>r', '<cmd>Rg<CR>')
map('n', 's', '<cmd>Buffers<CR>')
g['fzf_action'] = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit',
}
-- hardline
require('hardline').setup {}
-- indent-blankline
g['indent_blankline_char'] = '┊'
g['indent_blankline_buftype_exclude'] = {'terminal'}
g['indent_blankline_filetype_exclude'] = {'fzf', 'help', 'man'}
g['indent_blankline_show_current_context'] = true
-- lightbulb
cmd 'au CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()'
-- vim-sandwich
cmd 'runtime macros/sandwich/keymap/surround.vim'
-- vimtex
g['vimtex_quickfix_mode'] = 0
g['vimtex_view_method'] = 'zathura'
cmd 'au VimEnter * call deoplete#custom#var("omni", "input_patterns", {"tex": g:vimtex#re#deoplete})'

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80
cmd 'colorscheme onedark'
opt('b', 'expandtab', true)               -- Use spaces instead of tabs
opt('b', 'formatoptions', 'crqnj')        -- Automatic formatting options
opt('b', 'shiftwidth', indent)            -- Size of an indent
opt('b', 'smartindent', true)             -- Insert indents automatically
opt('b', 'tabstop', indent)               -- Number of spaces tabs count for
opt('b', 'textwidth', width)              -- Maximum width of text
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options
opt('o', 'hidden', true)                  -- Enable background buffers
opt('o', 'ignorecase', true)              -- Ignore case
opt('o', 'joinspaces', false)             -- No double spaces with join
opt('o', 'pastetoggle', '<F2>')           -- Paste mode
opt('o', 'scrolloff', 4 )                 -- Lines of context
opt('o', 'shiftround', true)              -- Round indent
opt('o', 'sidescrolloff', 8 )             -- Columns of context
opt('o', 'smartcase', true)               -- Don't ignore case with capitals
opt('o', 'splitbelow', true)              -- Put new windows below current
opt('o', 'splitright', true)              -- Put new windows right of current
opt('o', 'termguicolors', true)           -- True color support
opt('o', 'updatetime', 100)               -- Delay before swap file is saved
opt('o', 'wildmode', 'list:longest')      -- Command-line completion mode
opt('w', 'colorcolumn', tostring(width))  -- Line length marker
opt('w', 'cursorline', true)              -- Highlight cursor line
opt('w', 'list', true)                    -- Show some invisible characters
opt('w', 'number', true)                  -- Show line numbers
opt('w', 'relativenumber', true)          -- Relative line numbers
opt('w', 'signcolumn', 'yes')             -- Show sign column
opt('w', 'wrap', false)                   -- Disable line wrap

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')
map('i', '<C-u>', '<C-g>u<C-u>')
map('i', '<C-w>', '<C-g>u<C-w>')
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', 'jj', '<ESC>')
map('n', '<C-l>', '<cmd>nohlsearch<CR>')
map('n', '<C-w>T', '<cmd>tabclose<CR>')
map('n', '<C-w>t', '<cmd>tabnew<CR>')
map('n', '<F3>', '<cmd>lua toggle_wrap()<CR>')
map('n', '<F4>', '<cmd>set spell!<CR>')
map('n', '<F5>', '<cmd>checktime<CR>')
map('n', '<F6>', '<cmd>set scrollbind!<CR>')
map('n', '<S-Down>', '<C-w>2<')
map('n', '<S-Left>', '<C-w>2-')
map('n', '<S-Right>', '<C-w>2+')
map('n', '<S-Up>', '<C-w>2>')
map('n', '<leader><Down>', '<cmd>cclose<CR>')
map('n', '<leader><Left>', '<cmd>cprev<CR>')
map('n', '<leader><Right>', '<cmd>cnext<CR>')
map('n', '<leader><Up>', '<cmd>copen<CR>')
map('n', '<leader>o', 'm`o<Esc>0D``')
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>')
map('n', '<leader>t', '<cmd>terminal<CR>')
map('n', '<leader>u', '<cmd>update<CR>')
map('n', '<leader>x', '<cmd>conf qa<CR>')
map('n', 'Q', '<cmd>lua warn_caps()<CR>')
map('n', 'S', '<cmd>bn<CR>')
map('n', 'U', '<cmd>lua warn_caps()<CR>')
map('n', 'X', '<cmd>bp<CR>')
map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
map('t', 'jj', '<ESC>', {noremap = false})
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-------------------- LSP -----------------------------------
local lsp = require('lspconfig')
local lspfuzzy = require('lspfuzzy')
for ls, cfg in pairs({
  bashls = {},
  ccls = {},
  jsonls = {},
  pyls = {root_dir = lsp.util.root_pattern('.git', fn.getcwd())},
}) do lsp[ls].setup(cfg) end
lspfuzzy.setup {}
map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- COMMANDS ------------------------------
function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end

function toggle_wrap()
  opt('w', 'breakindent', not vim.wo.breakindent)
  opt('w', 'linebreak', not vim.wo.linebreak)
  opt('w', 'wrap', not vim.wo.wrap)
end

function warn_caps()
  cmd 'echohl WarningMsg'
  cmd 'echo "Caps Lock may be on"'
  cmd 'echohl None'
end

vim.tbl_map(function(c) cmd(string.format('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | OSCYankReg + | endif',
})
