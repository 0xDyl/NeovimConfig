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

vim.keymap.set('n', '<leader>ct', function()
  local active_theme = vim.g.colors_name
  local current_index = nil

  for i, theme in ipairs(themes) do
    if theme == active_theme then
      current_index = i
      break
    end
  end

  local next_i = current_index + 1

  if next_i > #themes then next_i = 1 end

  vim.cmd('colorscheme ' .. themes[next_i])
  print('Active theme:' .. vim.g.colors_name)
end, { desc = 'Cycles through themes' })
