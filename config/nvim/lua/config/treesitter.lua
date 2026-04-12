-- Set parser install directory to lazy.nvim's location (already in runtimepath)
local parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"

return {
	parser_install_dir = parser_install_dir,
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"vim",
		"vimdoc",
		"go",
		"typescript",
		"yaml",
		"cpp",
		"json",
		"python",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
}