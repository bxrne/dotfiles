-- ~/.hammerspoon/init.lua

-- Create menu bar item to display mode
local modeMenu = hs.menubar.new()
local currentMode = "NOR" -- Default mode

-- Function to update menu bar display
function updateModeMenu()
	modeMenu:setTitle(currentMode)
end

-- Create modal states
local normalMode = hs.hotkey.modal.new()
local insertMode = hs.hotkey.modal.new()

-- Function to toggle modes
function toggleMode()
	if currentMode == "NOR" then
		normalMode:exit()
		insertMode:enter()
		currentMode = "INS"
		hs.notify.new({ title = "Hammerspoon", informativeText = "Insert Mode" }):send()
	else
		insertMode:exit()
		normalMode:enter()
		currentMode = "NOR"
		hs.notify.new({ title = "Hammerspoon", informativeText = "Normal Mode" }):send()
	end
	updateModeMenu()
end

-- Bind Alt+Space to toggle modes
hs.hotkey.bind({ "alt" }, "space", toggleMode)

-- browser on c
normalMode:bind({}, "c", function()
	hs.application.launchOrFocus("Google Chrome")
end)

-- terminal on t
normalMode:bind({}, "t", function()
	hs.application.launchOrFocus("Ghostty")
end)

-- rdp on w
normalMode:bind({}, "w", function()
	hs.application.launchOrFocus("Windows App") -- Adjust if app name differs
end)

-- docker on d
normalMode:bind({}, "d", function()
	hs.application.launchOrFocus("Docker Desktop")
end)

-- finder on f
normalMode:bind({}, "f", function()
	hs.application.launchOrFocus("Finder")
end)

-- obsidian on o
normalMode:bind({}, "o", function()
	hs.application.launchOrFocus("Obsidian")
end)

-- settings on s
normalMode:bind({}, "s", function()
	hs.application.launchOrFocus("System Preferences")
end)

-- Reload config with Cmd+Alt+Ctrl+R
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

-- Initialize Normal mode and menu on startup
normalMode:enter()
updateModeMenu()
