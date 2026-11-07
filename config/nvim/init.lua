vim.cmd("syntax enable")

vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.ruler = true

vim.api.nvim_set_hl(0, "Comment", { fg = "#50c878", ctermfg = 2 })
