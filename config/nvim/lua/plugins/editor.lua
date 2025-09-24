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
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- this will download prebuild binary or try to use existing rustup toolchain to build from source
			-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
			require("fff.download").download_or_build_binary()
		end,
		-- if you are using nixos
		-- build = "nix run .#release",
		opts = { -- (optional)
			debug = {
				enabled = false,
				show_scores = true,
			},
		},
		lazy = false,
		keys = {
			{
				"ff", -- try it if you didn't it is a banger keybinding for a picker
				function()
					require("fff").find_files()
				end,
				desc = "FFFind files",
			},
			{
				"fg",
				function()
					require("fff").live_grep()
				end,
				desc = "LiFFFe grep",
			},
			{
				"fz",
				function()
					require("fff").live_grep {
						grep = {
							modes = { "fuzzy", "plain" },
						},
					}
				end,
				desc = "Live fffuzy grep",
			},
			{
				"fc",
				function()
					require("fff").live_grep { query = vim.fn.expand "<cword>" }
				end,
				desc = "Search current word",
			},
		},
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
