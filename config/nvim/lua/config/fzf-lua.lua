return function()
	require("fzf-lua").setup {
		winopts = {
			height = 0.8,
			width = 0.8,
			preview = {
				default = "bat",
				border = "border",
				wrap = "nowrap",
				hidden = "nohidden",
				vertical = "down:45%",
				horizontal = "right:50%",
				layout = "flex",
				flip_columns = 120,
			},
		},
		keymap = {
			builtin = {
				["<C-d>"] = "preview-page-down",
				["<C-u>"] = "preview-page-up",
			},
			fzf = {
				["ctrl-q"] = "select-all+accept",
			},
		},
		actions = {
			files = {
				["default"] = require("fzf-lua").actions.file_edit,
				["ctrl-s"] = require("fzf-lua").actions.file_split,
				["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
				["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
			},
		},
	}

	-- Fuzzy finding keymaps

	vim.keymap.set("n", "<leader>ff", function()
		require("fzf-lua").files()
	end, { desc = "Find files" })

	vim.keymap.set("n", "<leader>fg", function()
		require("fzf-lua").live_grep()
	end, { desc = "[S]earch [F]iles" })

	vim.keymap.set("n", "<leader><leader>", function()
		require("fzf-lua").buffers()
	end, { desc = "Find existing buffers" })

	vim.keymap.set("n", "<leader>sk", function()
		require("fzf-lua").keymaps()
	end, { desc = "[S]earch [K]eymaps" })

	vim.keymap.set("n", "<leader>sd", function()
		require("fzf-lua").diagnostics_document()
	end, { desc = "[S]earch [D]iagnostics" })

	vim.keymap.set("n", "<leader>sr", function()
		require("fzf-lua").resume()
	end, { desc = "[S]earch [R]esume" })

	vim.keymap.set("n", "<leader>/", function()
		require("fzf-lua").lgrep_curbuf()
	end, { desc = "[/] Fuzzily search in current buffer" })
end