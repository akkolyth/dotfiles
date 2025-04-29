-- This file can be loaded by calling lua require('plugins') from your init.vim

-- Only required if you have packer configured as opt
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			vim.cmd("TSUpdate")
		end,
	})
	use("theprimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use({
		"projekt0n/github-nvim-theme",
		config = function()
			vim.cmd("colorscheme github_dark_default")
		end,
	})
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	})
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
end)
