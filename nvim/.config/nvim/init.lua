-------------------- INIT ----------------------------------
local mini = string.format('%s/site/pack/deps/start/mini.nvim', vim.fn.stdpath('data'))
if not vim.uv.fs_stat(mini) then
  vim.notify('Installing mini.nvim', vim.log.levels.INFO)
  vim.system({'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini}):wait()
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-------------------- PLUGINS -------------------------------
local make = function(a) vim.system({'make'}, {cwd = a.path}):wait() end
require('mini.deps').setup {}
MiniDeps.add('navarasu/onedark.nvim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('nvim-telescope/telescope.nvim')
MiniDeps.add('nvim-treesitter/nvim-treesitter')
MiniDeps.add('nvim-treesitter/nvim-treesitter-context')
MiniDeps.add('ojroques/nvim-buildme')
MiniDeps.add({source = 'nvim-telescope/telescope-fzf-native.nvim', hooks = {post_install = make, post_checkout = make}})
MiniDeps.add({source = 'ojroques/nvim-bufbar', checkout = 'personal'})

-------------------- PLUGIN SETUP --------------------------
-- mini.ai
require('mini.ai').setup {
  custom_textobjects = {B = require('mini.extra').gen_ai_spec.buffer()},
}
-- mini.basics
require('mini.basics').setup {
  options = {basic = false},
  autocommands = {basic = false},
  mappings = {option_toggle_prefix = 'yo'},
}
-- mini.bracketed
require('mini.bracketed').setup {}
-- mini.bufremove
require('mini.bufremove').setup {}
vim.keymap.set('n', '<leader>w', MiniBufremove.delete)
-- mini.completion
require('mini.completion').setup {
  lsp_completion = {source_func = 'omnifunc', auto_setup = false},
}
vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end, {expr = true})
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, {expr = true})
-- mini.diff
require('mini.diff').setup {
  view = {signs = {add = '+', change = '~', delete = '-'}},
}
vim.keymap.set('n', '<leader>gR', 'gHaB', {remap = true})
vim.keymap.set('n', '<leader>gS', 'ghaB', {remap = true})
vim.keymap.set('n', '<leader>gp', MiniDiff.toggle_overlay)
vim.keymap.set('n', '<leader>gr', 'gHgh', {remap = true})
vim.keymap.set('n', '<leader>gs', 'ghgh', {remap = true})
-- mini.files
require('mini.files').setup {}
vim.keymap.set('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
-- mini.git
require('mini.git').setup {
  command = {split = 'horizontal'},
}
vim.keymap.set('n', '<leader>gi', function() MiniGit.show_at_cursor({split = 'horizontal'}) end)
-- mini.icons
require('mini.icons').setup {}
-- mini.indentscope
require('mini.indentscope').setup {
  draw = {animation = require('mini.indentscope').gen_animation.none()},
}
-- mini.misc
require('mini.misc').setup_auto_root()
-- mini.notify
require('mini.notify').setup {}
vim.notify = MiniNotify.make_notify()
-- mini.operators
require('mini.operators').setup {}
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
vim.keymap.set('n', '<leader>t', MiniTrailspace.trim)
-- nvim-bufbar
require('bufbar').setup {}
-- nvim-buildme
local buildme = require('buildme')
vim.keymap.set('n', '<leader>bb', buildme.run)
vim.keymap.set('n', '<leader>be', buildme.edit)
vim.keymap.set('n', '<leader>bs', buildme.stop)
-- nvim-lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
for _, ls in ipairs({'bashls', 'gopls', 'pylsp'}) do
  require('lspconfig')[ls].setup {
    capabilities = capabilities,
    on_attach = function(_, buf)
      vim.api.nvim_set_option_value('omnifunc', 'v:lua.MiniCompletion.completefunc_lsp', {buf = buf})
    end,
  }
end
-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {enable = true},
}
-- nvim-treesitter-context
require('treesitter-context').setup {
  mode = 'topline',
}
-- onedark.nvim
require('onedark').setup {
  code_style = {comments = 'none'},
  highlights = {TreesitterContext = {bg = require('onedark.palette').dark.bg1, fmt = 'italic'}},
}
require('onedark').load()
-- telescope.nvim
local telescope_builtin = require('telescope.builtin')
require('telescope').setup {
  defaults = {layout_strategy = 'vertical'},
  pickers = {grep_string = {use_regex = true}},
}
require('telescope').load_extension('fzf')
vim.keymap.set('n', '<leader>/', telescope_builtin.search_history)
vim.keymap.set('n', '<leader>;', telescope_builtin.command_history)
vim.keymap.set('n', '<leader>R', function() telescope_builtin.grep_string({search = vim.fn.input('Grep > ')}) end)
vim.keymap.set('n', '<leader>f', telescope_builtin.find_files)
vim.keymap.set('n', '<leader>r', telescope_builtin.live_grep)
vim.keymap.set('n', '<space>d', telescope_builtin.lsp_definitions)
vim.keymap.set('n', '<space>i', telescope_builtin.lsp_implementations)
vim.keymap.set('n', '<space>r', telescope_builtin.lsp_references)
vim.keymap.set('n', '<space>sd', telescope_builtin.lsp_document_symbols)
vim.keymap.set('n', '<space>sw', telescope_builtin.lsp_workspace_symbols)
vim.keymap.set('n', '<space>t', telescope_builtin.lsp_type_definitions)
vim.keymap.set('n', 's', telescope_builtin.buffers)

-------------------- OPTIONS -------------------------------
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

-------------------- MAPPINGS ------------------------------
local function substitute()
  local cmd = ':%s//gcI<Left><Left><Left><Left>'
  return vim.fn.mode() == 'n' and string.format(cmd, '%s') or string.format(cmd, 's')
end
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<C-Down>', '<C-w><')
vim.keymap.set('n', '<C-Left>', '<C-w>-')
vim.keymap.set('n', '<C-Right>', '<C-w>+')
vim.keymap.set('n', '<C-Up>', '<C-w>>')
vim.keymap.set('n', '<leader>u', '<cmd>update<CR>')
vim.keymap.set('n', '<leader>x', '<cmd>conf qa<CR>')
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<space>f', vim.lsp.buf.format)
vim.keymap.set('n', '<space>n', vim.lsp.buf.rename)
vim.keymap.set('n', 'H', 'zh')
vim.keymap.set('n', 'L', 'zl')
vim.keymap.set({'n', 'v'}, '<leader>s', substitute, {expr = true})

-------------------- AUTOCOMMANDS --------------------------
local augroup = vim.api.nvim_create_augroup('init', {})
vim.api.nvim_create_autocmd('TextYankPost', {group = augroup, callback = function() vim.highlight.on_yank() end})
