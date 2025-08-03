-- Menu Bar Mode Indicator
local modeMenu = hs.menubar.new()
local currentMode = "NOR"
local modes = { "NOR", "APP", "WIN" }
local modeIndex = 1

-- Mode objects
local normalMode = hs.hotkey.modal.new()
local appMode = hs.hotkey.modal.new()
local winMode = hs.hotkey.modal.new()

local modeObjects = {
	NOR = normalMode,
	APP = appMode,
	WIN = winMode,
}

local function updateModeMenu()
	modeMenu:setTitle(currentMode)
end

local function enterMode(modeName)
	for _, m in pairs(modeObjects) do
		m:exit()
	end
	currentMode = modeName
	updateModeMenu()
	if modeObjects[modeName] then
		modeObjects[modeName]:enter()
	end
	hs.notify.new({ title = "Hammerspoon", informativeText = modeName .. " Mode" }):send()
end

-- Cycle modes on Alt+Space
hs.hotkey.bind({ "alt" }, "space", function()
	modeIndex = (modeIndex % #modes) + 1
	enterMode(modes[modeIndex])
end)

-- APP MODE BINDINGS (via loop)
local apps = {
	c = "Google Chrome",
	t = "Ghostty",
	w = "Windows App",
	d = "Docker Desktop",
	f = "Finder",
	o = "Obsidian",
	s = "System Preferences",
}
for key, appName in pairs(apps) do
	appMode:bind({}, key, function()
		hs.application.launchOrFocus(appName)
	end)
end

-- WIN MODE BINDINGS (snapping + screen aware movement)

-- Snapping shortcuts: {key, {x, y, w, h}}
local snaps = {
	h = { 0, 0, 0.5, 1.0 }, -- left half
	l = { 0.5, 0, 0.5, 1.0 }, -- right half
	k = { 0, 0, 1.0, 0.5 }, -- top half
	j = { 0, 0.5, 1.0, 0.5 }, -- bottom half
	y = { 0, 0, 0.5, 0.5 }, -- top-left
	u = { 0.5, 0, 0.5, 0.5 }, -- top-right
	b = { 0, 0.5, 0.5, 0.5 }, -- bottom-left
	n = { 0.5, 0.5, 0.5, 0.5 }, -- bottom-right
}

local function snap(x, y, w, h)
	local win = hs.window.focusedWindow()
	if win then
		win:moveToUnit({ x = x, y = y, w = w, h = h })
	end
end

for key, frame in pairs(snaps) do
	winMode:bind({}, key, function()
		snap(table.unpack(frame))
	end)
end

-- Maximize
winMode:bind({}, "m", function()
	local win = hs.window.focusedWindow()
	if win then
		win:maximize()
	end
end)

-- Center window
winMode:bind({}, "c", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local screenFrame = win:screen():frame()
	local winFrame = win:frame()
	win:setFrame({
		x = screenFrame.x + (screenFrame.w - winFrame.w) / 2,
		y = screenFrame.y + (screenFrame.h - winFrame.h) / 2,
		w = winFrame.w,
		h = winFrame.h,
	})
end)

-- Move to next/previous screen
winMode:bind({}, "n", function()
	local win = hs.window.focusedWindow()
	if win then
		win:moveToScreen(win:screen():next())
	end
end)

winMode:bind({}, "p", function()
	local win = hs.window.focusedWindow()
	if win then
		win:moveToScreen(win:screen():previous())
	end
end)

-- Reload Config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

-- Initialize
enterMode("NOR")
