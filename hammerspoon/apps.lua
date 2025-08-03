local M = {}

local apps = {
	c = "Google Chrome",
	t = "Ghostty",
	w = "Windows App",
	d = "Docker Desktop",
	f = "Finder",
	o = "Obsidian",
	s = "System Preferences",
}

function M.bindKeys(appMode)
	for key, appName in pairs(apps) do
		appMode:bind({}, key, function()
			hs.application.launchOrFocus(appName)
		end)
	end
end

return M