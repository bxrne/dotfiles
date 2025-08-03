-- Menu bar mode indicator
local modeMenu = hs.menubar.new()
local currentMode = "NOR"
local modes = { "NOR", "APP", "WIN" }
local modeIndex = 1

-- Mode objects
local normalMode = hs.hotkey.modal.new()
local appMode = hs.hotkey.modal.new()
local winMode = hs.hotkey.modal.new()

-- Mode lookup table
local modeObjects = {
	NOR = normalMode,
	APP = appMode,
	WIN = winMode,
}

-- Update menubar
local function updateModeMenu()
	modeMenu:setTitle(currentMode)
end

-- Enter a given mode
local function enterMode(modeName)
	-- Exit all
	for _, m in pairs(modeObjects) do
		m:exit()
	end

	currentMode = modeName
	updateModeMenu()

	local modal = modeObjects[modeName]
	if modal then
		modal:enter()
	end

	hs.notify.new({ title = "Hammerspoon", informativeText = modeName .. " Mode" }):send()
end

-- Cycle mode on Alt+Space
hs.hotkey.bind({ "alt" }, "space", function()
	modeIndex = modeIndex % #modes + 1
	enterMode(modes[modeIndex])
end)

-- ESC always returns to normal
for _, m in pairs(modeObjects) do
	m:bind({}, "escape", function()
		modeIndex = 1
		enterMode("NOR")
	end)
end

-- APP MODE: Application Shortcuts
appMode:bind({}, "c", function()
	hs.application.launchOrFocus("Google Chrome")
end)
appMode:bind({}, "t", function()
	hs.application.launchOrFocus("Ghostty")
end)
appMode:bind({}, "w", function()
	hs.application.launchOrFocus("Windows App")
end)
appMode:bind({}, "d", function()
	hs.application.launchOrFocus("Docker Desktop")
end)
appMode:bind({}, "f", function()
	hs.application.launchOrFocus("Finder")
end)
appMode:bind({}, "o", function()
	hs.application.launchOrFocus("Obsidian")
end)
appMode:bind({}, "s", function()
	hs.application.launchOrFocus("System Preferences")
end)

-- WIN MODE: Window Movement
local function moveWindowTo(unit)
	local win = hs.window.focusedWindow()
	if win then
		win:moveToUnit(unit)
	end
end

winMode:bind({}, "h", function()
	moveWindowTo(hs.layout.left50)
end)
winMode:bind({}, "l", function()
	moveWindowTo(hs.layout.right50)
end)
winMode:bind({}, "m", function()
	moveWindowTo(hs.layout.maximized)
end)

-- Reload config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

-- Start in normal mode
enterMode("NOR")
