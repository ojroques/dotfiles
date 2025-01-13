local M = {}
local palette = require('onedark.palette').dark
local colorscheme = {
  separator = {
    default = {guifg = palette.fg, guibg = palette.bg1},
  },
  listed = {
    active = {guifg = palette.black, guibg = palette.green},
    active_low = {guifg = palette.grey, guibg = palette.green},
    inactive = {guifg = palette.green, guibg = palette.bg1},
  },
  modified = {
    active = {guifg = palette.black, guibg = palette.blue},
    active_low = {guifg = palette.grey, guibg = palette.blue},
    inactive = {guifg = palette.blue, guibg = palette.bg1},
  },
  terminal = {
    active = {guifg = palette.black, guibg = palette.red},
    active_low = {guifg = palette.grey, guibg = palette.red},
    inactive = {guifg = palette.red, guibg = palette.bg1},
  },
}

local function set_hlgroup(text, class, level)
  local hlgroup = string.format('Tabline_%s_%s', class, level)
  return string.format('%%#%s#%s%%*', hlgroup, text)
end

local function is_excluded(bufnr)
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  return filetype == 'help' or filetype == 'qf' or filetype == 'minipick'
end

local function get_buffers()
  local buffers = {}
  local current_bufnr = vim.fn.bufnr()
  local last_used, last_buffer

  for _, bufinfo in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
    if not is_excluded(bufinfo.bufnr) then
      local buffer = {
        bufnr = bufinfo.bufnr,
        current = bufinfo.bufnr == current_bufnr,
        modifiable = vim.fn.getbufvar(bufinfo.bufnr, '&modifiable') == 1,
        modified = vim.fn.getbufvar(bufinfo.bufnr, '&modified') == 1,
        readonly = vim.fn.getbufvar(bufinfo.bufnr, '&readonly') == 1,
        terminal = vim.fn.getbufvar(bufinfo.bufnr, '&buftype') == 'terminal',
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

local function get_buffer_flags(buffer)
  local flags = {}

  if buffer.readonly then
    table.insert(flags, '[RO]')
  end

  if not buffer.modifiable then
    table.insert(flags, '[-]')
  end

  if buffer.modified then
    table.insert(flags, '[+]')
  end

  return table.concat(flags)
end

local function get_buffer_name(buffer)
  local class = 'listed'
  local level = buffer.current and 'active' or 'inactive'

  class = buffer.modified and 'modified' or class
  class = buffer.terminal and 'terminal' or class

  if not buffer.current then
    return set_hlgroup(string.format(' %d ', buffer.bufnr), class, level)
  end

  local name = vim.fn.bufname(buffer.bufnr)
  local flags = get_buffer_flags(buffer)
  local prefix = set_hlgroup(string.format(' %d: ', buffer.bufnr), class, level)
  local suffix = set_hlgroup(' ', class, level)

  if flags ~= '' then
    suffix = set_hlgroup(string.format(' %s ', flags), class, level)
  end

  if name == '' then
    name = set_hlgroup('[No Name]', class, level)
    return string.format('%s%s%s', prefix, name, suffix)
  end

  local full = vim.fn.fnamemodify(name, ':p')
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
  local head, tail = '', ''

  if class == 'terminal' then
    head = 'term://'
    tail = string.gsub(full, head, '')
  end

  if class ~= 'terminal' then
    if string.find(full, cwd, 1, true) then
      head = vim.fn.fnamemodify(cwd, ':~')
      tail = vim.fn.fnamemodify(full, string.format(':s?%s??', cwd))
    else
      tail = vim.fn.fnamemodify(full, ':~')
    end
  end

  head = set_hlgroup(head, class, 'active_low')
  tail = set_hlgroup(tail, class, 'active')

  return string.format('%s%s%s%s', prefix, head, tail, suffix)
end

local function set_colorscheme()
  local augroup = vim.api.nvim_create_augroup('Tabline', {})

  for class, levels in pairs(colorscheme) do
    for level, args in pairs(levels) do
      local arg = {}
      for k, v in pairs(args) do
        table.insert(arg, string.format('%s=%s', k, v))
      end

      local hlgroup = string.format('Tabline_%s_%s', class, level)
      local command = string.format('hi %s %s', hlgroup, table.concat(arg, ' '))

      vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {group = augroup, command = command})
    end
  end
end

local function set_tabline()
  vim.o.showtabline = 2
  vim.o.tabline = [[%!luaeval('require("tabline").build_tabline()')]]
end

function M.build_tabline()
  local buffers = get_buffers()
  local separator = set_hlgroup('|', 'separator', 'default')
  local tabline = {}

  for _, buffer in ipairs(buffers) do
    table.insert(tabline, get_buffer_name(buffer))
  end

  return table.concat(tabline, separator)
end

function M.setup()
  set_colorscheme()
  set_tabline()
end

return M
