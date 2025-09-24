return {
	cmd = { "/home/bxrne/.opam/default/bin/ocamllsp" },
	root_dir = require("lspconfig").util.root_pattern("*.opam", "dune-project", "dune", ".git"),
	capabilities = {},
	on_attach = function(client, bufnr)
		-- OCaml-specific keymaps can be added here
	end,
	settings = {},
}