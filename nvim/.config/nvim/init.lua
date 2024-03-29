-------------------- INIT ----------------------------------
local fmt = string.format
local paq_dir = fmt('%s/site/pack/paqs/start/paq-nvim', vim.fn.stdpath('data'))

if vim.fn.empty(vim.fn.glob(paq_dir)) > 0 then
  vim.api.nvim_echo({{'Paq package manager is being installed'}}, false, {})
  vim.fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_dir}
  return
end

-------------------- PLUGINS -------------------------------
require 'paq' {
  {'airblade/vim-rooter'},
  {'elihunter173/dirbuf.nvim'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/nvim-cmp'},
  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'kylechui/nvim-surround'},
  {'lewis6991/gitsigns.nvim'},
  {'lukas-reineke/indent-blankline.nvim'},
  {'navarasu/onedark.nvim'},
  {'neovim/nvim-lspconfig'},
  {'numtostr/comment.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-treesitter/nvim-treesitter-context'},
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  {'ojroques/nvim-bufbar', branch = 'personal'},
  {'ojroques/nvim-bufdel'},
  {'ojroques/nvim-buildme'},
  {'ojroques/nvim-hardline', branch = 'personal'},
  {'ojroques/nvim-lspfuzzy'},
  {'savq/paq-nvim'},
  {'tpope/vim-unimpaired'},
}

-------------------- PLUGIN SETUP --------------------------
-- comment.nvim
require('Comment').setup({mappings = {extra = false}})
-- dirbuf.nvim
require('dirbuf').setup {sort_order = 'directories_first', write_cmd = 'DirbufSync -confirm'}
-- fzf and fzf.vim
vim.g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
vim.g['fzf_layout'] = {window = {width = 0.8, height = 0.8}}
vim.g['fzf_preview_window'] = {'up:50%:+{2}-/2', 'ctrl-/'}
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
    vim.keymap.set('n', '<leader>g,', gitsigns.prev_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>g;', gitsigns.next_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gD', function() gitsigns.diffthis('~') end, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, {buffer = bufnr})
  end,
}
-- indent-blankline.nvim
require('ibl').setup {indent = {char = '┊'}}
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
local menu = {buffer = '[Buf]', nvim_lsp = '[LSP]', path = '[Path]'}
local widths = {abbr = 80, kind = 40, menu = 40}
cmp.setup {
  completion = {keyword_length = 2},
  formatting = {
    format = function(entry, item)
      item.menu = item.menu or menu[entry.source.name]
      for k, width in pairs(widths) do
        if #item[k] > width then item[k] = fmt('%s...', string.sub(item[k], 1, width)) end
      end
      return item
    end,
  },
  mapping = {
    ['<Tab>'] = function(fb) if cmp.visible() then cmp.select_next_item() else fb() end end,
    ['<S-Tab>'] = function(fb) if cmp.visible() then cmp.select_prev_item() else fb() end end,
  },
  preselect = require('cmp.types').cmp.PreselectMode.None,
  sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'path'}, {name = 'buffer'}}),
}
-- nvim-hardline
require('hardline').setup {}
-- nvim-lspfuzzy
require('lspfuzzy').setup {}
-- nvim-surround
require('nvim-surround').setup {}
-- nvim-treesitter-context
require('treesitter-context').setup {mode = 'topline'}
-- onedark.nvim
local colors = require('onedark.palette').dark
require('onedark').setup {
  code_style = {comments = 'none'},
  highlights = {TreesitterContext = {bg = colors.bg1, fmt = 'italic'}},
}
require('onedark').load()
-- vim-rooter
vim.g['rooter_patterns'] = {'.buildme.sh', '.git'}

-------------------- OPTIONS -------------------------------
local indent, width = 2, 80
vim.opt.colorcolumn = tostring(width)    -- Line length marker
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}  -- Completion options
vim.opt.cursorline = true                -- Highlight cursor line
vim.opt.diffopt:append {'linematch:60'}  -- Improve diff mode
vim.opt.expandtab = true                 -- Use spaces instead of tabs
vim.opt.ignorecase = true                -- Ignore case
vim.opt.inccommand = ''                  -- Disable substitution preview
vim.opt.list = true                      -- Show invisible characters
vim.opt.mouse = ''                       -- Disable mouse
vim.opt.number = true                    -- Show line numbers
vim.opt.pumheight = 12                   -- Max height of pop-up menu
vim.opt.relativenumber = true            -- Show relative line numbers
vim.opt.report = 0                       -- Always report changed lines
vim.opt.scrolloff = 4                    -- Lines of context
vim.opt.shiftround = true                -- Round indent
vim.opt.shiftwidth = indent              -- Size of an indent
vim.opt.shortmess = 'atToOFc'            -- Prompt message options
vim.opt.sidescrolloff = 12               -- Columns of context
vim.opt.signcolumn = 'yes'               -- Show sign column
vim.opt.smartcase = true                 -- Do not ignore case with capitals
vim.opt.smartindent = true               -- Insert indents automatically
vim.opt.splitbelow = true                -- Put new windows below current
vim.opt.splitright = true                -- Put new windows right of current
vim.opt.tabstop = indent                 -- Number of spaces tabs count for
vim.opt.termguicolors = true             -- True color support
vim.opt.textwidth = width                -- Maximum width of text
vim.opt.updatetime = 100                 -- Delay before swap file is saved
vim.opt.wildmode = {'list:longest'}      -- Command completion options
vim.opt.wrap = false                     -- Disable line wrap

-------------------- MAPPINGS ------------------------------
local function substitute()
  local cmd = ':%s//gcI<Left><Left><Left><Left>'
  return vim.fn.mode() == 'n' and fmt(cmd, '%s') or fmt(cmd, 's')
end

local function toggle_wrap()
  vim.wo.breakindent = not vim.wo.breakindent
  vim.wo.linebreak = not vim.wo.linebreak
  vim.wo.wrap = not vim.wo.wrap
end

local function trim_whitespaces()
  local view = vim.fn.winsaveview()
  vim.cmd [[keeppatterns %s/\s\+$//e]]
  vim.fn.winrestview(view)
end

vim.keymap.set('', '<leader>c', '"+y')
vim.keymap.set('', '<leader>s', substitute, {expr = true})
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<S-Down>', '<C-w>2<')
vim.keymap.set('n', '<S-Left>', '<C-w>2-')
vim.keymap.set('n', '<S-Right>', '<C-w>2+')
vim.keymap.set('n', '<S-Up>', '<C-w>2>')
vim.keymap.set('n', '<leader>cc', '"+yy')
vim.keymap.set('n', '<leader>e', trim_whitespaces)
vim.keymap.set('n', '<leader>u', '<cmd>update<CR>')
vim.keymap.set('n', '<leader>x', '<cmd>conf qa<CR>')
vim.keymap.set('n', 'H', 'zh')
vim.keymap.set('n', 'L', 'zl')
vim.keymap.set('n', 'yow', toggle_wrap)
vim.keymap.set('t', 'jj', '<ESC>')

-------------------- LSP -----------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
for _, ls in ipairs({'bashls', 'clangd', 'gopls', 'pylsp', 'tsserver'}) do
  require('lspconfig')[ls].setup {capabilities = capabilities}
end
vim.keymap.set('n', '<space>,', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<space>;', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<space>d', vim.lsp.buf.definition)
vim.keymap.set('n', '<space>f', vim.lsp.buf.format)
vim.keymap.set('n', '<space>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<space>i', vim.lsp.buf.implementation)
vim.keymap.set('n', '<space>m', vim.lsp.buf.rename)
vim.keymap.set('n', '<space>r', vim.lsp.buf.references)
vim.keymap.set('n', '<space>s', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<space>t', vim.lsp.buf.type_definition)

-------------------- TREE-SITTER ---------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
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
      goto_previous_start = {['[a'] = '@parameter.inner', ['[f'] = '@function.outer'},
    },
  },
}

-------------------- AUTOCOMMANDS --------------------------
local group = 'init'
vim.api.nvim_create_augroup(group, {clear = true})
vim.api.nvim_create_autocmd('FileType', {group = group, command = 'set formatoptions-=o'})
vim.api.nvim_create_autocmd('TextYankPost', {group = group, callback = function() vim.highlight.on_yank() end})
