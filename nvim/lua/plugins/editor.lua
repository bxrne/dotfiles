-- Editor enhancement plugins
return {
	-- Auto-detect indent settings
	"tpope/vim-sleuth",

	-- Preview papers
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		opts = {},
	},

	-- File explorer
	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			win_options = { signcolumn = "yes" },
		},
		config = function()
			require("oil").setup {
				default_file_explorer = true,
				skip_confirm_for_simple_edits = true,
				columns = { "permissions", "size", "icons", "mtime" },
				view_options = {
					show_hidden = true,
				},
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
				},
				watch_for_changes = true,
			}
			vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })
		end,
	},

	-- Enhanced terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup {
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_terminals = true,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
				},
			}

			-- Terminal keymaps
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
			vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
			vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })
		end,
	},

	-- Fast file navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require "harpoon"
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add to harpoon" })
			vim.keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon menu" })

			-- Quick file access
			for i = 1, 4 do
				vim.keymap.set("n", "<leader>" .. i, function()
					harpoon:list():select(i)
				end, { desc = "Harpoon file " .. i })
			end

			vim.keymap.set("n", "<leader>hp", function()
				harpoon:list():prev()
			end, { desc = "Previous harpoon" })
			vim.keymap.set("n", "<leader>hn", function()
				harpoon:list():next()
			end, { desc = "Next harpoon" })
		end,
	},

	-- Telescope for fuzzy finding
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable "make" == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			require "config.telescope"
		end,
	},

	-- Comments
	{ "numToStr/Comment.nvim", opts = {} },

	-- Auto-save
	{
		"https://git.sr.ht/~nedia/auto-save.nvim",
		event = { "BufReadPre" },
		opts = {
			events = { "InsertLeave", "BufLeave" },
			silent = true,
		},
	},

	-- Color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Remote development
	{
		"amitds1997/remote-nvim.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},

	-- Auto-save session (was.nvim)
	{
		"bxrne/was.nvim",
		version = "v0.0.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		opts = {
			defer_time = 2500,
		},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true },
	},

	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"vim",
					"vimdoc",
					"go",
					"typescript",
					"yaml",
					"cpp",
					"json",
					"python",
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
			}
		end,
	},

	-- Code formatting
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format { async = true, lsp_fallback = true }
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				go = { "gofmt" },
				rust = { "rustfmt" },
				groovy = { "groovyformatter" },
				ruby = { "rubocop" },
			},
		},
	},
}
