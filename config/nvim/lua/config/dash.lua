return function()
	local alpha = require "alpha"
	local startify = require "alpha.themes.startify"

	startify.file_icons.provider = "devicons"
	local dirname = vim.fn.getcwd():match "([^/]+)$"
	local version_str = "nvim v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
	startify.section.header.val = {
		dirname,
		"",
		version_str,
	}

	alpha.setup(startify.config)
end
