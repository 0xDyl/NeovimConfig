vim.pack.add { 'https://github.com/Civitasv/cmake-tools.nvim' }

-- 1. Configure / Generate the workspace (Like running 'cmake ..')
vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>', { desc = '[C]Make [G]enerate Workspace' })

-- 2. Compile everything (Like running 'cmake --build .')
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { desc = '[C]Make [B]uild Code' })

-- 3. Execute the binary output instantly
vim.keymap.set('n', '<leader>cr', ':CMakeRun<CR>', { desc = '[C]Make [R]un Binary' })
