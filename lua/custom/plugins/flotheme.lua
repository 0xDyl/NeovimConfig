local themes_git = {
  'https://github.com/savq/melange-nvim.git',
  'https://github.com/folke/tokyonight.nvim.git',
  'https://github.com/rebelot/kanagawa.nvim.git',
  'https://github.com/catppuccin/nvim',
}

for _, repo in ipairs(themes_git) do
  vim.pack.add { repo }
end

local themes = {
  'melange',
  'tokyonight-night',
  'kanagawa',
  'catppuccin-mocha',
}

-- Check if a theme is stored in the text file and set if so.
local filepath = vim.fn.expand '~/.config/nvim/lua/custom/plugins/currenttheme.txt'

if vim.fn.filereadable(filepath) then
  for line in io.lines(filepath) do
    vim.cmd('colorscheme ' .. line)
  end
end

local function change_theme(theme)
  vim.cmd('colorscheme ' .. theme)
  local file = io.open(filepath, 'w')
  if file then file:write(theme) end
end

local function create_floating_window()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'Theme Switcher')

  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  local win_width = math.floor(screen_width * 0.10)
  local win_height = #themes

  local row = math.floor((screen_height - win_height) / 2)
  local col = math.floor((screen_width - win_width) / 2)

  local win_opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- "wipe" means just delete the buffer when it is hidden off screen
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  -- Sets the close window keybind
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
    -- vim.api.nvim_buf_delete(buf, { force = true }) -- Was using before the above "wipe"
  end)

  return buf, win
end

-- Will set default every startup
local default = 'kanagawa'
vim.cmd('colorscheme ' .. default)

vim.keymap.set('n', '<leader>ct', function()
  local buf, win = create_floating_window()
  local active_theme = vim.g.colors_name
  local current_index = nil

  -- Populate Window with themes
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, themes)

  vim.keymap.set('n', '<CR>', function()
    local current_theme = vim.api.nvim_get_current_line()

    change_theme(current_theme)
  end, { buf = buf, silent = true })
end, { desc = 'Opens the theme switcher' })
