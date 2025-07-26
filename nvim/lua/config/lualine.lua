-- Status line configuration
local navic = require("nvim-navic")

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", right_padding = 2 } },
		lualine_b = {
			{
				"branch",
				icon = "",
			},
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
			},
		},
		lualine_c = {
			{
				"filename",
				file_status = true,
				newfile_status = false,
				path = 1,
				symbols = {
					modified = "[+]",
					readonly = "[-]",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			},
			{
				function()
					if navic.is_available() then
						return navic.get_location()
					end
					return ""
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_lsp" },
				symbols = { error = " ", warn = " ", info = " " },
				always_visible = false,
			},
		},
		lualine_y = {
			{ "progress" },
		},
		lualine_z = {
			{ "location" },
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "oil", "toggleterm", "lazy" },
})