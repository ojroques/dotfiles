-- neovim config
-- github.com/ojroques

-------------------- INIT ----------------------------------
local fmt = string.format
local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', vim.fn.stdpath('data'))

if vim.fn.empty(vim.fn.glob(paq_dir)) > 0 then
  vim.fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir}
end

-------------------- PLUGINS -------------------------------
require 'paq' {
  {'airblade/vim-rooter'},
  {'elihunter173/dirbuf.nvim'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-omni'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/nvim-cmp'},
  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'l3mon4d3/luasnip'},
  {'lervag/vimtex'},
  {'lewis6991/gitsigns.nvim'},
  {'lukas-reineke/indent-blankline.nvim'},
  {'machakann/vim-sandwich'},
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
  {'ojroques/vim-oscyank'},
  {'savq/paq-nvim'},
  {'smiteshp/nvim-gps'},
  {'tpope/vim-commentary'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-unimpaired'},
}

-------------------- PLUGIN SETUP --------------------------
-- dirbuf.nvim
require('dirbuf').setup {hash_first = false, sort_order = 'directories_first'}
-- fzf and fzf.vim
vim.g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
vim.keymap.set('n', '<leader>/', '<cmd>History/<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>History:<CR>')
vim.keymap.set('n', '<leader>f', '<cmd>Files<CR>')
vim.keymap.set('n', '<leader>r', '<cmd>Rg<CR>')
vim.keymap.set('n', 's', '<cmd>Buffers<CR>')
-- gitsigns.nvim
local gitsigns = require('gitsigns')
gitsigns.setup {
  signs = {
    add = {text = '+'},
    change = {text = '~'},
    delete = {text = '-'}, topdelete = {text = '-'}, changedelete = {text = '≃'},
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', '<leader>gD', function() gitsigns.diffthis('~') end, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', '[c', gitsigns.prev_hunk, {buffer = bufnr})
    vim.keymap.set('n', ']c', gitsigns.next_hunk, {buffer = bufnr})
  end,
}
-- indent-blankline.nvim
require('indent_blankline').setup {
  char = '┊',
  buftype_exclude = {'terminal'},
  filetype_exclude = {'fugitive', 'fzf', 'help', 'man'},
}
-- nvim-bufbar
require('bufbar').setup {modifier = 'full', term_modifier = 'full', show_flags = false}
-- nvim-bufdel
require('bufdel').setup {next = 'alternate', quit = false}
vim.keymap.set('n', '<leader>w', '<cmd>BufDel<CR>')
-- nvim-buildme
vim.keymap.set('n', '<leader>bb', '<cmd>BuildMe<CR>')
vim.keymap.set('n', '<leader>bB', '<cmd>BuildMe!<CR>')
vim.keymap.set('n', '<leader>be', '<cmd>BuildMeEdit<CR>')
vim.keymap.set('n', '<leader>bs', '<cmd>BuildMeStop<CR>')
-- nvim-cmp
local cmp = require('cmp')
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
  snippet = {expand = function(args) require('luasnip').lsp_expand(args.body) end},
  sources = cmp.config.sources({
    {name = 'nvim_lsp'}, {name = 'omni'}, {name = 'path'}, {name = 'buffer'},
  }),
}
-- nvim-gps
require('nvim-gps').setup {disable_icons = true}
-- nvim-hardline
require('hardline').setup {}
-- nvim-lspfuzzy
require('lspfuzzy').setup {}
-- onedark.nvim
require('onedark').setup {code_style = {comments = 'none'}, toggle_style_key = '<NOP>'}
require('onedark').load()
-- vim-fugitive
vim.keymap.set('n', '<leader>gg', '<cmd>Git<CR>')
-- vim-rooter
vim.g['rooter_patterns'] = {'.buildme.sh', '.git'}
-- vim-sandwich
vim.g['operator_sandwich_no_default_key_mappings'] = true
vim.keymap.set('n', 'cs', '<Plug>(sandwich-replace)')
vim.keymap.set('n', 'ds', '<Plug>(sandwich-delete)')
vim.keymap.set('n', 'ys', '<Plug>(sandwich-add)')
-- vimtex
vim.g['vimtex_quickfix_mode'] = false

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80
vim.g.did_load_filetypes = 0            -- Disable filetype.vim
vim.g.do_filetype_lua = 1               -- Enable filetype.lua
vim.opt.colorcolumn = tostring(width)   -- Line length marker
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}  -- Completion options
vim.opt.cursorline = true               -- Highlight cursor line
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.ignorecase = true               -- Ignore case
vim.opt.inccommand = ''                 -- Disable substitution preview
vim.opt.list = true                     -- Show invisible characters
vim.opt.number = true                   -- Show line numbers
vim.opt.pumheight = 12                  -- Max height of pop-up menu
vim.opt.relativenumber = true           -- Show relative line numbers
vim.opt.report = 0                      -- Always report changed lines
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
vim.opt.wildmode = {'list:longest'}     -- Command completion options
vim.opt.wrap = false                    -- Disable line wrap

-------------------- MAPPINGS ------------------------------
function escape_term()
  return vim.bo.filetype == 'fzf' and '<ESC>' or '<C-\\><C-n>'
end

function substitute()
  local cmd = ':%s//gcI<Left><Left><Left><Left>'
  return vim.fn.mode() == 'n' and fmt(cmd, '%s') or fmt(cmd, 's')
end

function toggle_scrollbind()
  vim.wo.scrollbind = not vim.wo.scrollbind
  vim.api.nvim_echo({{fmt('scrollbind: %s', vim.wo.scrollbind)}}, false, {})
end

function toggle_wrap()
  vim.wo.breakindent = not vim.wo.breakindent
  vim.wo.linebreak = not vim.wo.linebreak
  vim.wo.wrap = not vim.wo.wrap
  vim.api.nvim_echo({{fmt('wrap: %s', vim.wo.wrap)}}, false, {})
end

function trim_whitespaces()
  local view = vim.fn.winsaveview()
  vim.cmd [[keeppatterns %s/\s\+$//e]]
  vim.fn.winrestview(view)
end

function warn_caps()
  vim.api.nvim_echo({{'Caps Lock may be on', 'WarningMsg'}}, false, {})
end

vim.keymap.set('', '<leader>c', '"+y')
vim.keymap.set('', '<leader>s', substitute, {expr = true})
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<C-w>T', '<cmd>tabclose<CR>')
vim.keymap.set('n', '<C-w>t', '<cmd>tabnew<CR>')
vim.keymap.set('n', '<F5>', '<cmd>checktime<CR>')
vim.keymap.set('n', '<S-Down>', '<C-w>2<')
vim.keymap.set('n', '<S-Left>', '<C-w>2-')
vim.keymap.set('n', '<S-Right>', '<C-w>2+')
vim.keymap.set('n', '<S-Up>', '<C-w>2>')
vim.keymap.set('n', '<leader>e', trim_whitespaces)
vim.keymap.set('n', '<leader>t', '<cmd>terminal<CR>')
vim.keymap.set('n', '<leader>u', '<cmd>update<CR>')
vim.keymap.set('n', '<leader>x', '<cmd>conf qa<CR>')
vim.keymap.set('n', 'U', warn_caps)
vim.keymap.set('n', 'yos', toggle_scrollbind)
vim.keymap.set('n', 'yow', toggle_wrap)
vim.keymap.set('t', '<ESC>', escape_term, {expr = true})
vim.keymap.set('t', 'jj', escape_term, {expr = true})

-------------------- LSP -----------------------------------
local cmp_cap = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, ls in ipairs({'bashls', 'clangd', 'gopls', 'pylsp'}) do
  require('lspconfig')[ls].setup {capabilities = cmp_cap}
end
vim.keymap.set('n', '<space>,', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<space>;', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<space>d', vim.lsp.buf.definition)
vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting)
vim.keymap.set('n', '<space>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<space>m', vim.lsp.buf.rename)
vim.keymap.set('n', '<space>r', vim.lsp.buf.references)
vim.keymap.set('n', '<space>s', vim.lsp.buf.document_symbol)

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

-------------------- AUTOCOMMANDS --------------------------
function init_term()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'
end

function process_yank()
  vim.highlight.on_yank {timeout = 200, on_visual = false}
  if vim.g.loaded_oscyank == 1 and vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
    vim.cmd 'OSCYankReg +'
  end
end

local group = 'init'
vim.api.nvim_create_augroup(group, {clear = true})
vim.api.nvim_create_autocmd('FileType', {group = group, command = 'set formatoptions-=o'})
vim.api.nvim_create_autocmd('TermOpen', {group = group, callback = init_term})
vim.api.nvim_create_autocmd('TextYankPost', {group = group, callback = process_yank})
