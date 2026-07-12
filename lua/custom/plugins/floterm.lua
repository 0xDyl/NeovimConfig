local pers = {
  win = -1,
  buf = -1,
}

local function create_floating_window()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, 'Terminal')

  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  local win_width = math.floor(screen_width * 0.50)
  local win_height = math.floor(screen_height * 0.50)

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

  -- "wipe" means just delete the buffer when it is hidden off screen
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  -- Sets the close window keybind
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
    -- vim.api.nvim_buf_delete(buf, { force = true }) -- Was using before the above "wipe"
  end)

  vim.cmd 'terminal'

  return buf, win
end

-- Needs some work to get working, mainly around reopening the previous buffer.
vim.keymap.set('n', '<leader>st', function()
  if pers.buf ~= -1 then
    local buf, win = create_floating_window()
  else
    print 'Showing active terminal'
  end

  pers.buf = buf
  pers.win = win

  vim.api.nvim_create_user_command('DelTermBuf', function() vim.api.nvim_buf_delete(buf, {}) end, { desc = 'Deletes the current terminal buffer' })

  vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { buf = buf })
end, {})
