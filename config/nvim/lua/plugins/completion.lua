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
	{
		"ThePrimeagen/99",
		config = function()
			local _99 = require "99"

			local cwd = vim.uv.cwd()
			local basename = vim.fs.basename(cwd)
			_99.setup {
				provider = _99.OpenCodeProvider,
				model = "github-copilot/gpt-4.1",
				logger = {
					level = _99.DEBUG,
					path = "/tmp/" .. basename .. ".99.debug",
					print_on_error = true,
				},

				--- Completions: #rules and @files in the prompt buffer
				completion = {
					custom_rules = {},

					--- Configure @file completion (all fields optional, sensible defaults)
					files = {
						enabled = true,
						max_file_size = 102400, -- bytes, skip files larger than this
						max_files = 5000, -- cap on total discovered files
						exclude = { ".env", ".env.*", "node_modules", ".git" },
					},

					source = "cmp",
				},

				md_files = {
					"AGENT.md",
					"README.md",
					"AGENTS.md",
					"CHANGELOG.md",
				},
			}

			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end)

			vim.keymap.set("v", "<leader>9s", function()
				_99.stop_all_requests()
			end)
		end,
	},
	-- UI improvements for vim.ui.select
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
}
