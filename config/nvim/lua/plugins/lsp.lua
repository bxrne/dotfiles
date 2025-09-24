-- LSP configuration
return {
	-- Mason for LSP management
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"gopls",
				"pyright",
				"tsserver",
				"zls",
				"rust-analyzer",
				"stylua",
				"shellcheck",
				"shfmt",
			},
		},
	},

	-- Mason LSP config bridge
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = { "gopls", "ts_ls", "lua_ls", "pyright", "zls", "rust_analyzer" },
			automatic_installation = true,
		},
	},

	-- Main LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"SmiteshP/nvim-navic",
		},
		config = function()
			local lspconfig = require "lspconfig"
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local navic = require "nvim-navic"

			-- Configure diagnostics for popup windows with rounded borders
			vim.diagnostic.config({
				virtual_text = false,
				float = {
					border = "rounded",
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
			end

			-- Language server configurations
			local servers = {
				lua_ls = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				gopls = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						gopls = {
							analyses = { unusedparams = true },
							staticcheck = true,
							gofumpt = true,
						},
					},
				},
				ts_ls = {
					capabilities = capabilities,
					on_attach = on_attach,
				},
				pyright = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				zls = {
					capabilities = capabilities,
					on_attach = on_attach,
				},
				rust_analyzer = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
			}

			-- Setup servers
			for server, config in pairs(servers) do
				lspconfig[server].setup(config)
			end
		end,
	},
}

