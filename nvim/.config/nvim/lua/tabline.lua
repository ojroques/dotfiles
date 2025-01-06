-------------------- VARIABLES -------------------------------------------------
local M = {}
local colors = {  -- onedark
  black =      '#181A1F',
  blue =       '#61AFEF',
  cyan =       '#56B6C2',
  green =      '#98C379',
  grey =       '#5C6370',
  grey_light = '#31353F',
  purple =     '#C678DD',
  red =        '#E86671',
  white =      '#ABB2BF',
  yellow =     '#E5C07B',
}
local colorscheme = {
  separator = {
    default = {guifg = colors.grey, guibg = colors.grey_light},
  },
  listed = {
    inactive = {guifg = colors.green, guibg = colors.grey_light},
    active = {guifg = colors.black, guibg = colors.green},
    active_low = {guifg = colors.grey, guibg = colors.green},
  },
  modified = {
    inactive = {guifg = colors.blue, guibg = colors.grey_light},
    active = {guifg = colors.black, guibg = colors.blue},
    active_low = {guifg = colors.grey, guibg = colors.blue},
  },
  terminal = {
    inactive = {guifg = colors.red, guibg = colors.grey_light},
    active = {guifg = colors.black, guibg = colors.red},
    active_low = {guifg = colors.grey, guibg = colors.red},
  },
}

-------------------- PRIVATE ---------------------------------------------------
local function set_hlgroup(text, class, level)
  local hlgroup = string.format('Tabline_%s_%s', class, level)

  if vim.fn.hlexists(hlgroup) == 0 then
    return text
  end

  return string.format('%%#%s#%s%%*', hlgroup, text)
end

local function is_excluded(bufnr)
  return vim.fn.buflisted(bufnr) == 0 or vim.fn.getbufvar(bufnr, '&filetype') == 'qf'
end

local function get_buffers()
  local buffers = {}
  local current_bufnr = vim.fn.bufnr()
  local last_timestamp, last_buffer

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

      if not last_timestamp or bufinfo.lastused > last_timestamp then
        last_timestamp, last_buffer = bufinfo.lastused, buffer
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
    return set_hlgroup(tostring(buffer.bufnr), class, level)
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

-------------------- PUBLIC ----------------------------------------------------
function M.build_tabline()
  local buffers = get_buffers()
  local separator = set_hlgroup('|', 'separator', 'default')
  local tabline = {}

  for _, buffer in ipairs(buffers) do
    table.insert(tabline, get_buffer_name(buffer))
  end

  return table.concat(tabline, separator)
end

-------------------- SETUP -----------------------------------------------------
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

function M.setup()
  set_colorscheme()
  set_tabline()
end

--------------------------------------------------------------------------------
return M
