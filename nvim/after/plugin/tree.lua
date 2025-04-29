vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
	update_focused_file = {
		enable = true,
		update_root = false,
		ignore_list = {},
	},
	view = {
		width = 50,
		side = "left",
		preserve_window_proportions = true,
	},
})

vim.keymap.set('n', '<leader>b', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
