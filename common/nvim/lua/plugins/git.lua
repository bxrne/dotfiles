-- Git integration plugins
return {
	-- Git client
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
		config = function()
			-- Git keymaps
			vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
			vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
			vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", { desc = "Git add all" })
			vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { desc = "Git diff" })
		end,
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
