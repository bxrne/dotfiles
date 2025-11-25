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
		"loctvl842/monokai-pro.nvim",
		config = function()
			require("monokai-pro").setup({
				transparent_background = false,
				terminal_colors = true,
				devicons = true,
				styles = {
					comment = { italic = true },
					keyword = { italic = true },
					type = { italic = true },
					storageclass = { italic = true },
					structure = { italic = true },
					parameter = { italic = true },
					annotation = { italic = true },
					tag_attribute = { italic = true },
				},
				filter = "ristretto",
				day_night = {
					enable = false,
				},
				inc_search = "background",
				background_clear = {
					"toggleterm",
					"telescope",
					"renamer",
					"notify",
				},
				plugins = {
					bufferline = {
						underline_selected = false,
						underline_visible = false,
					},
					indent_blankline = {
						context_highlight = "default",
						context_start_underline = false,
					},
				},
				override = function(c)
					return {
						NonText = { fg = "#948a8b" },
						MiniIconsGrey = { fg = "#948a8b" },
						MiniIconsRed = { fg = "#fd6883" },
						MiniIconsBlue = { fg = "#85dacc" },
						MiniIconsGreen = { fg = "#adda78" },
						MiniIconsYellow = { fg = "#f9cc6c" },
						MiniIconsOrange = { fg = "#f38d70" },
						MiniIconsPurple = { fg = "#a8a9eb" },
						MiniIconsAzure = { fg = "#a8a9eb" },
						MiniIconsCyan = { fg = "#85dacc" },
					}
				end,
			})
			vim.cmd([[colorscheme monokai-pro]])
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
