-- neovim config
-- github.com/ojroques

-------------------- HELPERS -------------------------------
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', vim.fn.stdpath('data'))
if vim.fn.empty(vim.fn.glob(paq_dir)) > 0 then
  vim.fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir}
end

require 'paq' {
  {'airblade/vim-rooter'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-omni'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/nvim-cmp'},
  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'justinmk/vim-dirvish'},
  {'lervag/vimtex'},
  {'lewis6991/gitsigns.nvim'},
  {'lukas-reineke/indent-blankline.nvim'},
  {'machakann/vim-sandwich'},
  {'nathom/filetype.nvim'},
  {'navarasu/onedark.nvim'},
  {'neovim/nvim-lspconfig'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  {'ojroques/nvim-bufbar', branch = 'personal'},
  {'ojroques/nvim-bufdel'},
  {'ojroques/nvim-buildme'},
  {'ojroques/nvim-hardline', branch = 'personal'},
  {'ojroques/nvim-lspfuzzy'},
  {'ojroques/nvim-scrollbar'},
  {'ojroques/vim-oscyank'},
  {'savq/paq-nvim'},
  {'smiteshp/nvim-gps'},
  {'tpope/vim-commentary'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-unimpaired'},
}

-------------------- PLUGIN SETUP --------------------------
-- fzf and fzf.vim
vim.g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
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
vim.g['indent_blankline_buftype_exclude'] = {'terminal'}
vim.g['indent_blankline_char'] = '┊'
vim.g['indent_blankline_filetype_exclude'] = {'fugitive', 'fzf', 'help', 'man'}
-- nvim-bufbar
require('bufbar').setup {show_bufname = 'visible', show_flags = false}
-- nvim-bufdel
require('bufdel').setup {next = 'alternate', quit = false}
map('n', '<leader>w', '<cmd>BufDel<CR>')
-- nvim-buildme
map('n', '<leader>bb', '<cmd>BuildMe<CR>')
map('n', '<leader>bB', '<cmd>BuildMe!<CR>')
map('n', '<leader>be', '<cmd>BuildMeEdit<CR>')
map('n', '<leader>bs', '<cmd>BuildMeStop<CR>')
-- nvim-cmp
local cmp = require('cmp')
local cmp_cap = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local menu = {buffer = '[Buf]', nvim_lsp = '[LSP]', omni = '[Omni]', path = '[Path]'}
local widths = {abbr = 80, kind = 40, menu = 40}
cmp.setup {
  completion = {keyword_length = 2},
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = vim_item.menu or menu[entry.source.name]
      for k, width in pairs(widths) do
        if #vim_item[k] > width then
          vim_item[k] = fmt('%s...', string.sub(vim_item[k], 1, width))
        end
      end
      return vim_item
    end,
  },
  mapping = {
    ['<Tab>'] = function(fb) if cmp.visible() then cmp.select_next_item() else fb() end end,
    ['<S-Tab>'] = function(fb) if cmp.visible() then cmp.select_prev_item() else fb() end end,
  },
  preselect = require('cmp.types').cmp.PreselectMode.None,
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'omni'},
    {name = 'path'},
    {name = 'buffer'},
  }),
}
-- nvim-gps
require('nvim-gps').setup {disable_icons = true}
-- nvim-hardline
require('hardline').setup()
-- nvim-lspfuzzy
require('lspfuzzy').setup {save_last = true}
map('n', '<space>l', '<cmd>LspFuzzyLast<CR>')
-- nvim-scrollbar
require('scrollbar').setup()
-- onedark.nvim
vim.g['onedark_italic_comment'] = false
vim.g['onedark_toggle_style_keymap'] = '<NOP>'
-- vim-dirvish
vim.g['dirvish_mode'] = [[:sort ,^.*[\/],]]
map('', '<leader>d', ':Shdo ')
-- vim-fugitive and git
local log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
map('n', '<leader>g<space>', ':Git ')
map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
map('n', '<leader>gg', '<cmd>Git<CR>')
map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>', log))
-- vim-sandwich
vim.cmd 'runtime macros/sandwich/keymap/surround.vim'
-- vimtex
vim.g['vimtex_quickfix_mode'] = false

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80
vim.opt.colorcolumn = tostring(width)   -- Line length marker
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options
vim.opt.cursorline = true               -- Highlight cursor line
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.formatoptions = 'crqnj'         -- Automatic formatting options
vim.opt.ignorecase = true               -- Ignore case
vim.opt.inccommand = ''                 -- Disable substitution preview
vim.opt.list = true                     -- Show some invisible characters
vim.opt.number = true                   -- Show line numbers
vim.opt.pastetoggle = '<F2>'            -- Paste mode
vim.opt.pumheight = 12                  -- Max height of popup menu
vim.opt.relativenumber = true           -- Relative line numbers
vim.opt.scrolloff = 4                   -- Lines of context
vim.opt.shiftround = true               -- Round indent
vim.opt.shiftwidth = indent             -- Size of an indent
vim.opt.shortmess = 'atToOFc'           -- Prompt message options
vim.opt.sidescrolloff = 8               -- Columns of context
vim.opt.signcolumn = 'yes'              -- Show sign column
vim.opt.smartcase = true                -- Do not ignore case with capitals
vim.opt.smartindent = true              -- Insert indents automatically
vim.opt.splitbelow = true               -- Put new windows below current
vim.opt.splitright = true               -- Put new windows right of current
vim.opt.tabstop = indent                -- Number of spaces tabs count for
vim.opt.termguicolors = true            -- True color support
vim.opt.textwidth = width               -- Maximum width of text
vim.opt.updatetime = 100                -- Delay before swap file is saved
vim.opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
vim.opt.wrap = false                    -- Disable line wrap
vim.cmd 'colorscheme onedark'

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')
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
map('n', 'U', '<cmd>lua warn_caps()<CR>')
map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
map('t', 'jj', '<ESC>', {noremap = false})
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-------------------- LSP -----------------------------------
local defaults = {capabilities = cmp_cap}
for ls, cfg in pairs({
  bashls = {}, gopls = {}, ccls = {}, jsonls = {}, pylsp = {},
}) do require('lspconfig')[ls].setup(vim.tbl_extend('keep', cfg, defaults)) end
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
    move = {
      enable = true,
      goto_next_start = {[']a'] = '@parameter.inner', [']f'] = '@function.outer'},
      goto_next_end = {[']A'] = '@parameter.inner', [']F'] = '@function.outer'},
      goto_previous_start = {['[a'] = '@parameter.inner', ['[f'] = '@function.outer'},
      goto_previous_end = {['[A'] = '@parameter.inner', ['[F'] = '@function.outer'},
    },
  },
}

-------------------- COMMANDS ------------------------------
function init_term()
  vim.cmd 'setlocal nonumber norelativenumber'
  vim.cmd 'setlocal nospell'
  vim.cmd 'setlocal signcolumn=auto'
end

function toggle_wrap()
  vim.wo.breakindent = not vim.wo.breakindent
  vim.wo.linebreak = not vim.wo.linebreak
  vim.wo.wrap = not vim.wo.wrap
end

function toggle_zoom()
  if zoomed then
    vim.cmd 'wincmd ='
    zoomed = false
  else
    vim.cmd 'resize'
    vim.cmd 'vertical resize'
    zoomed = true
  end
end

function warn_caps()
  vim.cmd 'echohl WarningMsg'
  vim.cmd 'echo "Caps Lock may be on"'
  vim.cmd 'echohl None'
end

vim.tbl_map(function(c) vim.cmd(fmt('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | execute "OSCYankReg +" | endif',
  'TextYankPost * lua vim.highlight.on_yank {timeout = 200, on_visual = false}',
})
