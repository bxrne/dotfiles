-- Editor enhancement plugins
return {
	-- Auto-detect indent settings
	"tpope/vim-sleuth",

	-- Preview papers
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		opts = {},
	},

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
		config = function()
			require("oil").setup {
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
			}

			-- Toggle oil with <leader>o
			vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open parent directory in Oil" })
		end,
	},

	-- File explorer and fuzzy finder
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
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
		end,
	},

	-- Enhanced terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup(require "config.toggleterm")

			-- Terminal keymaps
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
			vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
			vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })
		end,
	},

	-- Fast file navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = require "config.harpoon",
	},

	-- Comments
	{ "numToStr/Comment.nvim", opts = {} },

	-- Auto-save
	{
		"https://git.sr.ht/~nedia/auto-save.nvim",
		event = { "BufReadPre" },
		opts = {
			events = { "InsertLeave", "BufLeave" },
			silent = true,
		},
	},

	-- Color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Remote development
	{
		"amitds1997/remote-nvim.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = true,
	},

	-- Auto-save session (was.nvim)
	{
		"bxrne/was.nvim",
		version = "v0.0.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		opts = {
			defer_time = 2500,
		},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true },
	},

	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup(require "config.treesitter")
		end,
	},

	-- Code formatting
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format { async = true, lsp_fallback = true }
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = function()
			return require "config.conform"
		end,
	},
}
