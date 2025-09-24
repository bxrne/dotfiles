local navic = require "nvim-navic"

-- local function pomo_status()
-- 	local status, remaining, cycles = require("pomo").status()
-- 	if status == "running" then
-- 		local minutes = math.floor(remaining / 60)
-- 		local seconds = remaining % 60
-- 		return string.format("🍅 S%d %02d:%02d", cycles + 1, minutes, seconds)
-- 	elseif status == "break" then
-- 		return string.format("☕ Break (%d)", cycles)
-- 	else
-- 		return cycles > 0 and string.format("✅ %d", cycles) or ""
-- 	end
-- end

	require("lualine").setup {
	options = {
		theme = {
			normal = {
				a = { bg = "#121212", fg = "#8A8A8D" },
				b = { bg = "#121212", fg = "#BEBEBE" },
				c = { bg = "#121212", fg = "#BEBEBE" },
			},
			insert = {
				a = { bg = "#121212", fg = "#FFC107" },
				b = { bg = "#121212", fg = "#BEBEBE" },
				c = { bg = "#121212", fg = "#BEBEBE" },
			},
			visual = {
				a = { bg = "#121212", fg = "#E68E0D" },
				b = { bg = "#121212", fg = "#BEBEBE" },
				c = { bg = "#121212", fg = "#BEBEBE" },
			},
			replace = {
				a = { bg = "#121212", fg = "#D35F5F" },
				b = { bg = "#121212", fg = "#BEBEBE" },
				c = { bg = "#121212", fg = "#BEBEBE" },
			},
		},
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = {}, winbar = {} },
	},
	sections = {
		lualine_a = {},
		lualine_b = {
			{ "branch", icon = "" },
			{
				"diff",
				symbols = { added = "+", modified = "~", removed = "-" },
			},
		},
		lualine_c = {
			{ "filename", icon = "" },
			{
				function()
					local line = vim.fn.line "."
					local file = vim.fn.expand "%"
					local result = vim.fn.system("git blame --porcelain -L " .. line .. "," .. line .. " " .. file .. " 2>/dev/null")
					local hash = result:match "^(%w+)"
					if hash then
						local summary = vim.fn.system("git show --format=%s -s " .. hash .. " 2>/dev/null"):gsub("\n", "")
						local author = result:match "author (.-)\n"
						if author and summary then
							return author .. ": " .. summary
						end
					end
					return ""
				end,
			},
		},
		lualine_x = {
			{
				function()
					local clients = vim.lsp.get_active_clients()
					local seen = {}
					local names = {}
					for _, client in ipairs(clients) do
						if not seen[client.name] then
							seen[client.name] = true
							table.insert(names, client.name)
						end
					end
					if #names > 0 then
						local lsp_str = table.concat(names, ", ")
						return "lsp: " .. lsp_str
					else
						return ""
					end
				end,
			},
			{
				"diagnostics",
				sources = { "nvim_lsp" },
				symbols = {
					error = "E",
					warn = "W",
					info = "I",
					hint = "H",
				},
				colored = true,
				update_in_insert = false,
			},
		},
		lualine_y = {},
		lualine_z = {
			{ "mode", icon = "" },
		},
	},
	winbar = {
		lualine_c = {
			{
				function()
					local filename = vim.fn.expand "%:t"
					if filename == "" or filename == "[No Name]" then
						return ""
					else
						return vim.fn.pathshorten(vim.fn.expand "%:~")
					end
				end,
				icon = "",
				file_status = true,
				newfile_status = true,
				symbols = {
					modified = "●",
					readonly = "",
					unnamed = "",
					newfile = "",
				},
			},
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
	},
	inactive_winbar = {
		lualine_c = {
			{
				function()
					local filename = vim.fn.expand "%:t"
					if filename == "" or filename == "[No Name]" then
						return ""
					else
						return vim.fn.pathshorten(vim.fn.expand "%:~")
					end
				end,
				icon = "",
				file_status = true,
				newfile_status = true,
				symbols = {
					modified = "●",
					readonly = "",
					unnamed = "",
					newfile = "",
				},
			},
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
	},
}
