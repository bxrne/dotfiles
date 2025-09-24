return function()
	require("toggleterm").setup({
		size = 20,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_terminals = true,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
		},
	})

	-- Terminal keymaps
	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
	vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
	vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })

	-- Terminal mode navigation: Always allow <C-w>h/j/k/l to exit terminal mode and navigate splits
	vim.api.nvim_create_autocmd('TermOpen', {
		pattern = 'term://*',
		callback = function(args)
			local opts = { noremap = true, silent = true, buffer = args.buf }
			vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]], opts)
			vim.keymap.set('t', '<C-w>j', [[<C-\><C-n><C-w>j]], opts)
			vim.keymap.set('t', '<C-w>k', [[<C-\><C-n><C-w>k]], opts)
			vim.keymap.set('t', '<C-w>l', [[<C-\><C-n><C-w>l]], opts)
		end
	})
end
