return {
	groups = { -- Default groups to clear
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLine",
		"CursorLineNr",
		"StatusLine",
		"StatusLineNC",
		"EndOfBuffer",
		-- Additional groups for better transparency
		"NormalFloat", -- Floating windows
		"FloatBorder", -- Borders of floating windows
		"NeoTreeNormal", -- Neo-tree file explorer
		"NeoTreeNormalNC", -- Neo-tree in inactive windows
		"NeoTreeFloatBorder", -- Neo-tree floating window borders
		"Terminal", -- Terminal buffers
		"WinSeparator", -- Window separators (vertical/horizontal splits)
		"WinBar", -- Window bar
		"WinBarNC", -- Window bar in inactive windows
		"TabLine", -- Tab line
		"TabLineFill", -- Tab line fill
		"TabLineSel", -- Selected tab in tab line
		"VertSplit", -- Vertical split between windows
		"Directory", -- Directory names (in special buffers)
	},
	extra_groups = {}, -- Add more groups if needed
	exclude_groups = {}, -- Groups to keep opaque
}
