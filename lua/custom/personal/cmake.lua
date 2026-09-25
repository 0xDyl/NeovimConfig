vim.api.nvim_create_user_command('Build', function()
  -- Get local directory name
  local folderName = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

  -- Check if CMakeLists.txt exists
  if vim.fn.filereadable 'CMakeLists.txt' == 0 then
    local templateSkeleton = [[
cmake_minimum_required(VERSION 3.10)

project(%s)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(%s main.cpp)
]]

    local template = string.format(templateSkeleton, folderName, folderName)

    local file = io.open('CMakeLists.txt', 'w')

    if file then
      file:write(template)
      file:close()
    end
  end

  -- Check if build directory exists
  if vim.fn.isdirectory 'build' == 0 then vim.cmd '!cmake -B build -S .' end
  vim.cmd '!cmake --build build'

  -- local exe = './build/' .. folderName
  local current_file = vim.fn.expand '%:t:r'
  local exe = './build/bin' .. current_file

  if vim.fn.executable(exe) == 1 then vim.cmd('vertical rightbelow 40split | terminal ' .. exe) end

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  -- Create a closing keymap for the output buffer
  vim.keymap.set('n', 'q', ':q<CR>', { buf = buf })
end, { desc = 'Builds/Recompile current C++ project' })

vim.keymap.set('n', '<leader>cp', function() vim.cmd 'Build' end, { desc = 'Build/Compile C++ project using CMake' })
