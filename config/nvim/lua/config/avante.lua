return {
	providers = {
		copilot = {
			endpoint = "https://api.githubcopilot.com",
			model = "gpt-4o-2024-05-13",
			proxy = nil,
			allow_insecure = false,
			timeout = 30000,
			extra_request_body = {
				temperature = 0,
				max_tokens = 4096,
			},
		},
	},
	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
	},
	mappings = {
		--- @class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
	},
	hints = { enabled = true },
	windows = {
		position = "right",
		wrap = true,
		width = 30,
		sidebar_header = {
			align = "center",
			rounded = true,
		},
	},
	highlights = {
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	--- @type AvanteConflictUserConfig
	diff = {
		autojump = true,
		debug = false,
		list_opener = "copen",
	},
}