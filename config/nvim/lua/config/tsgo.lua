return {
	cmd = { "tsgo" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	root_dir = function(filename)
		local util = require("lspconfig/util")
		return util.root_pattern("package.json", "tsconfig.json", ".git")(filename) or util.path.dirname(filename)
	end,
	settings = {},
}
