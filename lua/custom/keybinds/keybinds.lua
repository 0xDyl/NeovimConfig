-- Opens the oil buffer of the current file
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil Buffer' })

-- Delete current buffer
vim.keymap.set('n', '<leader>bd', function() vim.api.nvim_buf_delete(0, { force = false }) end, { desc = 'Deletes the current buffer' })

-- Opens new windows; both vertical and horizontal
vim.keymap.set('n', '<leader>-', '<cmd>split<CR>', { desc = 'Open a new horizontal window' })
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Open a new vertical window' })
