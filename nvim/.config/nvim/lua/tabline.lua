-------------------- HIGHLIGHTS ------------------------------------------------
local palette = require('onedark')
local highlights = {
  Separator = {
    Default = {fg = palette.fg, bg = palette.bg1},
  },
  Bookmark = {
    Active = {fg = palette.black, bg = palette.orange, bold = true},
    Inactive = {fg = palette.orange, bg = palette.bg1},
  },
  Listed = {
    Active = {fg = palette.black, bg = palette.green, bold = true},
    Inactive = {fg = palette.green, bg = palette.bg1},
  },
  Modified = {
    Active = {fg = palette.black, bg = palette.blue, bold = true},
    Inactive = {fg = palette.blue, bg = palette.bg1},
  },
  Terminal = {
    Active = {fg = palette.black, bg = palette.red, bold = true},
    Inactive = {fg = palette.red, bg = palette.bg1},
  },
}

local function highlight_text(text, class, state)
  local group = string.format('Tabline%s%s', class, state)
  return string.format('%%#%s#%s%%*', group, text)
end

-------------------- TABS ------------------------------------------------------
local function is_excluded(bufnr)
  local filetype = vim.bo[bufnr].filetype
  return filetype == 'help' or filetype == 'qf' or filetype == 'minipick'
end

local function get_buffers()
  local buffers = {}
  local current_bufnr = vim.api.nvim_get_current_buf()
  local last_used, last_buffer

  for _, bufinfo in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
    if not is_excluded(bufinfo.bufnr) then
      local buffer = {
        bufnr = bufinfo.bufnr,
        current = bufinfo.bufnr == current_bufnr,
        modified = vim.bo[bufinfo.bufnr].modified,
        terminal = vim.bo[bufinfo.bufnr].buftype == 'terminal',
      }

      if not last_used or bufinfo.lastused > last_used then
        last_used, last_buffer = bufinfo.lastused, buffer
      end

      table.insert(buffers, buffer)
    end
  end

  if is_excluded(current_bufnr) and last_buffer then
    last_buffer.current = true
  end

  return buffers
end

local function build_tab(buffer)
  local class = buffer.terminal and 'Terminal' or buffer.modified and 'Modified' or 'Listed'
  local state = buffer.current and 'Active' or 'Inactive'
  return highlight_text(string.format(' %d ', buffer.bufnr), class, state)
end

local function build_bookmarks()
  local ok, bookmarks = pcall(require, 'bookmarks')
  if not ok or bookmarks.shada == nil then
    return ''
  end

  local files = bookmarks.shada:files(bookmarks.namespace)
  if files == nil or #files == 0 then
    return ''
  end

  local current_path = vim.api.nvim_buf_get_name(0)
  local separator = highlight_text('|', 'Separator', 'Default')
  local items = {}

  for i = 1, math.min(4, #files) do
    local file = files[i]
    local filename = vim.fn.fnamemodify(file.path, ':t')
    if filename ~= '' then
      local state = (file.path == current_path) and 'Active' or 'Inactive'
      table.insert(items, highlight_text(string.format(' %d: %s ', i, filename), 'Bookmark', state))
    end
  end

  if #items == 0 then
    return ''
  end

  return table.concat(items, separator)
end

-------------------- SETUP -----------------------------------------------------
local function set_highlights()
  for class, states in pairs(highlights) do
    for state, highlight in pairs(states) do
      local group = string.format('Tabline%s%s', class, state)
      vim.api.nvim_set_hl(0, group, highlight)
    end
  end
end

local function set_tabline()
  vim.o.showtabline = 2
  vim.o.tabline = [[%!luaeval('require("tabline").build_tabline()')]]
end

-------------------- PUBLIC ----------------------------------------------------
local M = {}

function M.build_tabline()
  local tabs = {}
  local buffers = get_buffers()
  local separator = highlight_text('|', 'Separator', 'Default')

  for _, buffer in ipairs(buffers) do
    table.insert(tabs, build_tab(buffer))
  end

  return table.concat(tabs, separator) .. '%=' .. build_bookmarks()
end

function M.setup()
  set_highlights()
  set_tabline()
end

return M
