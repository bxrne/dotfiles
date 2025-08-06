return {
	cmdline = {
		enabled = true,
		view = "cmdline_popup", -- floating centered command-line
		format = {
			cmdline = { icon = "" },
			search_down = { icon = "🔍 " },
			search_up = { icon = "🔍 " },
		},
	},
	views = {
		cmdline_popup = {
			position = {
				row = "50%",
				col = "50%",
			},
			border = {
				style = "rounded",
			},
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
			},
		},
	},
	messages = { enabled = false }, -- disable message area hijack if not needed
	notify = { enabled = true },
}