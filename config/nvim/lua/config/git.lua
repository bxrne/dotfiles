return function()
	-- Git keymaps
	vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { desc = "Git status" })
	vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
	vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
	vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
	vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", { desc = "Git add all" })
	vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { desc = "Git diff" })
	vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open lazygit" })
end