-- neovim config
-- github.com/ojroques

-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', fn.stdpath('data'))
if fn.empty(fn.glob(paq_dir)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir})
end

require 'paq' {
  {'airblade/vim-rooter'},
  {'hrsh7th/nvim-compe'},
  {'joshdick/onedark.vim'},
  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'justinmk/vim-dirvish'},
  {'lervag/vimtex'},
  {'lewis6991/gitsigns.nvim'},
  {'lukas-reineke/indent-blankline.nvim'},
  {'machakann/vim-sandwich'},
  {'neovim/nvim-lspconfig'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  {'ojroques/nvim-bufbar'},
  {'ojroques/nvim-bufdel'},
  {'ojroques/nvim-buildme'},
  {'ojroques/nvim-hardline', branch = 'personal'},
  {'ojroques/nvim-lspfuzzy'},
  {'ojroques/vim-oscyank'},
  {'savq/paq-nvim'},
  {'smiteshp/nvim-gps'},
  {'terrortylor/nvim-comment'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-unimpaired'},
}

-------------------- PLUGIN SETUP --------------------------
-- fzf and fzf.vim
g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
map('n', '<leader>/', '<cmd>History/<CR>')
map('n', '<leader>;', '<cmd>History:<CR>')
map('n', '<leader>f', '<cmd>Files<CR>')
map('n', '<leader>r', '<cmd>Rg<CR>')
map('n', 's', '<cmd>Buffers<CR>')
-- gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add = {text = '+'},
    change = {text = '~'},
    delete = {text = '-'}, topdelete = {text = '-'}, changedelete = {text = '≃'},
  },
}
-- indent-blankline.nvim
g['indent_blankline_char'] = '┊'
g['indent_blankline_buftype_exclude'] = {'terminal'}
g['indent_blankline_filetype_exclude'] = {'fugitive', 'fzf', 'help', 'man'}
-- nvim-bufbar
require('bufbar').setup {show_bufname = 'visible', show_flags = false}
-- nvim-bufdel
require('bufdel').setup {next = 'alternate', quit = false}
map('n', '<leader>w', '<cmd>BufDel<CR>')
-- nvim-buildme
map('n', '<leader>bb', '<cmd>BuildMe<CR>')
map('n', '<leader>be', '<cmd>BuildMeEdit<CR>')
map('n', '<leader>bs', '<cmd>BuildMeStop<CR>')
-- nvim-comment
require('nvim_comment').setup()
-- nvim-compe
require('compe').setup {
  min_length = 2,
  preselect = 'disable',
  max_abbr_width = 80, max_kind_width = 40, max_menu_width = 40,
  source = {buffer = true, path = true, nvim_lsp = true, omni = {filetypes = {'tex'}}},
}
-- nvim-gps
require("nvim-gps").setup {icons = {["class-name"] = '', ["function-name"] = '', ["method-name"] = ''}}
-- nvim-hardline
require('hardline').setup()
-- nvim-lspfuzzy
require('lspfuzzy').setup {save_last = true}
map('n', '<space>l', '<cmd>LspFuzzyLast<CR>')
-- vim-dirvish
g['dirvish_mode'] = [[:sort ,^.*[\/],]]
map('', '<leader>d', ':Shdo ')
-- vim-fugitive and git
local log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
map('n', '<leader>g<space>', ':Git ')
map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
map('n', '<leader>gg', '<cmd>Git<CR>')
map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>', log))
-- vim-sandwich
cmd 'runtime macros/sandwich/keymap/surround.vim'
-- vimtex
g['vimtex_quickfix_mode'] = false

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80
opt.colorcolumn = tostring(width)   -- Line length marker
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options
opt.cursorline = true               -- Highlight cursor line
opt.expandtab = true                -- Use spaces instead of tabs
opt.formatoptions = 'crqnj'         -- Automatic formatting options
opt.ignorecase = true               -- Ignore case
opt.inccommand = ''                 -- Disable substitution preview
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.pastetoggle = '<F2>'            -- Paste mode
opt.pumheight = 12                  -- Max height of popup menu
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = indent             -- Size of an indent
opt.shortmess = 'atToOFc'           -- Prompt message options
opt.sidescrolloff = 8               -- Columns of context
opt.signcolumn = 'yes'              -- Show sign column
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = indent                -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.textwidth = width               -- Maximum width of text
opt.updatetime = 100                -- Delay before swap file is saved
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
cmd 'colorscheme onedark'

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', 'jj', '<ESC>')
map('n', '<C-w>T', '<cmd>tabclose<CR>')
map('n', '<C-w>m', '<cmd>lua toggle_zoom()<CR>')
map('n', '<C-w>t', '<cmd>tabnew<CR>')
map('n', '<F3>', ':lua toggle_wrap()<CR>')
map('n', '<F4>', ':set scrollbind!<CR>')
map('n', '<F5>', ':checktime<CR>')
map('n', '<S-Down>', '<C-w>2<')
map('n', '<S-Left>', '<C-w>2-')
map('n', '<S-Right>', '<C-w>2+')
map('n', '<S-Up>', '<C-w>2>')
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>')
map('n', '<leader>t', '<cmd>terminal<CR>')
map('n', '<leader>u', '<cmd>update<CR>')
map('n', '<leader>x', '<cmd>conf qa<CR>')
map('n', 'Q', '<cmd>lua warn_caps()<CR>')
map('n', 'U', '<cmd>lua warn_caps()<CR>')
map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
map('t', 'jj', '<ESC>', {noremap = false})
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-------------------- LSP -----------------------------------
for ls, cfg in pairs({
  bashls = {}, gopls = {}, ccls = {}, jsonls = {}, pylsp = {},
}) do require('lspconfig')[ls].setup(cfg) end
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
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['aa'] = '@parameter.outer', ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer', ['if'] = '@function.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {['<leader>a'] = '@parameter.inner'},
      swap_previous = {['<leader>A'] = '@parameter.inner'},
    },
    move = {
      enable = true,
      goto_next_start = {[']a'] = '@parameter.outer', [']f'] = '@function.outer'},
      goto_next_end = {[']A'] = '@parameter.outer', [']F'] = '@function.outer'},
      goto_previous_start = {['[a'] = '@parameter.outer', ['[f'] = '@function.outer'},
      goto_previous_end = {['[A'] = '@parameter.outer', ['[F'] = '@function.outer'},
    },
  },
}

-------------------- COMMANDS ------------------------------
function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end

function toggle_wrap()
  wo.breakindent = not wo.breakindent
  wo.linebreak = not wo.linebreak
  wo.wrap = not wo.wrap
end

function toggle_zoom()
  if zoomed then
    cmd 'wincmd ='
    zoomed = false
  else
    cmd 'resize'
    cmd 'vertical resize'
    zoomed = true
  end
end

function warn_caps()
  cmd 'echohl WarningMsg'
  cmd 'echo "Caps Lock may be on"'
  cmd 'echohl None'
end

vim.tbl_map(function(c) cmd(fmt('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | execute "OSCYankReg +" | endif',
  'TextYankPost * lua vim.highlight.on_yank {timeout = 200, on_visual = false}',
})
