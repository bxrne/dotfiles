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

	-- Theme

	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require("onedark").setup({
				style = "warmer",
				transparent = true,
				code_style = {
					comments = "italic",
					keywords = "none",
					functions = "none",
					strings = "none",
					variables = "none",
				},
					highlights = {
					ColorColumn = { bg = "#2c313c" },
					CursorLine = { bg = "#2c313c" },
					FloatBorder = { bg = "NONE" },
					NormalFloat = { bg = "NONE" },
					NeoTreeFloatBorder = { bg = "NONE" },
					NeoTreeNormal = { bg = "NONE" },
					NeoTreeNormalNC = { bg = "NONE" },
					TabLine = { bg = "NONE" },
					TabLineFill = { bg = "NONE" },
					TabLineSel = { bg = "NONE" },
					StatusLine = { bg = "NONE" },
					StatusLineNC = { bg = "NONE" },
					WinSeparator = { bg = "NONE" },
					VertSplit = { bg = "NONE" },
					DiagnosticWarn = { fg = "#d19a66" },
					DiagnosticHint = { fg = "#d19a66" },
					DiagnosticInfo = { fg = "#c0c4cc" },
				},
			})
			require("onedark").load()
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

	-- File tree explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = require "config.neotree",
	},
}
