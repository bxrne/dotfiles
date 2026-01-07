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

			cmp.setup(require "config.completion"())

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

	-- GitHub Copilot
	{
		"github/copilot.vim",
		cmd = "Copilot",
		event = "BufRead",
		config = function()
			vim.g.copilot_context = "git"
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_enabled = false
		end,
	},

	-- Cursor IDE integration
	{
		"h4kbas/cursor.nvim",
		lazy = true,
		cmd = "CursorChat",
		config = function()
			require("cursor").setup(require "config.cursor")
		end,
	},

	-- UI improvements for vim.ui.select
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
}
