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

-- File explorer keymaps
-- NeoTree - traditional file tree
vim.keymap.set("n", "<leader>n", "<cmd>Neotree toggle<CR>", { desc = "Toggle NeoTree" })
vim.keymap.set("n", "<leader>N", "<cmd>Neotree focus<CR>", { desc = "Focus NeoTree" })

-- Oil - modern file explorer
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open parent directory in Oil" })
vim.keymap.set("n", "<leader>E", "<cmd>Oil --float<cr>", { desc = "Open Oil in floating window" })

-- FZF fuzzy search
vim.keymap.set("n", "<leader>fr", ":FzfLua registers<CR>", { desc = "Fuzzy search registers" })
vim.keymap.set("n", "<leader>fq", ":FzfLua quickfix<CR>", { desc = "Fuzzy search quickfix list" })
vim.keymap.set("n", "<leader>fl", ":FzfLua loclist<CR>", { desc = "Fuzzy search location list" })

vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open lazygit" })

-- Terminal keymaps
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })

-- Symbols outline
vim.keymap.set("n", "<leader>so", "<cmd>SymbolsOutline<cr>", { desc = "Toggle symbols outline" })

-- Debugging keymaps (additional to debug.lua)
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debug: Continue" })
vim.keymap.set("n", "<leader>dso", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>dsi", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>dso", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Debug: Toggle UI" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Debug: Open REPL" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debug: Run Last" })
