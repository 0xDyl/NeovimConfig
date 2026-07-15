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

-- Current colorscheme -> Possibly set this up in a file to make it persistent with UI changes (Started below line 61.)
vim.cmd 'colorscheme kanagawa'

local function change_theme(theme) vim.cmd('colorscheme ' .. theme) end

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
-- local filepath = '~/.config/nvim/lua/custom/plugins/currenttheme.txt'
-- local file = io.open(filepath, 'r')
-- if file then
--   local theme = file:read '*l'
--   vim.cmd('colorscheme ' .. theme)
-- end

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
