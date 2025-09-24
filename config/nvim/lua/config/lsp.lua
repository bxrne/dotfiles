return function()
	local lspconfig = require "lspconfig"
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local navic = require "nvim-navic"

	-- Configure diagnostics for popup windows with rounded borders
	vim.diagnostic.config({
		virtual_text = true,
		float = {
			border = "single",
			source = "always",
			header = "",
			prefix = "",
			focusable = true,
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Custom diagnostic signs
	local signs = {
		{ name = "DiagnosticSignError", text = "E" },
		{ name = "DiagnosticSignWarn", text = "W" },
		{ name = "DiagnosticSignInfo", text = "I" },
		{ name = "DiagnosticSignHint", text = "H" },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- Configure LSP handlers for bordered popups
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })

	-- Common on_attach function
	local on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end

		-- LSP keymaps
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<RightMouse>", vim.lsp.buf.code_action, opts)
	end

	-- Language server configurations
	local servers = { "lua_ls", "gopls", "oxlint", "zls", "rust_analyzer", "clangd", "omnisharp", "jsonls", "taplo", "yamlls", "marksman", "bashls", "cssls", "ocamllsp" }

	-- Setup servers
	for _, server in ipairs(servers) do
		local config = require("config." .. server)
		config.capabilities = capabilities
		config.on_attach = on_attach
		lspconfig[server].setup(config)
	end
end
