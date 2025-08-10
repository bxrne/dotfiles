local M = {}

-- Scrolling configuration
local scrollSpeed = 3
local fastScrollSpeed = 10

-- Apps where scrolling should be enabled
local scrollableApps = {
	"Google Chrome",
	"Finder",
	"Preview",
	"Obsidian",
	"Notion",
	"Discord",
	"WhatsApp",
	"TextEdit",
	"Pages",
	"Word",
	"Excel",
	"PowerPoint",
	"Keynote",
	"Numbers",
	"System Preferences",
	"System Settings",
	"Activity Monitor",
	"Console",
	"Ghostty",
}

-- Create a set for faster lookup
local scrollableAppsSet = {}
for _, app in ipairs(scrollableApps) do
	scrollableAppsSet[app] = true
end

local function isScrollableApp()
	local frontApp = hs.application.frontmostApplication()
	if not frontApp then
		return false
	end
	return scrollableAppsSet[frontApp:name()] ~= nil
end

local function scroll(direction, fast)
	if not isScrollableApp() then
		return
	end

	local speed = fast and fastScrollSpeed or scrollSpeed
	local scrollDirection = -1

	if direction == "up" or direction == "left" then
		scrollDirection = 1
	end

	if direction == "up" or direction == "down" then
		-- Vertical scrolling
		hs.eventtap.event.newScrollEvent({ 0, speed * scrollDirection }, {}, "line"):post()
	else
		-- Horizontal scrolling
		hs.eventtap.event.newScrollEvent({ speed * scrollDirection, 0 }, {}, "line"):post()
	end
end

function M.setup()
	-- Vim-style scrolling with Ctrl modifier in normal mode

	-- Basic scrolling (Ctrl + hjkl)
	hs.hotkey.bind(
		{ "ctrl" },
		"h",
		function()
			scroll("left", false)
		end,
		nil,
		function()
			scroll("left", false)
		end
	)

	hs.hotkey.bind(
		{ "ctrl" },
		"j",
		function()
			scroll("down", false)
		end,
		nil,
		function()
			scroll("down", false)
		end
	)

	hs.hotkey.bind(
		{ "ctrl" },
		"k",
		function()
			scroll("up", false)
		end,
		nil,
		function()
			scroll("up", false)
		end
	)

	hs.hotkey.bind(
		{ "ctrl" },
		"l",
		function()
			scroll("right", false)
		end,
		nil,
		function()
			scroll("right", false)
		end
	)

	-- Fast scrolling (Ctrl + Shift + hjkl)
	hs.hotkey.bind(
		{ "ctrl", "shift" },
		"h",
		function()
			scroll("left", true)
		end,
		nil,
		function()
			scroll("left", true)
		end
	)

	hs.hotkey.bind(
		{ "ctrl", "shift" },
		"j",
		function()
			scroll("down", true)
		end,
		nil,
		function()
			scroll("down", true)
		end
	)

	hs.hotkey.bind(
		{ "ctrl", "shift" },
		"k",
		function()
			scroll("up", true)
		end,
		nil,
		function()
			scroll("up", true)
		end
	)

	hs.hotkey.bind(
		{ "ctrl", "shift" },
		"l",
		function()
			scroll("right", true)
		end,
		nil,
		function()
			scroll("right", true)
		end
	)

	-- Page scrolling (Ctrl + u/d for vim-style half-page)
	hs.hotkey.bind({ "ctrl" }, "u", function()
		if isScrollableApp() then
			hs.eventtap.keyStroke({}, "pageup")
		end
	end)

	hs.hotkey.bind({ "ctrl" }, "d", function()
		if isScrollableApp() then
			hs.eventtap.keyStroke({}, "pagedown")
		end
	end)

	-- Home/End scrolling (Ctrl + g/G for vim-style)
	hs.hotkey.bind({ "ctrl" }, "g", function()
		if isScrollableApp() then
			hs.eventtap.keyStroke({ "cmd" }, "up")
		end
	end)

	hs.hotkey.bind({ "ctrl", "shift" }, "g", function()
		if isScrollableApp() then
			hs.eventtap.keyStroke({ "cmd" }, "down")
		end
	end)
end

return M
