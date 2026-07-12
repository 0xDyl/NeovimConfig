-- Possibly add a daily todo instead, so compares edit time to see if a day has passed and then resets all check to incomplete.
local function create_floating_window()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'Todo')

  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  local win_width = math.floor(screen_width * 0.45)
  local win_height = math.floor(screen_height * 0.45)

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

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Sets the close window keybind
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  return buf, win
end

local filepath = vim.fn.expand '~/.config/helper-files/todo.txt'

vim.keymap.set('n', '<leader>td', function()
  local buf, win = create_floating_window()

  -- Read file
  local lines = {}

  if vim.fn.filereadable(filepath) == 1 then
    for line in io.lines(filepath) do
      table.insert(lines, line)
    end
  else
    lines = { 'Nothing found' }
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWriteCmd' }, {
    buffer = buf,
    callback = function()
      local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local file = io.open(filepath, 'w')
      if file then
        for _, line in ipairs(current_lines) do
          file:write(line .. '\n')
        end
        file:close()
      end
    end,
  })

  -- Will make checkboxes
  vim.keymap.set('n', '<CR>', function()
    local line = vim.api.nvim_get_current_line()
    local line_i = vim.api.nvim_win_get_cursor(0)[1]

    if string.find(line, '%[ %]') then
      local newline = string.gsub(line, '%[ %]', '%[x%]')
      vim.api.nvim_buf_set_lines(0, line_i - 1, line_i, false, { newline })
    elseif string.find(line, '%[x%]') then
      local newline = string.gsub(line, '%[x%]', '%[ %]')
      vim.api.nvim_buf_set_lines(0, line_i - 1, line_i, false, { newline })
    end
  end, { buf = buf })
end, { desc = 'Opens Todo-list' })
