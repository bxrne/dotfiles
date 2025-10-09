return function ()
	local alpha = require "alpha"
	local startify = require "alpha.themes.startify"

	startify.file_icons.provider = "mini"
	alpha.setup(
		startify.config
	)

end
