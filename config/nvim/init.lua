local opt = vim.opt
local g = vim.g
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = " "
g.maplocalleader = " "
g.copilot_enabled = false

-- Skip unused built-in plugins / remote providers (faster startup, quieter :checkhealth)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_remote_plugins = 1
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

-- Mason bins (lua-language-server, stylua, …) are not on $PATH by default
do
	local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
	if vim.uv.fs_stat(mason_bin) then
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
	end
end

opt.cmdheight = 0
opt.laststatus = 3
opt.showmode = false
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.winborder = "rounded"
opt.pumborder = "rounded"
opt.undofile = true
opt.swapfile = false
opt.confirm = true
opt.shortmess:append("WcC") -- quieter writes / completion

-- Less noisy LSP log (was multi-MB of noise)
vim.lsp.log.set_level(vim.log.levels.WARN)


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
		"https://github.com/stevearc/quicker.nvim",
		"https://github.com/nvim-tree/nvim-web-devicons",
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/hrsh7th/nvim-cmp",
		"https://github.com/hrsh7th/cmp-nvim-lsp",
		"https://github.com/dmtrKovalenko/fff.nvim",
		"https://github.com/sphamba/smear-cursor.nvim",
		"https://github.com/stevearc/oil.nvim",
		"https://github.com/MunifTanjim/nui.nvim",
		{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
		"https://github.com/elixir-editors/vim-elixir",
		"https://github.com/akinsho/bufferline.nvim",
		"https://github.com/github/copilot.vim",
		"https://github.com/lewis6991/gitsigns.nvim",
		"https://github.com/tpope/vim-fugitive",
		"https://github.com/hedyhli/outline.nvim",
		"https://github.com/vimwiki/vimwiki",
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
		"https://github.com/folke/todo-comments.nvim",
		"https://github.com/windwp/nvim-ts-autotag",
		"https://github.com/bxrne/clank.nvim",
		"https://github.com/akinsho/toggleterm.nvim",
		"https://github.com/stevearc/resession.nvim",
		"https://github.com/ojroques/nvim-hardline",
		"https://github.com/SmiteshP/nvim-navic",
	})

-- UI

-- Ghostty Default Style Dark — terminal theme ported to Neovim
local ghostty = {
	bg          = "#282c34",
	bg_alt      = "#1d1f21",
	bg_highlight  = "#353a44",
	fg          = "#ffffff",
	grey        = "#666666",
	black       = "#1d1f21",
	red         = "#cc6566",
	green       = "#b6bd68",
	yellow      = "#f0c674",
	blue        = "#82a2be",
	purple      = "#b294bb",
	cyan        = "#8abeb7",
	white       = "#c4c8c6",
	bright_black = "#666666",
	bright_red   = "#d54e53",
	bright_green = "#b9ca4b",
	bright_yellow= "#e7c547",
	bright_blue  = "#7aa6da",
	bright_purple= "#c397d8",
	bright_cyan  = "#70c0b1",
	bright_white = "#eaeaea",
}

-- Apply theme: set highlights to match Ghostty default style dark
vim.cmd([[
	hi clear
	syntax reset
	set background=dark
	hi! default link None NONE
]])
vim.g.colors_name = "ghostty"

local bg, fg = ghostty.bg, ghostty.fg
local hl = vim.api.nvim_set_hl

hl(0, "Normal", { fg = fg, bg = bg })
hl(0, "NormalFloat", { fg = fg, bg = ghostty.bg_highlight })
hl(0, "FloatBorder", { fg = ghostty.blue, bg = ghostty.bg_highlight })
hl(0, "FloatTitle", { fg = bg, bg = ghostty.blue, bold = true })
hl(0, "Comment", { fg = ghostty.grey, italic = true })
hl(0, "Constant", { fg = ghostty.bright_red })
hl(0, "String", { fg = ghostty.bright_green })
hl(0, "Character", { fg = ghostty.bright_green })
hl(0, "Number", { fg = ghostty.bright_purple })
hl(0, "Boolean", { fg = ghostty.bright_purple })
hl(0, "Float", { fg = ghostty.bright_purple })
hl(0, "Identifier", { fg = fg })
hl(0, "Function", { fg = ghostty.bright_blue })
hl(0, "Definition", { fg = ghostty.bright_blue })
hl(0, "Keyword", { fg = ghostty.bright_magenta, bold = true })
hl(0, "KeywordReturn", { fg = ghostty.bright_purple })
hl(0, "Statement", { fg = ghostty.bright_purple, bold = true })
hl(0, "Conditional", { fg = ghostty.bright_purple, bold = true })
hl(0, "Repeat", { fg = ghostty.bright_purple, bold = true })
hl(0, "Label", { fg = ghostty.bright_red })
hl(0, "Operator", { fg = ghostty.bright_purple })
hl(0, "Sign", { link = "Normal" })
hl(0, "PreProc", { fg = ghostty.bright_yellow })
hl(0, "Include", { fg = ghostty.bright_purple })
hl(0, "Type", { fg = ghostty.bright_cyan, bold = true })
hl(0, "Structure", { fg = ghostty.bright_cyan })
hl(0, "Special", { fg = ghostty.bright_yellow })
hl(0, "SpecialText", { fg = ghostty.bright_yellow })
hl(0, "Tag", { fg = ghostty.bright_yellow })
hl(0, "Delimeter", { fg = ghostty.bright_magenta })
hl(0, "CharDevAucd", { link = "Special" })
hl(0, "Underlined", { underline = true })
hl(0, "Todo", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "SpecialComment", { fg = ghostty.grey, italic = true })
hl(0, "Error", { fg = bg, bg = ghostty.bright_red })
hl(0, "ErrorMsg", { fg = ghostty.bright_red, bold = true })
hl(0, "WarningMsg", { fg = ghostty.bright_yellow, bold = true })
hl(0, "InfoMsg", { fg = ghostty.bright_blue, bold = true })
hl(0, "Hint", { link = "Special" })
hl(0, "HintWord", { link = "Special" })
hl(0, "MoreMsg", { fg = ghostty.bright_cyan, bold = true })
hl(0, "ModeMsg", { fg = fg, bold = true })
hl(0, "LineNr", { fg = ghostty.bright_black, bold = true })
hl(0, "LineNrAbove", { fg = ghostty.grey })
hl(0, "LineNrBelow", { fg = ghostty.grey })
hl(0, "SignColumn", { fg = ghostty.grey, bg = bg })
hl(0, "GitSignsAdd", { fg = ghostty.green })
hl(0, "GitSignsChange", { fg = ghostty.yellow })
hl(0, "GitSignsDelete", { fg = ghostty.red })
hl(0, "GitSignsChangeLnInline", { bg = ghostty.bg_highlight })
hl(0, "GitSignsAddLnInline", { bg = ghostty.bg_highlight })
hl(0, "GitSignsDeleteLnInline", { bg = ghostty.bg_highlight })
hl(0, "GitSignsAddLn", { fg = ghostty.green, bg = ghostty.bg_highlight })
hl(0, "GitSignsChangeLn", { fg = ghostty.yellow, bg = ghostty.bg_highlight })
hl(0, "GitSignsDeleteLn", { fg = ghostty.red, bg = ghostty.bg_highlight })
hl(0, "Search", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "IncSearch", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "CurSearch", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "Substitute", { fg = bg, bg = ghostty.bright_magenta })
hl(0, "Visual", { fg = ghostty.bg, bg = ghostty.bright_blue })
hl(0, "VisualNOS", { fg = ghostty.bg, bg = ghostty.bright_blue })
hl(0, "VertSplit", { fg = ghostty.grey, bg = bg })
hl(0, "WinSeparator", { fg = ghostty.grey })
hl(0, "WinBar", { fg = ghostty.grey, bg = bg })
hl(0, "WinBarNC", { fg = ghostty.grey, bg = bg })
hl(0, "MsgArea", { fg = fg })
hl(0, "MsgSeparator", { fg = fg, bg = bg })
hl(0, "Pmenu", { fg = fg, bg = ghostty.bg_highlight })
hl(0, "PmenuSel", { fg = bg, bg = ghostty.bright_blue, bold = true })
hl(0, "PmenuSbar", { bg = ghostty.bg_highlight })
hl(0, "PmenuThumb", { bg = ghostty.grey })
hl(0, "WildMenu", { fg = bg, bg = ghostty.bright_yellow, bold = true })
hl(0, "TabLine", { fg = fg, bg = ghostty.bg_highlight })
hl(0, "TabLineSel", { fg = bg, bg = ghostty.bright_blue, bold = true })
hl(0, "TabLineFill", { fg = fg, bg = ghostty.bg_alt })
hl(0, "Folded", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "FoldColumn", { fg = ghostty.grey, bg = bg })
hl(0, "Cursor", { fg = bg, bg = ghostty.fg })
hl(0, "CursorLine", { bg = ghostty.bg_highlight })
hl(0, "CursorColumn", { bg = ghostty.bg_highlight })
hl(0, "ColorColumn", { bg = ghostty.bg_highlight })
hl(0, "Whitespace", { fg = ghostty.bg_alt })
hl(0, "EndOfBuffer", { fg = bg })
hl(0, "NonText", { fg = ghostty.bg_alt })
hl(0, "SpecialKey", { fg = ghostty.bg_alt })
hl(0, "SpellCap", { fg = ghostty.bright_red, undercurl = true, sp = ghostty.bright_red })
hl(0, "SpellRare", { fg = ghostty.bright_red, undercurl = true, sp = ghostty.bright_red })
hl(0, "SpellLocal", { fg = ghostty.bright_blue, undercurl = true, sp = ghostty.bright_blue })
hl(0, "LspReferenceText", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "LspReferenceRead", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "LspReferenceWrite", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "LspReferenceWc", { fg = bg, bg = ghostty.bright_yellow })
hl(0, "DiagnosticSignError", { fg = ghostty.bright_red })
hl(0, "DiagnosticSignWarn", { fg = ghostty.bright_yellow })
hl(0, "DiagnosticSignInfo", { fg = ghostty.bright_blue })
hl(0, "DiagnosticSignHint", { fg = ghostty.bright_purple })
hl(0, "DiagnosticVirtualTextError", { fg = ghostty.bright_red, bg = ghostty.bg_highlight })
hl(0, "DiagnosticVirtualTextWarn", { fg = ghostty.bright_yellow, bg = ghostty.bg_highlight })
hl(0, "DiagnosticVirtualTextInfo", { fg = ghostty.bright_blue, bg = ghostty.bg_highlight })
hl(0, "DiagnosticVirtualTextHint", { fg = ghostty.bright_purple, bg = ghostty.bg_highlight })
hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = ghostty.bright_red })
hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = ghostty.bright_yellow })
hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = ghostty.bright_blue })
hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = ghostty.bright_purple })
hl(0, "WhichKey", { fg = fg, bg = ghostty.bg_highlight })
hl(0, "WhichKeySeparator", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "WhichKeyNormal", { fg = fg, bg = ghostty.bg_highlight })
hl(0, "WinSeparator", { fg = ghostty.grey, bg = bg })
hl(0, "NormalAnchor", { fg = fg, bg = bg })
hl(0, "NormalFloatBorderTitle", { fg = bg, bg = ghostty.bright_blue })
hl(0, "NormalFloatBorder", { fg = ghostty.bright_blue, bg = ghostty.bg_highlight })
hl(0, "NvimTreeNormal", { fg = fg, bg = bg })
hl(0, "NvimTreeNormalCursor", { fg = bg, bg = ghostty.bright_blue })
hl(0, "NvimTreeSignColumn", { fg = ghostty.grey, bg = bg })
hl(0, "NvimTreeGitIgnoredFg", { fg = ghostty.grey })
hl(0, "NvimTreeGitNew", { fg = ghostty.green })
hl(0, "NvimTreeGitDeleted", { fg = ghostty.bright_red })
hl(0, "NvimTreeGitDirty", { fg = ghostty.bright_yellow })
hl(0, "NvimTreeModifiedIcon", { fg = ghostty.bright_yellow })
hl(0, "NvimTreeOpenedIcon", { fg = ghostty.bright_blue })
hl(0, "NvimTreeImageFile", { fg = ghostty.grey })
hl(0, "NvimTreeIndentMarker", { fg = ghostty.bg_alt })
hl(0, "NvimTreeEndOfBuffer", { fg = bg })
hl(0, "BufferLineIndicatorSelected", { fg = ghostty.bright_blue })
hl(0, "BufferLineIndicatorVisible", { fg = ghostty.grey })
hl(0, "BufferLineIndicator", { fg = ghostty.grey })
hl(0, "BufferLineDevIcon", { fg = ghostty.grey })
hl(0, "BufferLineDevIconActive", { fg = ghostty.bright_blue })
hl(0, "BufferLineDevIconInactive", { fg = ghostty.grey })
hl(0, "BufferLineTabSelected", { fg = fg, bg = ghostty.bright_blue })
hl(0, "BufferLineTab", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "BufferLineTabClose", { fg = ghostty.bright_red })
hl(0, "BufferLineCloseIcon", { fg = ghostty.bright_red })
hl(0, "BufferLineCloseIconVisible", { fg = ghostty.bright_red })
hl(0, "BufferLineCloseIconSelected", { fg = ghostty.bright_red })
hl(0, "BufferLineDuplicate", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "BufferLineDuplicateVisible", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "BufferLineDuplicateSelected", { fg = fg, bg = ghostty.bright_blue })
hl(0, "BufferLineLeftSide", { bg = ghostty.bg_alt })
hl(0, "BufferLineRightSide", { bg = ghostty.bg_alt })
hl(0, "BufferLineRightSeparator", { fg = ghostty.bg_alt, bg = ghostty.bg_alt })
hl(0, "BufferLineLeftSeparator", { fg = ghostty.bg_alt, bg = ghostty.bg_alt })
hl(0, "BufferLineRightSeparatorVisible", { fg = ghostty.bg_alt, bg = ghostty.bg_highlight })
hl(0, "BufferLineLeftSeparatorVisible", { fg = ghostty.bg_alt, bg = ghostty.bg_highlight })
hl(0, "BufferLineRightSeparatorSelected", { fg = ghostty.bg_alt, bg = ghostty.bright_blue })
hl(0, "BufferLineLeftSeparatorSelected", { fg = ghostty.bg_alt, bg = ghostty.bright_blue })
hl(0, "BufferLineRightSeparatorInactive", { fg = ghostty.bg_alt, bg = ghostty.bg_alt })
hl(0, "BufferLineLeftSeparatorInactive", { fg = ghostty.bg_alt, bg = ghostty.bg_alt })
hl(0, "BufferLineVisible", { fg = ghostty.grey, bg = ghostty.bg_highlight })
hl(0, "BufferLineSelected", { fg = fg, bg = ghostty.bright_blue })
hl(0, "BufferLineFill", { bg = bg })
hl(0, "BufferLineBackground", { fg = ghostty.grey, bg = bg })
hl(0, "BufferLineBackgroundVisible", { fg = ghostty.grey, bg = bg })
hl(0, "BufferLineBackgroundSelected", { fg = fg, bg = ghostty.bright_blue })

-- Set terminal colors for built-in terminal
vim.g.terminal_color_0 = ghostty.black
vim.g.terminal_color_1 = ghostty.red
vim.g.terminal_color_2 = ghostty.green
vim.g.terminal_color_3 = ghostty.yellow
vim.g.terminal_color_4 = ghostty.blue
vim.g.terminal_color_5 = ghostty.purple
vim.g.terminal_color_6 = ghostty.cyan
vim.g.terminal_color_7 = ghostty.white
vim.g.terminal_color_8 = ghostty.bright_black
vim.g.terminal_color_9 = ghostty.bright_red
vim.g.terminal_color_10 = ghostty.bright_green
vim.g.terminal_color_11 = ghostty.bright_yellow
vim.g.terminal_color_12 = ghostty.bright_blue
vim.g.terminal_color_13 = ghostty.bright_purple
vim.g.terminal_color_14 = ghostty.bright_cyan
vim.g.terminal_color_15 = ghostty.bright_white

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

-- Hardline statusline — palette from ghostty
pcall(function()
	local c = ghostty
	local function color(gui)
		return { gui = gui, cterm = "NONE", cterm16 = "NONE" }
	end

	require("hardline").setup({
		bufferline = false, -- using bufferline.nvim instead
		theme = "custom",
		custom_theme = {
			text = color(c.bg), -- dark fg on bright mode segments
			normal = color(c.green),
			insert = color(c.blue),
			replace = color(c.yellow),
			visual = color(c.purple),
			command = color(c.pink),
			inactive_comment = color(c.grey),
			inactive_cursor = color(c.bg_alt),
			inactive_menu = color(c.bg_highlight),
			alt_text = color(c.fg),
			warning = color(c.yellow),
		},
		sections = {
			{ class = "mode", item = require("hardline.parts.mode").get_item },
			{ class = "high", item = require("hardline.parts.git").get_item, hide = 100 },
			{ class = "med", item = require("hardline.parts.filename").get_item },
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
			{ class = "med", item = "%=" },
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
			{ class = "error", item = require("hardline.parts.lsp").get_error },
			{ class = "warning", item = require("hardline.parts.lsp").get_warning },
			{ class = "warning", item = require("hardline.parts.whitespace").get_item },
			{ class = "high", item = require("hardline.parts.filetype").get_item, hide = 60 },
			{ class = "mode", item = require("hardline.parts.line").get_item },
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


-- Autosave: avoid TextChanged (disk write on every normal-mode edit → lag on big files)
local function silent_save()
	if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
		vim.cmd("silent! write")
	end
end

autocmd({ "FocusLost", "InsertLeave", "BufLeave" }, { callback = silent_save })

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

-- Diagnostics Config
vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "", source = "if_many" },
	signs = true,
	underline = true,
	update_in_insert = false, 
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
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
		local so = vim.fn.globpath(
			vim.fn.stdpath("data") .. "/site/pack/core/opt/fff.nvim/target/release",
			"libfff_nvim.so", false, true
		)
		if #so == 0 then
			vim.notify("fff.nvim: Rust backend missing — building now (this takes ~30s)…", vim.log.levels.INFO)
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
		harness = "opencode",
		model = "openrouter/free",
		keymaps = {
			fill = "<leader>af",
		},
	})
end)

pcall(function()
	vim.treesitter.language.register("markdown", "vimwiki")
	require("render-markdown").setup({
		file_types = { "markdown", "vimwiki" },
		-- No latex parser / converters installed (checkhealth warnings)
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

pcall(function()
	require("resession").setup({
		-- Attach autosave only after an explicit save/load
		autosave = {
			enabled = true,
			interval = 60,
			notify = false,
		},
	})
end)

-- Per-directory sessions: restore on `nvim` / `nvim .` with no file args
autocmd("VimEnter", {
	nested = true,
	callback = function()
		if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
			require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
		end
	end,
})
autocmd("VimLeavePre", {
	callback = function()
		require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
	end,
})
autocmd("StdinReadPre", {
	callback = function()
		vim.g.using_stdin = true
	end,
})

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
map("n", "<leader>Ss", function()
	require("resession").save()
end, { desc = "Save session" })
map("n", "<leader>Sl", function()
	require("resession").load()
end, { desc = "Load session" })
map("n", "<leader>Sd", function()
	require("resession").delete()
end, { desc = "Delete session" })

-- Qfl
map("n", "<leader>cn", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "<leader>cp", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map('n', '<leader>gQ', vim.diagnostic.setqflist, { desc = 'Open All Project Diagnostics' })

map('n', '<leader>gq', vim.diagnostic.setloclist, { desc = 'Open File Diagnostics' })

