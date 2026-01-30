require("config.lazy")

-- Set tabs to visually appear as 2 spaces
vim.opt.tabstop = 2       -- 1 tab = 2 spaces (display)
vim.opt.shiftwidth = 2    -- Indentation width = 2 spaces
vim.opt.softtabstop = 2   -- Treat 2 spaces as a tab during editing
vim.opt.expandtab = true  -- Convert tabs to spaces

-- SHOW LINE
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorline = true

vim.opt.spelloptions = 'camel'

-- ALIAS
vim.cmd([[
  command! W w
]])
