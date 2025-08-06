-- Completion and AI assistance
return {
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
			},
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require "cmp"
			
			cmp.setup(require("config.completion")())

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- GitHub Copilot (faster than CopilotChat)
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_context = "git"
			vim.g.copilot_assume_mapped = true
		end,
	},

	-- Better AI chat (replacing CopilotChat for performance)
	{
		"yetone/avante.nvim",
		lazy = true,
		cmd = {
			"AvanteAsk",
			"AvanteRefresh", 
			"AvanteEdit",
			"AvanteChat",
			"AvanteBuild",
			"AvanteConflictNextConflict",
			"AvanteConflictPrevConflict",
			"AvanteConflictChooseOurs",
			"AvanteConflictChooseTheirs",
			"AvanteConflictChooseBoth",
			"AvanteConflictChooseNone",
			"AvanteConflictChooseCursor",
		},
		version = false,
		opts = function()
			return require "config.avante"
		end,
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.icons",
		},
		config = function(_, opts)
			require("avante").setup(opts)

			-- AI Chat keymaps
			vim.keymap.set("n", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante ask" })
			vim.keymap.set("v", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante ask" })
			vim.keymap.set("n", "<leader>ar", "<cmd>AvanteRefresh<cr>", { desc = "Avante refresh" })
			vim.keymap.set("n", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "Avante edit" })
		end,
	},

	-- UI improvements for vim.ui.select
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
}
