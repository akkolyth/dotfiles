-- lsp.lua

local lsp = require("lsp-zero")

-- Use recommended preset
lsp.preset("recommended")

-- Setup Mason
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"pyright", -- Python
		"lua_ls", -- Lua (was sumneko_lua)
	},
	handlers = {
		lsp.default_setup,
	},
})

-- nvim-cmp setup
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

lsp.extend_cmp()

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list (loclist)" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "Telescope diagnostics" })

vim.keymap.set("n", "<leader>Q", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { desc = "Populate quickfix with diagnostics and open" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
