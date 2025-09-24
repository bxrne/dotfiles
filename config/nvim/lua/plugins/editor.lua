-- Editor enhancement plugins
return {
	-- Auto-detect indent settings
	"tpope/vim-sleuth",
	{
		"bxrne/diagrascii.nvim",
		config = function()
			require("diagrascii").setup {
				border_char = "+",
				horizontal_char = "-",
				vertical_char = "|",
				arrow_char = "->",
			}
		end,
	},
	{
		"bxrne/euporie.nvim",
		opts = {
			path = ".", -- Directory to open the notebook session in
			graphics_dpi = 9000, -- DPI for graphics rendering (default: 300)
			graphics_height = 100, -- Maximum graphics height in pixels (default: 40)
		},
	},
	{
		"ramilito/kubectl.nvim",
		version = "2.*",
		dependencies = "saghen/blink.download",
		config = function()
			require("kubectl").setup()
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",

		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	-- Preview papers
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- File explorer and fuzzy finder
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require "config.fzf-lua",
	},

	-- Enhanced terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = require "config.toggleterm",
	},

	-- Fast file navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = require "config.harpoon",
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
			require("nvim-treesitter.configs").setup(require "config.treesitter")
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
		opts = function()
			return require "config.conform"
		end,
	},

	-- Amp IDE integration
	{
		"sourcegraph/amp.nvim",
		branch = "main",
		lazy = false,
		opts = { auto_start = true, log_level = "info" },
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false, -- important: ensures keymaps always loaded
	},
}
