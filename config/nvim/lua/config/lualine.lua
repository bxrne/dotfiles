local navic = require("nvim-navic")

require("lualine").setup({
	options = {
		theme = {
			normal = {
				a = { bg = "#000000", fg = "#d79921", gui = "bold" },
				b = { bg = "#d79921", fg = "#000000" },
				c = { bg = "#d79921", fg = "#000000" },
			},
			insert = {
				a = { bg = "#000000", fg = "#fabd2f", gui = "bold" },
				b = { bg = "#d79921", fg = "#000000" },
				c = { bg = "#d79921", fg = "#000000" },
			},
			visual = {
				a = { bg = "#000000", fg = "#d3869b", gui = "bold" },
				b = { bg = "#d79921", fg = "#000000" },
				c = { bg = "#d79921", fg = "#000000" },
			},
			replace = {
				a = { bg = "#000000", fg = "#cc241d", gui = "bold" },
				b = { bg = "#d79921", fg = "#000000" },
				c = { bg = "#d79921", fg = "#000000" },
			},
			inactive = {
				a = { bg = "#d79921", fg = "#000000" },
				b = { bg = "#d79921", fg = "#000000" },
				c = { bg = "#d79921", fg = "#000000" },
			},
		},
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = {}, winbar = {} },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{ "branch", icon = "" },
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
		},
		lualine_c = {
			{ "filename", icon = "" },
			{
				function()
					local line = vim.fn.line(".")
					local file = vim.fn.expand("%")
					local result = vim.fn.system("git blame --porcelain -L " .. line .. "," .. line .. " " .. file .. " 2>/dev/null")
					local hash = result:match("^(%w+)")
					if hash then
						local summary = vim.fn.system("git show --format=%s -s " .. hash .. " 2>/dev/null"):gsub("\n", "")
						local author = result:match("author (.-)\n")
						if author and summary then
							return " " .. author .. ": " .. summary
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
						return "  " .. lsp_str
					else
						return ""
					end
				end,
			},
			{
				"diagnostics",
				sources = { "nvim_lsp" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = false, -- Disable distinct diagnostic colors to stick to black/amber
				update_in_insert = false,
			},
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_c = {
			{
				function()
					local filename = vim.fn.expand("%:t")
					if filename == "" or filename == "[No Name]" then
						return ""
					else
						return " " .. vim.fn.pathshorten(vim.fn.expand("%:~"))
					end
				end,
				icon = " ",
				file_status = true,
				symbols = { modified = " ●", readonly = " ", unnamed = "", newfile = " " },
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
					local filename = vim.fn.expand("%:t")
					if filename == "" or filename == "[No Name]" then
						return ""
					else
						return " " .. vim.fn.pathshorten(vim.fn.expand("%:~"))
					end
				end,
				icon = " ",
				file_status = true,
				symbols = { modified = " ●", readonly = " ", unnamed = "", newfile = " " },
			},
		},
	},
})
