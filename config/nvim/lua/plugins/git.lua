-- Git integration plugins
return {
	-- Git client
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
		config = require "config.git",
	},

	-- Lazygit integration
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs_staged_enable = true,
			signcolumn = true,
			numhl = true,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false,
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = {
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
}
