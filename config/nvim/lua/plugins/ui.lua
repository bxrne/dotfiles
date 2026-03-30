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
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
				terminal_colors = true,
				theme = {
					variant = "default",
					highlights = {
						-- Custom amber accents
						Comment = { fg = "#7c6f64", italic = true },
						String = { fg = "#a89984" },
						Function = { fg = "#d79921", bold = true },
						Keyword = { fg = "#d79921", italic = true },
						Identifier = { fg = "#c1c1c1" },
						Constant = { fg = "#d79921" },
						Type = { fg = "#d79921" },
						Statement = { fg = "#d79921" },
						Operator = { fg = "#d79921" },
						DiagnosticWarn = { fg = "#d79921" },
						DiagnosticHint = { fg = "#d79921" },
						-- Transparency overrides
						ColorColumn = { bg = "#121212" },
						CursorLine = { bg = "#121212" },
						FloatBorder = { bg = "NONE", fg = "#d79921" },
						NormalFloat = { bg = "NONE" },
						NeoTreeFloatBorder = { bg = "NONE", fg = "#d79921" },
						NeoTreeNormal = { bg = "NONE" },
						NeoTreeNormalNC = { bg = "NONE" },
						WinSeparator = { bg = "NONE", fg = "#3c3836" },
						VertSplit = { bg = "NONE", fg = "#3c3836" },
					}
				}
			})
			vim.cmd("colorscheme cyberdream")
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
