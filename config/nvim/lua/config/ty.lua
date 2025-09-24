return {
	cmd = { "ty" },
	filetypes = { "python" },
	root_dir = function(filename)
		local util = require("lspconfig/util")
		return util.root_pattern("pyproject.toml", "pyrightconfig.json", ".git")(filename) or util.path.dirname(filename)
	end,
	settings = {},
}
