local personal_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'personal')
for file_name, type in vim.fs.dir(personal_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.personal.' .. module)
  end
end
