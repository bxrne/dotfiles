-- LSP configuration
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
				"pyright",
				"tsserver",
				"zls",
				"rust-analyzer",
				"stylua",
				"shellcheck",
				"shfmt",
				"marksman",
				"clangd",
				"omnisharp",
				"jsonls",
				"taplo",
				"yamlls",
				"htmx-lsp",
				"prettytypst",
				"bashls",
				"cssls",
				"black",
				"prettier",
				"rustfmt",
				"zig",
				"clang-format",
				"csharpier",
				"gofmt",
			},
		},
	},

	-- Mason LSP config bridge
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = { "gopls", "ts_ls", "lua_ls", "pyright", "zls", "rust_analyzer", "clangd", "omnisharp", "jsonls", "taplo", "yamlls", "marksman", "htmx", "bashls", "cssls" },
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

