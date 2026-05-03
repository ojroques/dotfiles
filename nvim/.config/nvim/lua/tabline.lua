-------------------- HIGHLIGHTS ------------------------------------------------
local palette = require('onedark')
local highlights = {
  Separator = {
    Default = {fg = palette.fg, bg = palette.bg1},
  },
  Listed = {
    Active = {fg = palette.black, bg = palette.green, bold = true},
    Inactive = {fg = palette.green, bg = palette.bg1},
  },
  Modified = {
    Active = {fg = palette.black, bg = palette.blue, bold = true},
    Inactive = {fg = palette.blue, bg = palette.bg1},
  },
}

local function highlight_text(text, class, state)
  local group = string.format('Tabline%s%s', class, state)
  return string.format('%%#%s#%s%%*', group, text)
end

-------------------- BUFFERS ---------------------------------------------------
local function excluded_buffer(bufnr)
  local filetype = vim.bo[bufnr].filetype
  return filetype == 'help' or filetype == 'qf' or filetype == 'minipick'
end

local function list_buffers()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local buffers = {}

  for _, bufinfo in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
    if not excluded_buffer(bufinfo.bufnr) then
      table.insert(buffers, {
        bufnr = bufinfo.bufnr,
        current = bufinfo.bufnr == current_bufnr,
        modified = bufinfo.changed ~= 0,
      })
    end
  end

  return buffers
end

-------------------- BUILDERS --------------------------------------------------
local function build_buffers()
  local buffers = list_buffers()
  if not buffers or #buffers == 0 then return '' end

  local separator = highlight_text('|', 'Separator', 'Default')
  local parts = {}

  for _, buffer in ipairs(buffers) do
    local class = buffer.modified and 'Modified' or 'Listed'
    local state = buffer.current and 'Active' or 'Inactive'
    table.insert(parts, highlight_text(string.format(' %d ', buffer.bufnr), class, state))
  end

  return table.concat(parts, separator)
end

local function build_visits()
  if not MiniVisits then return '' end

  local paths = MiniVisits.list_paths()
  if not paths or #paths == 0 then return '' end

  local current_path = vim.api.nvim_buf_get_name(0)
  local separator = highlight_text('|', 'Separator', 'Default')
  local parts = {}

  for i = 1, math.min(6, #paths) do
    local filename = vim.fn.fnamemodify(paths[i], ':t')
    local bufnr = vim.fn.bufnr(paths[i])
    local class = bufnr ~= -1 and vim.bo[bufnr].modified and 'Modified' or 'Listed'
    local state = paths[i] == current_path and 'Active' or 'Inactive'
    table.insert(parts, highlight_text(string.format(' %d: %s ', i, filename), class, state))
  end

  return table.concat(parts, separator)
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
  return build_visits() .. '%=' .. build_buffers()
end

function M.setup()
  set_highlights()
  set_tabline()
end

return M
