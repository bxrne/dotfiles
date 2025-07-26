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
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

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
		event = "VeryLazy",
		lazy = false,
		version = false,
		opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "gpt-4o-2024-05-13",
				proxy = nil,
				allow_insecure = false,
				timeout = 30000,
				temperature = 0,
				max_tokens = 4096,
			},
		},
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