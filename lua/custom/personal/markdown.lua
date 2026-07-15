-- Check the directory for a .md named after the directory, create if it does not exist.
-- Open it up and create a vertical split buffer for it.
local pers = {
  buf = -1,
}

vim.api.nvim_create_user_command('Mdd', function()
  local dirName = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local fileName = dirName .. '.md'

  vim.cmd('vertical rightbelow 60split | e ' .. fileName)

  -- Not really needed
  pers.buf = vim.api.nvim_get_current_buf()

  vim.keymap.set('n', 'q', ':q<CR>', { buf = pers.buf })
end, { desc = 'Open/Create .md file for this directory' })

vim.keymap.set('n', '<leader>md', ':Mdd<CR>', { desc = 'Creates/Opens a markdown file for the current dir' })
