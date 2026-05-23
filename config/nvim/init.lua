local opt = vim.opt
local g = vim.g
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = " "
g.maplocalleader = " "

opt.cmdheight = 0
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 200
opt.timeoutlen = 300
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true

-- VimWiki config (must be set before vim.pack.add loads the plugin)
vim.g.vimwiki_list = {{
	path = "~/notes/",
	syntax = "markdown",
	ext = ".md",
}}
vim.g.vimwiki_global_ext = 0        -- only activate in ~/notes/, not all .md files
vim.g.vimwiki_markdown_link_ext = 1 -- append .md to [[wiki links]]

-- Plugins
if not vim.pack or type(vim.pack.add) ~= "function" then
	vim.schedule(function()
		vim.notify(
			"vim.pack is not available in this Neovim build. Update Neovim or switch back to lazy.nvim.",
			vim.log.levels.ERROR
		)
	end)
	return
end

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/bajor/nvim-raccoon",
	"https://github.com/nyoom-engineering/oxocarbon.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/dmtrKovalenko/fff.nvim",
	"https://github.com/karb94/neoscroll.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/github/copilot.vim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/hedyhli/outline.nvim",
	"https://github.com/vimwiki/vimwiki",
})

-- UI

-- Colorscheme
pcall(function()
	require("oxocarbon").setup({})
	vim.cmd.colorscheme("oxocarbon")
end)


-- Lualine
pcall(function()
	require("lualine").setup({
		options = {
			theme = "oxocarbon",
			globalstatus = true,
			component_separators = { left = " ", right = " " },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "alpha", "dashboard" } },
		},
		sections = {
			lualine_a = { { "mode", gui = "bold" } },
			lualine_b = {
				{ "branch", icon = "" },
				{ "filename", path = 1, symbols = { modified = "[+]", readonly = "[RO]", unnamed = "[EMPTY]" } },
			},
			lualine_c = { { "diff", symbols = { added = "+", modified = "~", removed = "-" } } },
			lualine_x = {
				{ "diagnostics" },
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then return " (no lsp)" end
						local names = {}
						for _, client in ipairs(clients) do table.insert(names, client.name) end
						return " " .. table.concat(names, ", ")
					end,
					color = { fg = "#be95ff", gui = "italic" },

				},
			},
			lualine_y = { { "filetype" } },
			lualine_z = { { "progress" } },
		},
	})
end)

-- Bufferline
pcall(function()
	require("bufferline").setup {
		options = {
			diagnostics = "nvim_lsp",
			separator_style = "slant",
			close_command = "bdelete! %d",
			offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
			show_buffer_close_icons = true,
			show_close_icon = false,
			enforce_regular_tabs = true,
		},
	}
end)

-- LSP and Treesitter Setup

-- Treesitter
local ts_parsers = {
	"bash", "c", "dockerfile", "git_config", "git_rebase", "gitattributes", "gitcommit",
	"gitignore", "go", "gomod", "gosum", "html", "javascript", "json", "lua", "make",
	"markdown", "python", "rust", "sql", "toml", "tsx", "typescript", "typst", "vim",
	"yaml", "zig",
}

pcall(function()
	local nts = require("nvim-treesitter")
	nts.install(ts_parsers)
	autocmd("PackChanged", { callback = function() pcall(nts.update) end })
end)

autocmd("FileType", {
	callback = function(args)
		local ok, lang = pcall(vim.treesitter.language.get_lang, args.match)
		if not ok or not lang then return end
		if pcall(vim.treesitter.language.add, lang) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			pcall(vim.treesitter.start)
		end
	end,
})

-- LSP Setup
pcall(function()
	local servers = { "lua_ls", "gopls", "ts_ls", "pyright", "bashls", "rust_analyzer", "zls" }
	for _, server in ipairs(servers) do
		vim.lsp.config(server, {
			capabilities = require('cmp_nvim_lsp').default_capabilities(),
		})
		vim.lsp.enable(server)
	end
end)

autocmd("BufWritePre", {
	callback = function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients > 0 then vim.lsp.buf.format({ async = false }) end
	end,
})

-- Diagnostics Config
vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "", source = "if_many" },
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
})

-- Completion (CMP)
pcall(function()
	local cmp = require("cmp")
	cmp.setup({
		window = {
			completion = {
				border = 'none',
				winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
			},
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
			['<Tab>'] = cmp.mapping.select_next_item(),
			['<S-Tab>'] = cmp.mapping.select_prev_item(),
		}),
		sources = { { name = 'nvim_lsp' } },
		experimental = { ghost_text = false },
	})
end)

-- Plugin configs
g.fff = {
	lazy_sync = true,
	debug = { enabled = false, show_scores = false },
}
autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then pcall(vim.cmd.packadd, "fff.nvim") end
			pcall(function() require("fff.download").download_or_build_binary() end)
		end
	end,
})
pcall(function() require("neoscroll").setup({ duration_multiplier = 0.4 }) end)
pcall(function() require("gitsigns").setup({}) end)
pcall(function() require("raccoon").setup({}) end)

-- Outline (Symbols Outline fork)
pcall(function()
	require("outline").setup({
		relative_width = true,
		width = 25,
		position = "right",
		auto_close = false,
		keymaps = {
			close = { "<Esc>", "q" },
			goto_location = "<Cr>",
			focus_location = "o",
			hover_symbol = "<C-space>",
			toggle_preview = "K",
			rename_symbol = "r",
			code_actions = "a",
			fold = "h",
			unfold = "l",
			fold_all = "W",
			unfold_all = "E",
			fold_reset = "R",
		},
	})
end)

pcall(function()
	require("treesitter-context").setup({
		max_lines = 3,
		multiline_threshold = 1,
		separator = "-",
		min_window_height = 20,
		line_numbers = true,
	})
end)

pcall(function()
	require("oil").setup({
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		watch_for_changes = true,
		view_options = {
			show_hidden = true,
			columns = { "icon", "permissions", "size", "mtime", "git" },
		},
		keymaps = { ["q"] = "actions.close", ["<C-h>"] = false, ["<C-l>"] = false },
		float = { padding = 0.02, max_width = 0.6, max_height = 0.6, border = "rounded" },
	})
end)



-- Wiki git sync (async via jobstart so it never blocks editing)
local function wiki_git_sync(action)
	local wiki_dir = vim.fn.expand("~/notes")
	local cmd
	if action == "push" then
		local ts = os.date("%Y-%m-%d %H:%M")
		cmd = string.format(
			"sh -c 'cd %s && git add -A && git diff --cached --quiet || git commit -m \"wiki: %s\" && git push'",
			wiki_dir, ts
		)
	else
		cmd = string.format("sh -c 'cd %s && git pull'", wiki_dir)
	end
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data and data[1] ~= "" then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,
		on_stderr = function(_, data)
			if data and data[1] ~= "" then
				vim.notify(table.concat(data, "\n"), vim.log.levels.WARN)
			end
		end,
		on_exit = function(_, code)
			local msg = action == "push" and "Wiki push" or "Wiki pull"
			if code == 0 then
				vim.notify(msg .. " complete ✓", vim.log.levels.INFO)
			else
				vim.notify(msg .. " failed (exit " .. code .. ")", vim.log.levels.ERROR)
			end
		end,
	})
end

-- Keybindings

-- Navigation
map('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
map('n', '<leader>x', '<Cmd>BufferLinePickClose<CR>', { desc = 'Close buffer' })

-- fff.nvim
map("n", "ff", function() require('fff').find_files() end, { desc = "FFFind files" })
map("n", "fg", function() require('fff').live_grep() end, { desc = "LiFFFe grep" })
map("n", "fz", function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
	{ desc = "Live fffuzy grep" })
map("n", "fc", function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
	{ desc = "Search current word" })

-- Oil
map("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "Open file explorer (oil)" })

-- Outline
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle outline" })

-- Fugitive
-- -- use leader v for git fugitive commands
map("n", "<leader>v", ":Git<CR>", { desc = "Open git status (fugitive)" })
map("n", "<leader>vc", ":Git commit<CR>", { desc = "Git commit (fugitive)" })
map("n", "<leader>vp", ":Git push<CR>", { desc = "Git push (fugitive)" })
map("n", "<leader>vP", ":Git pull<CR>", { desc = "Git pull (fugitive)" })
map("n", "<leader>vb", ":Git blame<CR>", { desc = "Git blame (fugitive)" })
map("n", "<leader>vd", ":Gvdiff<CR>", { desc = "Git diff (fugitive)" })

-- Diagnostics
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- LSP Bindings
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "gr", function() vim.lsp.buf.references() end, { desc = "Find references" })
map("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
map("n", "gt", function() vim.lsp.buf.type_definition() end, { desc = "Go to type definition" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover" })
map("n", "<leader>h", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>s", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Wiki (vimwiki installs <leader>ww/wi/wt/<leader>w<leader>w automatically)
map("n", "<leader>wp", function() wiki_git_sync("push") end, { desc = "Wiki: git push notes" })
map("n", "<leader>wP", function() wiki_git_sync("pull") end, { desc = "Wiki: git pull notes" })
