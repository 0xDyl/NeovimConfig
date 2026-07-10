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

local filepath = vim.fn.expand '~/scratchpad.txt'

vim.keymap.set('n', '<leader>os', function()
  local buf, win = create_floating_window()
  local file = io.open(filepath, 'a')

  -- Read file
  local lines = {}

  if file then
    for _, line in io.lines(filepath) do
      table.insert(lines, line)
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
end, { desc = 'Opens a scratchpad' })
