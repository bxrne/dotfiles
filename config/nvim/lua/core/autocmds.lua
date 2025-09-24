
-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			vim.opt.cmdheight = 0
		end, 100)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "toggleterm", "Outline" },
	callback = function()
		vim.opt_local.spell = false
	end,
})
