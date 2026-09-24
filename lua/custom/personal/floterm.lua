-- local pers = {
--   win = -1,
--   buf = -1,
-- }
--
-- local function create_floating_window()
--   local buf
--   if pers.buf ~= -1 then
--     buf = pers.buf
--   else
--     buf = vim.api.nvim_create_buf(true, false)
--     vim.api.nvim_buf_set_name(buf, 'Terminal')
--     pers.buf = buf
--     vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buf })
--   end
--
--   local screen_width = vim.o.columns
--   local screen_height = vim.o.lines
--
--   local win_width = math.floor(screen_width * 0.50)
--   local win_height = math.floor(screen_height * 0.50)
--
--   local row = math.floor((screen_height - win_height) / 2)
--   local col = math.floor((screen_width - win_width) / 2)
--
--   local win_opts = {
--     relative = 'editor',
--     width = win_width,
--     height = win_height,
--     row = row,
--     col = col,
--     style = 'minimal',
--     border = 'rounded',
--   }
--
--   local win = vim.api.nvim_open_win(buf, true, win_opts)
--
--   -- Sets the close window keybind
--   vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end)
--
--   if pers.termActive == 0 then
--     vim.cmd 'terminal'
--     pers.termActive = 0
--   end
--
--   return buf, win
-- end
--
-- -- Needs some work to get working, mainly around reopening the previous buffer.
-- vim.keymap.set('n', '<leader>st', function()
--   pers.buf, pers.win = create_floating_window()
--
--   -- Allows you to escape terminal mode
--   vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { buf = buf })
-- end, {})

local pers = {
  win = -1,
  buf = -1,
}

local function toggle_floating_terminal()
  -- 1. If window is already open, close it (hide/toggle)
  if vim.api.nvim_win_is_valid(pers.win) then
    vim.api.nvim_win_close(pers.win, true)
    pers.win = -1
    return
  end

  -- 2. Reuse buffer if valid, otherwise create a new one
  local is_new_buf = false
  if not vim.api.nvim_buf_is_valid(pers.buf) then
    pers.buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
    vim.api.nvim_buf_set_name(pers.buf, 'Terminal')

    vim.bo[pers.buf].bufhidden = 'hide'
    is_new_buf = true
  end

  -- 3. Calculate dimensions
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

  -- 4. Open the floating window with our persistent buffer
  pers.win = vim.api.nvim_open_win(pers.buf, true, win_opts)

  -- 5. If it's a freshly created buffer, spawn the terminal job

  if is_new_buf then
    vim.fn.termopen(vim.o.shell) -- or run: vim.cmd.terminal()

    -- Buffer-local keymaps (set only once per terminal instance)
    vim.keymap.set('n', 'q', function()
      if vim.api.nvim_win_is_valid(pers.win) then
        vim.api.nvim_win_close(pers.win, true)

        pers.win = -1
      end
    end, { buffer = pers.buf, silent = true })

    vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { buffer = pers.buf })
  end

  -- Enter insert mode immediately so you can start typing
  vim.cmd 'startinsert'
end

-- Toggle mapping
vim.keymap.set({ 'n', 't' }, '<leader>st', toggle_floating_terminal, { desc = 'Toggle Floating Terminal' })
