-------------------- INIT ------------------------------------------------------
local mini = string.format('%s/site/pack/deps/start/mini.nvim', vim.fn.stdpath('data'))
if not vim.uv.fs_stat(mini) then
  vim.notify('Installing mini.nvim', vim.log.levels.INFO)
  vim.system({'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini}):wait()
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-------------------- PLUGINS ---------------------------------------------------
local tsupdate = function() vim.cmd('TSUpdate') end
require('mini.deps').setup {}
MiniDeps.add('ibhagwan/fzf-lua')
MiniDeps.add('navarasu/onedark.nvim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('nvim-treesitter/nvim-treesitter-context')
MiniDeps.add({source = 'nvim-treesitter/nvim-treesitter', hooks = {post_checkout = tsupdate}})

-------------------- PLUGIN SETUP ----------------------------------------------
-- mini.ai
require('mini.ai').setup {custom_textobjects = {e = require('mini.extra').gen_ai_spec.buffer()}}
-- mini.basics
require('mini.basics').setup {
  options = {basic = false},
  mappings = {option_toggle_prefix = 'yo'},
}
-- mini.bracketed
require('mini.bracketed').setup {}
-- mini.bufremove
require('mini.bufremove').setup {}
vim.keymap.set('n', 'gd', MiniBufremove.delete)
-- mini.completion
require('mini.completion').setup {lsp_completion = {source_func = 'omnifunc', auto_setup = false}}
vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end, {expr = true})
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, {expr = true})
-- mini.diff
require('mini.diff').setup {view = {signs = {add = '+', change = '~', delete = '-'}}}
vim.keymap.set('n', 'ghp', MiniDiff.toggle_overlay)
vim.keymap.set('n', 'ghR', 'gHae', {remap = true})
vim.keymap.set('n', 'ghS', 'ghae', {remap = true})
vim.keymap.set('n', 'ghr', 'gHgh', {remap = true})
vim.keymap.set('n', 'ghs', 'ghgh', {remap = true})
-- mini.files
require('mini.files').setup {}
vim.keymap.set('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
-- mini.git
require('mini.git').setup {}
-- mini.icons
require('mini.icons').setup {}
MiniDeps.later(MiniIcons.tweak_lsp_kind)
-- mini.indentscope
require('mini.indentscope').setup {draw = {animation = require('mini.indentscope').gen_animation.none()}}
-- mini.misc
require('mini.misc').setup_auto_root()
-- mini.notify
require('mini.notify').setup {}
vim.notify = MiniNotify.make_notify()
-- mini.operators
require('mini.operators').setup {
  evaluate = {prefix = ''}, multiply = {prefix = ''},
  exchange = {prefix = 'cx'}, replace = {prefix = 'cr'},
}
-- mini.statusline
require('mini.statusline').setup {}
-- mini.surround
require('mini.surround').setup {mappings = {
  add = 'ys', delete = 'ds', replace = 'cs',
  find = '', find_left = '', highlight = '', update_n_lines = '', suffix_last = '', suffix_next = '',
}}
vim.keymap.del('x', 'ys')
-- mini.trailspace
require('mini.trailspace').setup {}
-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {enable = true},
}
-- nvim-treesitter-context
require('treesitter-context').setup {mode = 'topline'}
-- onedark.nvim
require('onedark').setup {
  code_style = {comments = 'none'},
  highlights = {TreesitterContext = {bg = require('onedark.palette').dark.bg1, fmt = 'italic'}},
}
require('onedark').load()
-- tabline
require('tabline').setup {}
-- fzf-lua
fzf_lua = require('fzf-lua')
fzf_lua.setup {
  keymap = {builtin = {true, ['jj'] = 'hide'}},
  grep = {RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH},
  winopts = {preview = {layout = 'vertical', vertical = 'up:50%'}},
}
vim.keymap.set('n', 'sb', fzf_lua.buffers)
vim.keymap.set('n', 'sf', fzf_lua.files)
vim.keymap.set('n', 'sg', fzf_lua.grep)
vim.keymap.set('n', 'sl', fzf_lua.live_grep)
vim.keymap.set('n', 'sr', fzf_lua.resume)

-------------------- LSP -------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
for _, ls in ipairs({'bashls', 'gopls', 'pylsp'}) do
  require('lspconfig')[ls].setup {
    capabilities = capabilities,
    on_attach = function(_, buf)
      vim.bo[buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
      vim.keymap.set('n', 'gqae', vim.lsp.buf.format, {buffer = buf})
      vim.keymap.set('n', 'grd', function() fzf_lua.lsp_definitions({jump_to_single_result = true}) end, {buffer = buf})
      vim.keymap.set('n', 'gre', function() fzf_lua.lsp_workspace_diagnostics({jump_to_single_result = true}) end, {buffer = buf})
      vim.keymap.set('n', 'gri', function() fzf_lua.lsp_implementations({jump_to_single_result = true}) end, {buffer = buf})
      vim.keymap.set('n', 'grr', function() fzf_lua.lsp_references({jump_to_single_result = true}) end, {buffer = buf})
      vim.keymap.set('n', 'grt', function() fzf_lua.lsp_typedefs({jump_to_single_result = true}) end, {buffer = buf})
    end,
  }
end

-------------------- OPTIONS ---------------------------------------------------
vim.opt.colorcolumn = '+1'                    -- Line length marker
vim.opt.completeopt = {'menuone', 'noselect'} -- Completion options
vim.opt.cursorline = true                     -- Highlight cursor line
vim.opt.diffopt:append {'linematch:60'}       -- Improve diff mode
vim.opt.expandtab = true                      -- Use spaces instead of tabs
vim.opt.ignorecase = true                     -- Ignore case
vim.opt.inccommand = ''                       -- Disable substitution preview
vim.opt.list = true                           -- Show invisible characters
vim.opt.mouse = ''                            -- Disable mouse
vim.opt.number = true                         -- Show line numbers
vim.opt.pumheight = 12                        -- Max height of pop-up menu
vim.opt.relativenumber = true                 -- Show relative line numbers
vim.opt.report = 0                            -- Always report changed lines
vim.opt.scrolloff = 4                         -- Lines of context
vim.opt.shiftround = true                     -- Round indent
vim.opt.shiftwidth = 0                        -- Size of an indent
vim.opt.shortmess = 'atToOcCF'                -- Prompt message options
vim.opt.sidescrolloff = 12                    -- Columns of context
vim.opt.signcolumn = 'yes'                    -- Show sign column
vim.opt.smartcase = true                      -- Do not ignore capital letters
vim.opt.smartindent = true                    -- Insert indents automatically
vim.opt.splitbelow = true                     -- Put new window below current
vim.opt.splitright = true                     -- Put new window right of current
vim.opt.tabstop = 2                           -- Number of spaces tabs count for
vim.opt.textwidth = 99                        -- Maximum width of text
vim.opt.updatetime = 200                      -- Delay before swap file is saved
vim.opt.wildmode = {'list:longest'}           -- Command completion options
vim.opt.wrap = false                          -- Disable line wrap

-------------------- MAPPINGS --------------------------------------------------
local function substitute()
  local cmd = ':%s//gcI<Left><Left><Left><Left>'
  return vim.fn.mode() == 'n' and string.format(cmd, '%s') or string.format(cmd, 's')
end
vim.keymap.set('', '<Space>', '<C-w>')
vim.keymap.set('', 'S', substitute, {expr = true})
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<C-Down>', '<C-w>-')
vim.keymap.set('n', '<C-Left>', '<C-w><')
vim.keymap.set('n', '<C-Right>', '<C-w>>')
vim.keymap.set('n', '<C-Up>', '<C-w>+')
vim.keymap.set('n', 'H', 'zh')
vim.keymap.set('n', 'L', 'zl')
vim.keymap.set('n', 'U', '<Cmd>update<CR>')
vim.keymap.set('n', 'X', '<Cmd>conf qa<CR>')
