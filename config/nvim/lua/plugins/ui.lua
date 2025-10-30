-- UI and visual plugins
return {
	-- Icons (consolidated)
	{
		"nvim-tree/nvim-web-devicons",
		version = false,
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},

	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
		},
		config = require "config.opencode",
	},

	-- Theme

	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("everforest").setup {
				background = "medium",
				transparent_background_level = 0,
				italics = true,
				disable_italic_comments = false,
				ui_contrast = "low",
				diagnostic_virtual_text = "coloured",
			}
			vim.cmd.colorscheme "everforest"
		end,
	},

	-- transparent
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup(require "config.transparent")
			vim.cmd "TransparentEnable"
		end,
	},

	-- Better buffer tabs (replacing barbar for performance)
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup(require "config.bufferline")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
		config = function()
			require "config.lualine"
		end,
	},

	-- Navigation breadcrumbs
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("nvim-navic").setup {
				highlight = true,
				separator = " › ",
				depth_limit = 0,
				depth_limit_indicator = "..",
			}
		end,
	},

	-- Loading notifications
	{
		"j-hui/fidget.nvim",
		opts = {},
	},

	-- Symbols outline
	{
		"simrat39/symbols-outline.nvim",
		config = require "config.symbols-outline",
	},

	-- Pomodoro timer
	{
		"bxrne/pomo.nvim",
		name = "pomo",
		opts = {
			session_minutes = 1,
			break_minutes = 2,
		},
		config = function()
			require("pomo").setup {}
		end,
	},
}
