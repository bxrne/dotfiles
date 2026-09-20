--- @diagnostic disable:undefined-global

local opt = vim.opt
local g = vim.g
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = " "
g.maplocalleader = " "

opt.cmdheight = 0
opt.laststatus = 3
opt.showmode = false
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.winborder = "rounded"
opt.pumborder = "rounded"
opt.swapfile = false


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
	"https://github.com/stevearc/quicker.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/folke/tokyonight.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/dmtrKovalenko/fff.nvim",
	"https://github.com/sphamba/smear-cursor.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim",     version = "v3.x" },
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/hedyhli/outline.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/bxrne/clank.nvim",
	"https://github.com/akinsho/toggleterm.nvim",
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
	"https://github.com/ojroques/nvim-hardline",
	"https://github.com/SmiteshP/nvim-navic",
})

-- Colorscheme: tokyonight (moon)
pcall(function()
	require("tokyonight").setup({
		style = "moon",
		terminal_colors = true,
	})
	vim.cmd.colorscheme("tokyonight-moon")
end)

pcall(function()
	require("quicker").setup({
		highlight = {
			enabled = true,
			hlgroup = "Visual",
		},
	})
end)

-- Navic (LSP breadcrumbs for hardline / winbar)
pcall(function()
	require("nvim-navic").setup({
		highlight = true,
		separator = " › ",
		depth_limit = 5,
		lazy_update_context = true,
		lsp = {
			auto_attach = true,
		},
	})
end)

-- Hardline statusline: palette from tokyonight
pcall(function()
	local colors = require("tokyonight.colors").setup()
	local function color(gui)
		return { gui = gui, cterm = "NONE", cterm16 = "NONE" }
	end

	require("hardline").setup({
		bufferline = false, -- using bufferline.nvim instead
		theme = "custom",
		custom_theme = {
			text = color(colors.bg), -- dark fg on bright mode segments
			normal = color(colors.green),
			insert = color(colors.blue),
			replace = color(colors.yellow),
			visual = color(colors.magenta),
			command = color(colors.orange),
			inactive_comment = color(colors.comment),
			inactive_cursor = color(colors.bg_dark),
			inactive_menu = color(colors.bg_highlight),
			alt_text = color(colors.fg),
			warning = color(colors.yellow),
		},
		sections = {
			{ class = "mode", item = require("hardline.parts.mode").get_item },
			{ class = "high", item = require("hardline.parts.git").get_item,     hide = 100 },
			{ class = "med",  item = require("hardline.parts.filename").get_item },
			{
				class = "med",
				item = function()
					local ok, navic = pcall(require, "nvim-navic")
					if ok and navic.is_available() then
						return navic.get_location()
					end
					return ""
				end,
				hide = 80,
			},
			"%<",
			{ class = "med",     item = "%=" },
			{
				class = "low",
				item = function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					local names = {}
					for _, client in ipairs(clients) do
						table.insert(names, client.name)
					end
					return table.concat(names, ", ")
				end,
				hide = 100,
			},
			{ class = "error",   item = require("hardline.parts.lsp").get_error },
			{ class = "warning", item = require("hardline.parts.lsp").get_warning },
			{ class = "warning", item = require("hardline.parts.whitespace").get_item },
			{ class = "high",    item = require("hardline.parts.filetype").get_item,  hide = 60 },
			{ class = "mode",    item = require("hardline.parts.line").get_item },
		},
	})
end)

-- Bufferline
pcall(function()
	require("bufferline").setup({
		options = {
			diagnostics = "nvim_lsp",
			close_command = "bdelete! %d",
			offsets = {
				{ filetype = "neo-tree", text = "Explorer", text_align = "center" },
			},
			show_buffer_close_icons = true,
			show_close_icon = false,
			enforce_regular_tabs = true,
		},
	})
end)

-- LSP and Treesitter Setup

-- Treesitter (nvim-treesitter main branch — no configs.setup; enable via vim.treesitter.start)
local ts_parsers = {
	"bash", "c", "cpp", "dockerfile", "git_config", "git_rebase", "gitattributes", "gitcommit",
	"gitignore", "go", "gomod", "gosum", "html", "javascript", "json", "lua", "make",
	"markdown", "markdown_inline", "python", "rust", "sql", "toml", "tsx", "typescript", "typst", "vim",
	"yaml", "zig",
}

pcall(function()
	local nts = require("nvim-treesitter")
	nts.setup({})
	-- install is async + no-op when present; schedule so it never blocks UI
	vim.schedule(function()
		nts.install(ts_parsers)
	end)
	autocmd("PackChanged", {
		callback = function()
			pcall(function()
				require("nvim-treesitter").update()
			end)
		end,
	})

	-- Enable highlight + experimental indent for any filetype with a parser.
	-- (Neovim only auto-starts treesitter for a few built-in ftplugins like lua/markdown.)
	autocmd("FileType", {
		callback = function(ev)
			if not pcall(vim.treesitter.start) then
				return
			end
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end)

-- LSP Setup — only enable servers whose binary is on PATH
pcall(function()
	local caps = require("cmp_nvim_lsp").default_capabilities()

	-- server name -> executable candidates (first match wins)
	local servers = {
		lua_ls = { "lua-language-server" },
		gopls = { "gopls" },
		ts_ls = { "typescript-language-server" },
		jsonls = { "vscode-json-language-server" },
		eslint = { "vscode-eslint-language-server", "eslint-language-server" },
		pyright = { "pyright-langserver", "pyright" },
		bashls = { "bash-language-server" },
		rust_analyzer = { "rust-analyzer" },
		zls = { "zls" },
		clangd = { "clangd" },
	}

	local function has_exe(candidates)
		for _, bin in ipairs(candidates) do
			if vim.fn.executable(bin) == 1 then
				return true
			end
		end
		return false
	end

	for name, bins in pairs(servers) do
		if has_exe(bins) then
			vim.lsp.config(name, { capabilities = caps })
			vim.lsp.enable(name)
		end
	end

	-- rust-analyzer: ensure proc-macro expansion works on the rustup toolchain.
	-- `procMacro.enable` is on by default but the proc-macro server needs to
	-- resolve the toolchain via `rustc`, so keep the full toolchain installed
	-- through rustup (rustc + rust-analyzer + clippy).
	if has_exe(servers.rust_analyzer) then
		vim.lsp.config("rust_analyzer", {
			capabilities = caps,
			settings = {
				["rust-analyzer"] = {
					procMacro = { enable = true },
					cargo = { allFeatures = true },
					-- `check` replaced the old `checkOnSave` map (rust-analyzer#13799).
					-- `checkOnSave` is now a plain boolean gate, and `check.command`
					-- selects the cargo subcommand for fly-check diagnostics.
					checkOnSave = true,
					check = { command = "clippy" },
				},
			},
		})
	end

	-- clangd (C/C++): prefer project-local compile_commands.json (e.g. from
	-- `bazel run @hedron_compile_commands//:refresh_all` or a symlinked build/
	-- dir). Fall back to a compile_flags.txt so clangd still understands Bazel
	-- includes/layouts when no compile_commands.json is present.
	if has_exe(servers.clangd) then
		vim.lsp.config("clangd", {
			capabilities = caps,
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders=false",
				"--all-scopes-completion",
				"--pch-storage=memory",
			},
			root_markers = {
				"compile_commands.json",
				"compile_flags.txt",
				"WORKSPACE",
				"WORKSPACE.bazel",
				"MODULE.bazel",
				".git",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		})
	end
end)

-- todo comments
pcall(function()
	require("todo-comments").setup({
		highlight = {
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlighting (vim regex)
			comments_only = true,
			max_line_len = 400,
		},
	})
end)


-- Autosave without `:w`
--
-- A debounced write fires shortly after the last edit, in insert mode and
-- normal mode, so you never need to write manually. Writes are debounced,
-- not per keystroke, so large files do not lag. Event-based saves
-- (FocusLost, InsertLeave, BufLeave) keep the file fresh on navigation,
-- and VimLeavePre flushes any change made in the final debounce window.
local AUTOSAVE_DELAY_MS = 1000
local autosave_timer

local function silent_save(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if
	    vim.bo[buf].buftype == ""
	    and vim.bo[buf].modified
	    and vim.api.nvim_buf_get_name(buf) ~= ""
	then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent! write")
		end)
	end
end

local function debounced_save()
	if autosave_timer then
		autosave_timer:close()
		autosave_timer = nil
	end
	local buf = vim.api.nvim_get_current_buf()
	autosave_timer = vim.uv.new_timer()
	autosave_timer:start(AUTOSAVE_DELAY_MS, 0, vim.schedule_wrap(function()
		autosave_timer = nil
		silent_save(buf)
	end))
end

autocmd({ "TextChanged", "TextChangedI" }, { callback = function() debounced_save() end })
autocmd({ "FocusLost", "InsertLeave", "BufLeave" }, { callback = function(ev) silent_save(ev.buf) end })
autocmd("VimLeavePre", { callback = function() vim.cmd("silent! wall") end })

autocmd("BufWritePre", {
	callback = function(ev)
		-- Skip huge buffers / special buftypes
		if vim.bo[ev.buf].buftype ~= "" then
			return
		end
		local clients = vim.lsp.get_clients({ bufnr = ev.buf })
		if #clients == 0 then
			return
		end
		vim.lsp.buf.format({ async = false, bufnr = ev.buf, timeout_ms = 2000 })
	end,
})

-- Diagnostics Config: virtual text only
vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "", source = "if_many" },
	signs = false,
	underline = false,
	update_in_insert = false,
	severity_sort = true,
	float = false,
})

-- Completion (CMP)
pcall(function()
	local cmp = require("cmp")
	cmp.setup({
		window = {
			completion = {
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
			},
			documentation = {
				border = "rounded",
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
-- Auto-build fff Rust backend if the .so is missing (e.g. after a fresh install)
autocmd("VimEnter", {
	once = true,
	callback = function()
		local dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/fff.nvim/target/release"
		local has_so = #vim.fn.globpath(dir, "libfff_nvim.so", false, true) > 0
		local has_dylib = #vim.fn.globpath(dir, "libfff_nvim.dylib", false, true) > 0
		if not has_so and not has_dylib then
			vim.notify("fff.nvim: Rust backend missing — building now (this takes ~30s)…",
				vim.log.levels.INFO)
			pcall(function() require("fff.download").download_or_build_binary() end)
		end
	end,
})

-- Smooth animated cursor when moving across lines/chars
pcall(function()
	require("smear_cursor").setup({
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		stiffness = 0.3,           -- higher = snappier (less lag behind the cursor)
		trailing_stiffness = 0.8,  -- how quickly the tail catches up
		distance_stop_animating = 0.5,
		legacy_computing_symbols_support = true, -- smoother glyphs if your font supports them
	})
end)
pcall(function() require("gitsigns").setup({}) end)
pcall(function() require("raccoon").setup({}) end)
pcall(function() require("nvim-ts-autotag").setup({}) end)

-- clank.nvim (local dev plugin)
pcall(function()
	require("clank").setup({
		harness = "opencode2",
		model = "openrouter/free",
		keymaps = {
			fill = "<leader>af",
		},
	})
end)

pcall(function()
	vim.treesitter.language.register("markdown")
	require("render-markdown").setup({
		file_types = { "markdown" },
		latex = { enabled = false },
	})
end)

-- ISPC (Intel SPMD Program Compiler) — no dedicated treesitter grammar exists,
-- so borrow C's parser/highlighting since ISPC syntax is a close superset of C.
vim.filetype.add({
	extension = {
		ispc = "ispc",
		isph = "ispc",
	},
})
pcall(function()
	vim.treesitter.language.register("c", "ispc")
end)
autocmd("FileType", {
	pattern = "ispc",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

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
		default_file_explorer = false,
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

pcall(function()
	require("neo-tree").setup({
		filesystem = {
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			hijack_netrw_behavior = "disabled", -- never auto-open neo-tree, even on `nvim .`
		},
		window = {
			width = 30,
		},
	})
end)



pcall(function()
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4)
			end
			return 15
		end,
		open_mapping = false,
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		terminal_mappings = true,
		persist_size = true,
		close_on_exit = true,
		direction = "horizontal",
		float_opts = { border = "rounded" },
	})

	-- Easier navigation / leave terminal mode (tmux-like feel inside nvim)
	autocmd("TermOpen", {
		pattern = "term://*",
		callback = function()
			local opts = { buffer = 0, silent = true }
			map("t", "<Esc>", [[<C-\><C-n>]], opts)
			map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end,
	})
end)


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
map("n", "ft", "<cmd>TodoQuickFix<cr>", { desc = "Find todos" })

-- Oil
map("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "Open file explorer (oil)" })
map("n", "<leader>n", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })

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
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo" })
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

-- Terminal (toggleterm)
map({ "n", "t" }, "<leader>tt", "<Cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map({ "n", "t" }, "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })

-- Sessions (resession) — Lua API; resession has no :Resession user commands

map("n", "<leader>cn", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "<leader>cp", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map('n', '<leader>gQ', vim.diagnostic.setqflist, { desc = 'Open All Project Diagnostics' })

map('n', '<leader>gq', vim.diagnostic.setloclist, { desc = 'Open File Diagnostics' })
