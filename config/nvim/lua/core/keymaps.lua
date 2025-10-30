-- Global keymaps only (plugin-specific keymaps go in their respective config files)

-- Better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Window resizing
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<A-=>", "<C-w>=", { desc = "Equalize window sizes" })

-- Terminal mode escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- FZF fuzzy search
vim.keymap.set("n", "<leader>fr", ":FzfLua registers<CR>", { desc = "Fuzzy search registers" })
vim.keymap.set("n", "<leader>fq", ":FzfLua quickfix<CR>", { desc = "Fuzzy search quickfix list" })
vim.keymap.set("n", "<leader>fl", ":FzfLua loclist<CR>", { desc = "Fuzzy search location list" })

