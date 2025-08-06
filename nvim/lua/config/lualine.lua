local navic = require "nvim-navic"

local function pomo_status()
	local status, remaining, cycles = require("pomo").status()
	if status == "running" then
		local minutes = math.floor(remaining / 60)
		local seconds = remaining % 60
		return string.format("🍅 S%d %02d:%02d", cycles + 1, minutes, seconds)
	elseif status == "break" then
		return string.format("☕ Break (%d)", cycles)
	else
		return cycles > 0 and string.format("✅ %d", cycles) or ""
	end
end

require("lualine").setup {
	options = {
		theme = "rose-pine",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = {}, winbar = {} },
	},
	sections = {
		lualine_a = {
			{ "mode", icon = "", right_padding = 2 },
		},
		lualine_b = {
			{ "branch", icon = "" },
			{
				"diff",
				colored = true,
				symbols = { added = " ", modified = " ", removed = " " },
			},
		},
		lualine_c = {
			{
				"filename",
				icon = "",
				file_status = true,
				newfile_status = true,
				path = 1,
				symbols = {
					modified = "●",
					readonly = "",
					unnamed = "[No Name]",
					newfile = "",
				},
			},
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
				color = { fg = "#9CDCFE" },
			},
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_lsp" },
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = " ",
				},
				colored = true,
				update_in_insert = false,
			},
			{
				"filetype",
				icon_only = true,
				separator = "",
				padding = { left = 1, right = 1 },
			},
		},
		lualine_y = {
			{ pomo_status },
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
	extensions = { "oil", "toggleterm", "lazy", "nvim-tree", "man", "quickfix" },
}
