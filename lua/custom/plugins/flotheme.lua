local function create_floating_window()
  local buf = vim.api.nvim_create_buf(true, false)

  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  local win_width = math.floor(screen_width * 0.10)
  local win_height = math.floor(screen_height * 0.10)

  local row = math.floor((screen_height - win_height) / 2)
  local col = math.floor((screen_width - win_width) / 2)

  local win_opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  -- Sets the close window keybind
  vim.keymap.set('n', 'q', function() vim.api.nvim_buf_delete(buf, { force = true }) end)

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return buf, win
end

-- Above is floating window logic only

local function change_theme(theme)
  vim.cmd('colorscheme ' .. theme)
  print('Current theme: ' .. theme)
end

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

-- Will set default every startup
local default = 'melange'
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
