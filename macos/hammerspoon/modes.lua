local M = {}

local modeMenu = hs.menubar.new()
local currentMode = "NOR"
local modes = { "NOR", "HMR" }
local modeIndex = 1

local normalMode = hs.hotkey.modal.new()
local hmrMode = hs.hotkey.modal.new()

local modeObjects = {
	NOR = normalMode,
	HMR = hmrMode,
}

local function updateModeMenu()
	modeMenu:setTitle(currentMode)
	-- Show alert notification for mode change
	hs.alert.show("Mode: " .. currentMode, 2)
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
end

function M.setup(appModeBinds, winModeBinds)
	-- Cycle modes on Alt+Space
	hs.hotkey.bind({ "alt" }, "space", function()
		modeIndex = (modeIndex % #modes) + 1
		enterMode(modes[modeIndex])
	end)

	-- Set up app mode bindings
	if appModeBinds then
		appModeBinds(hmrMode)
	end

	-- Set up window mode bindings
	if winModeBinds then
		winModeBinds(hmrMode)
	end

	-- Initialize
	enterMode("NOR")
end

function M.getModeObjects()
	return modeObjects
end

return M
