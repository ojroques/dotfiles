-------------------- HIGHLIGHTS ------------------------------------------------
local palette = require('onedark.palette').dark
local highlights = {
  High = {
    Default = {fg = palette.black, bg = palette.light_grey, bold = true},
    Command = {fg = palette.black, bg = palette.red, bold = true},
    Insert = {fg = palette.black, bg = palette.blue, bold = true},
    Normal = {fg = palette.black, bg = palette.green, bold = true},
    Replace = {fg = palette.black, bg = palette.cyan, bold = true},
    Visual = {fg = palette.black, bg = palette.purple, bold = true},
    Inactive = {fg = palette.grey, bg = palette.bg1, bold = false},
  },
  Medium = {
    Default = {fg = palette.orange, bg = palette.bg1, bold = false},
    Emphasized = {fg = palette.yellow, bg = palette.bg1, bold = true},
    Inactive = {fg = palette.light_grey, bg = palette.bg1, bold = true},
  },
  Low = {
    Default = {fg = palette.fg, bg = palette.bg2},
    Inactive = {fg = palette.grey, bg = palette.bg1},
  },
}

local function highlight_text(text, class, state)
  local group = string.format('Statusline%s%s', class, state)
  return string.format('%%#%s#%s%%*', group, text)
end

-------------------- MODE ------------------------------------------------------
local modes = {
  [''] = {long = 'S-Block', short = 'S-B', state = 'Visual'},
  [''] = {long = 'V-Block', short = 'V-B', state = 'Visual'},
  ['!'] = {long = 'Shell', short = 'Sh', state = 'Command'},
  ['?'] = {long = '???', short = '?', state = 'Default'},
  ['R'] = {long = 'Replace', short = 'R', state = 'Replace'},
  ['S'] = {long = 'S-Line', short = 'S-L', state = 'Visual'},
  ['V'] = {long = 'V-Line', short = 'V-L', state = 'Visual'},
  ['c'] = {long = 'Command', short = 'C', state = 'Command'},
  ['i'] = {long = 'Insert', short = 'I', state = 'Insert'},
  ['n'] = {long = 'Normal', short = 'N', state = 'Normal'},
  ['r'] = {long = 'Prompt', short = 'P', state = 'Replace'},
  ['s'] = {long = 'Select', short = 'S', state = 'Visual'},
  ['t'] = {long = 'Terminal', short = 'T', state = 'Command'},
  ['v'] = {long = 'Visual', short = 'V', state = 'Visual'},
}

local function get_mode(active)
  local mode = modes[string.sub(vim.api.nvim_get_mode().mode, 1, 1)] or modes['?']
  local width = vim.api.nvim_win_get_width(0)
  local text = width < 140 and mode.short or mode.long
  local state = active and mode.state or 'Inactive'
  return highlight_text(string.format(' %s ', text), 'High', state)
end

-------------------- FILETYPE --------------------------------------------------
local function get_filetype(active)
  if vim.api.nvim_win_get_width(0) < 80 then
    return ''
  end

  local state = active and 'Default' or 'Inactive'
  local text = vim.bo.filetype
  local icon = require('mini.icons').get('filetype', text)

  if text == '' then
    return ''
  end

  return highlight_text(string.format(' %s %s ', icon, text), 'Low', state)
end

-------------------- FILEPATH --------------------------------------------------
local function get_filepath(active)
  local width = vim.api.nvim_win_get_width(0)
  local head, body, tail = ' ', '', ' %r%h%w '

  if vim.fn.expand('%:t') == '' then
    body, tail = '[No Name]', ' '
  elseif width < 60 then
    body = vim.fn.expand('%:t')
  elseif width < 100 then
    body = vim.fn.expand('%:.')
  else
    local full = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')

    if string.find(full, cwd, 1, true) then
      head = string.format(' %s', vim.fn.fnamemodify(cwd, ':~'))
      body = vim.fn.fnamemodify(full, string.format(':s?%s??', cwd))
    else
      body = vim.fn.fnamemodify(full, ':~')
    end
  end

  if active then
    head = highlight_text(head, 'Medium', 'Default')
    body = highlight_text(body, 'Medium', 'Emphasized')
    tail = highlight_text(tail, 'Medium', 'Default')
  else
    head = highlight_text(head, 'Medium', 'Inactive')
    body = highlight_text(body, 'Medium', 'Inactive')
    tail = highlight_text(tail, 'Medium', 'Inactive')
  end

  return string.format('%s%s%s', head, body, tail)
end

-------------------- FILESIZE --------------------------------------------------
local function get_filesize(active)
  if vim.api.nvim_win_get_width(0) < 120 then
    return ''
  end

  local state = active and 'Default' or 'Inactive'
  local size = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
  local text

  if size == 0 then
    return ''
  elseif size < 1000 then
    text = string.format('%dB', size)
  elseif size < 1000000 then
    text = string.format('%.2fKB', size / 1000)
  else
    text = string.format('%.2fMB', size / 1000000)
  end

  return highlight_text(string.format(' %s ', text), 'Low', state)
end

-------------------- POSITION --------------------------------------------------
local function get_position(active)
  local nblines = vim.fn.line('$')
  local line = vim.fn.line('.')
  local nbcols = vim.fn.col('$') - 1
  local col = vim.fn.col('.')
  local percent = math.floor(line / nblines * 100)
  local text = string.format('%d/%d %d/%d %d%%%%', line, nblines, col, nbcols, percent)
  local mode = modes[vim.api.nvim_get_mode().mode] or modes['?']
  local state = active and mode.state or 'Inactive'
  return highlight_text(string.format(' %s ', text), 'High', state)
end

-------------------- SETUP -----------------------------------------------------
function set_highlights()
  for class, states in pairs(highlights) do
    for state, highlight in pairs(states) do
      local group = string.format('Statusline%s%s', class, state)
      vim.api.nvim_set_hl(0, group, highlight)
    end
  end
end

local function set_statusline(active)
  if vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative ~= '' then
    vim.wo.statusline=''
  elseif active then
    vim.wo.statusline=[[%{%luaeval('require("statusline").build_statusline(true)')%}]]
  else
    vim.wo.statusline=[[%{%luaeval('require("statusline").build_statusline(false)')%}]]
  end
end

local function create_autocommands()
  local group = vim.api.nvim_create_augroup('Statusline', {})
  vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter'}, {group = group, callback = function() set_statusline(true) end})
  vim.api.nvim_create_autocmd({'WinLeave', 'BufLeave'}, {group = group, callback = function() set_statusline(false) end})
end

-------------------- PUBLIC ----------------------------------------------------
local M = {}

function M.build_statusline(active)
  return table.concat({
    get_mode(active),
    get_filetype(active),
    get_filepath(active),
    '%<',
    highlight_text('%=', 'Medium', 'Default'),
    get_filesize(active),
    get_position(active),
  })
end

function M.setup()
  set_highlights()
  create_autocommands()
end

return M
