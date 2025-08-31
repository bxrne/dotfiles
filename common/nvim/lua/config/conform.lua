return {
	notify_on_error = true,
	format_on_save = true,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		go = { "gofmt" },
		groovy = { "groovyformatter" },
	},
}