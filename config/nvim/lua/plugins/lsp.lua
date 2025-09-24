-- LSP configuration
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
return {
	-- Mason for LSP management
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"gopls",

			},
			automatic_installation = true,
		},
	},
	-- Main LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"SmiteshP/nvim-navic",
		},
		config = require "config.lsp",
	},
}
