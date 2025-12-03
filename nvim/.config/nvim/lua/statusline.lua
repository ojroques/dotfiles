-------------------- HIGHLIGHTS ------------------------------------------------
local palette = require('onedark.palette').dark
local highlights = {
  High = {
    Default = {fg = palette.fg, bg = palette.bg1},
    Normal = {fg = palette.fg, bg = palette.bg1},
    Insert = {fg = palette.fg, bg = palette.bg1},
    Command = {fg = palette.fg, bg = palette.bg1},
    Visual = {fg = palette.fg, bg = palette.bg1},
    Replace = {fg = palette.fg, bg = palette.bg1},
    Inactive = {fg = palette.fg, bg = palette.bg1},
  },
  Medium = {
    Active = {fg = palette.black, bg = palette.blue},
    Inactive = {fg = palette.black, bg = palette.blue},
  },
  Low = {
    Active = {fg = palette.black, bg = palette.green},
    Inactive = {fg = palette.black, bg = palette.green},
  },
}

-------------------- PRIVATE ---------------------------------------------------
local function highlight_text(text, component, state)
  local group = string.format('Statusline%s%s', component, state)
  return string.format('%%#%s#%s%%*', group, text)
end

function set_highlights()
  for component, states in pairs(highlights) do
    for state, highlight in pairs(states) do
      local group = string.format('Statusline%s%s', component, state)
      vim.api.nvim_set_hl(0, group, highlight)
    end
  end
end

local function set_statusline(active)
  if vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative ~= '' then
    vim.wo.statusline=''
    return
  end

  if active then
    vim.wo.statusline=[[%{%luaeval('require("statusline").build_statusline(true)')%}]]
  else
    vim.wo.statusline=[[%{%luaeval('require("statusline").build_statusline(false)')%}]]
  end
end

local function create_autocommands()
  local group = vim.api.nvim_create_augroup('Statusline', {})
  vim.api.nvim_create_autocmd('WinEnter', {group = group, callback = function() set_statusline(true) end})
  vim.api.nvim_create_autocmd('WinLeave', {group = group, callback = function() set_statusline(false) end})
end

-------------------- PUBLIC ----------------------------------------------------
local M = {}

function M.build_statusline(active)
  if active then
    return "active"
  else
    return "inactive"
  end
end

function M.setup()
  set_highlights()
  set_statusline(true)
  create_autocommands()
end

return M
