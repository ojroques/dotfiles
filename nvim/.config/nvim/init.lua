------------------- PLUGINS ---------------------------------------------------
vim.pack.add({
  {src = 'https://github.com/navarasu/onedark.nvim', version = 'master'},
  {src = 'https://github.com/neovim/nvim-lspconfig', version = 'master'},
  {src = 'https://github.com/nvim-mini/mini.nvim', version = 'main'},
  {src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main'},
  {src = 'https://github.com/nvim-treesitter/nvim-treesitter-context', version = 'master'},
  {src = 'https://github.com/ojroques/nvim-bookmarks', version = 'main'},
})

-------------------- PLUGIN SETUP ----------------------------------------------
-- mini.extra
require('mini.extra').setup()
-- mini.ai
require('mini.ai').setup({custom_textobjects = {e = MiniExtra.gen_ai_spec.buffer()}})
-- mini.basics
require('mini.basics').setup({
  options = {basic = false},
  mappings = {option_toggle_prefix = 'yo'},
})
-- mini.bracketed
require('mini.bracketed').setup()
-- mini.bufremove
require('mini.bufremove').setup()
vim.keymap.set('n', '<Leader>d', MiniBufremove.delete)
-- mini.completion
require('mini.completion').setup({lsp_completion = {source_func = 'omnifunc', auto_setup = false}})
-- mini.diff
require('mini.diff').setup()
vim.keymap.set('n', 'ghp', MiniDiff.toggle_overlay)
vim.keymap.set('n', 'ghR', 'gHae', {remap = true})
vim.keymap.set('n', 'ghS', 'ghae', {remap = true})
vim.keymap.set('n', 'ghr', 'gHgh', {remap = true})
vim.keymap.set('n', 'ghs', 'ghgh', {remap = true})
-- mini.files
require('mini.files').setup()
vim.keymap.set('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
-- mini.icons
require('mini.icons').setup()
MiniIcons.tweak_lsp_kind()
-- mini.indentscope
require('mini.indentscope').setup({draw = {animation = require('mini.indentscope').gen_animation.none()}})
-- mini.keymap
require('mini.keymap').setup()
MiniKeymap.map_multistep('i', '<Tab>', {'pmenu_next'})
MiniKeymap.map_multistep('i', '<S-Tab>', {'pmenu_prev'})
-- mini.misc
require('mini.misc').setup_auto_root({'.git'})
-- mini.notify
require('mini.notify').setup()
vim.notify = MiniNotify.make_notify()
-- mini.operators
require('mini.operators').setup({
  replace = {prefix = 'cr'},
  exchange = {prefix = ''}, evaluate = {prefix = ''}, multiply = {prefix = ''},
})
-- mini.pick
require('mini.pick').setup({mappings = {refine = '<C-q>', refine_marked = '<M-q>'}})
vim.keymap.set('n', 's/', function() MiniExtra.pickers.history({scope = '/'}) end)
vim.keymap.set('n', 's;', function() MiniExtra.pickers.history({scope = ':'}) end)
vim.keymap.set('n', 'sb', MiniPick.builtin.buffers)
vim.keymap.set('n', 'sd', MiniExtra.pickers.diagnostic)
vim.keymap.set('n', 'sf', MiniPick.builtin.files)
vim.keymap.set('n', 'sl', MiniPick.builtin.grep_live)
vim.keymap.set('n', 'sr', MiniPick.builtin.resume)
-- mini.surround
require('mini.surround').setup({mappings = {
  add = 'ys', delete = 'ds', replace = 'cs',
  find = '', find_left = '', highlight = '', suffix_last = '', suffix_next = '', update_n_lines = '',
}})
vim.keymap.del('x', 'ys')
-- mini.trailspace
require('mini.trailspace').setup()
-- nvim-bookmarks
local bookmarks = require('bookmarks')
bookmarks.setup()
vim.keymap.set('n', '<Leader>m', bookmarks.toggle_menu)
vim.keymap.set('n', 'm1', function() bookmarks.open(1) end)
vim.keymap.set('n', 'm2', function() bookmarks.open(2) end)
vim.keymap.set('n', 'm3', function() bookmarks.open(3) end)
vim.keymap.set('n', 'm4', function() bookmarks.open(4) end)
vim.keymap.set('n', 'mm', bookmarks.add)
-- nvim-treesitter-context
require('treesitter-context').setup({mode = 'topline', separator = '━'})
-- nvim.undotree
vim.cmd('packadd nvim.undotree')
vim.keymap.set('n', 'U', '<Cmd>Undotree<CR>')
-- onedark.nvim
require('onedark').load()
-- statusline
require('statusline').setup()
-- tabline
require('tabline').setup()

-------------------- LSP -------------------------------------------------------
local function on_attach(_, buf)
  vim.bo[buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  vim.keymap.set('n', 'gqe', vim.lsp.buf.format, {buffer = buf})
  vim.keymap.set('n', 'grd', function() MiniExtra.pickers.lsp({scope = 'definition'}) end, {buffer = buf})
  vim.keymap.set('n', 'gri', function() MiniExtra.pickers.lsp({scope = 'implementation'}) end, {buffer = buf})
  vim.keymap.set('n', 'grr', function() MiniExtra.pickers.lsp({scope = 'references'}) end, {buffer = buf})
  vim.keymap.set('n', 'grt', function() MiniExtra.pickers.lsp({scope = 'type_definition'}) end, {buffer = buf})
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
vim.lsp.config('*', {capabilities = capabilities, on_attach = on_attach})
vim.lsp.enable({'bashls', 'gopls', 'terraformls', 'ty'})

-------------------- TREESITTER ------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter', {}),
  callback = function(a)
    lang = vim.treesitter.language.get_lang(a.match)
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(a.buf, lang)
    end
  end,
})

-------------------- OPTIONS ---------------------------------------------------
vim.diagnostic.config({severity_sort = true, virtual_text = true})
vim.opt.colorcolumn = '+1'                    -- Line length marker
vim.opt.completeopt = {'menuone', 'noselect'} -- Completion options
vim.opt.cursorline = true                     -- Highlight cursor line
vim.opt.diffopt:append({'algorithm:histogram', 'context:999999', 'inline:none'}) -- Diff mode options
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
vim.opt.shiftwidth = 0                        -- Indent size
vim.opt.shortmess = 'atToOcCF'                -- Prompt message options
vim.opt.showmode = false                      -- Hide mode
vim.opt.sidescrolloff = 12                    -- Columns of context
vim.opt.signcolumn = 'yes'                    -- Show sign column
vim.opt.smartcase = true                      -- Do not ignore capital letters
vim.opt.smartindent = true                    -- Insert indents automatically
vim.opt.splitbelow = true                     -- Put new window below current
vim.opt.splitright = true                     -- Put new window right of current
vim.opt.tabstop = 2                           -- Number of spaces tabs count for
vim.opt.textwidth = 99                        -- Max width of text
vim.opt.undofile = true                       -- Undo persistence
vim.opt.updatetime = 200                      -- Delay before swap file is saved
vim.opt.wildmode = {'list:longest'}           -- Command completion options
vim.opt.wrap = false                          -- Disable line wrap

-------------------- MAPPINGS --------------------------------------------------
vim.keymap.set('', '<Space>', '<C-w>')
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<C-Down>', '<C-w>-')
vim.keymap.set('n', '<C-Left>', '<C-w><')
vim.keymap.set('n', '<C-Right>', '<C-w>>')
vim.keymap.set('n', '<C-Up>', '<C-w>+')
vim.keymap.set('n', '<Leader>s', ':%s//gcI<Left><Left><Left><Left>')
vim.keymap.set('n', '<Leader>u', '<Cmd>update<CR>')
vim.keymap.set('n', '<Leader>x', '<Cmd>conf qa<CR>')
vim.keymap.set('n', 'H', 'zh')
vim.keymap.set('n', 'L', 'zl')
vim.keymap.set('n', 'gyp', function() vim.fn.setreg('+', vim.fn.getreg('%')) end)
vim.keymap.set('x', '<Leader>s', ':s//gcI<Left><Left><Left><Left>')
