require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
	},
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ bufnr = 0 })
end)
