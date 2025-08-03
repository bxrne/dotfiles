local M = {}

local modeMenu = hs.menubar.new()
local currentMode = "NOR"
local modes = { "NOR", "APP", "WIN" }
local modeIndex = 1

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
	hs.alert.show(modeName)
end

function M.setup(appModeBinds, winModeBinds)
	-- Cycle modes on Alt+Space
	hs.hotkey.bind({ "alt" }, "space", function()
		modeIndex = (modeIndex % #modes) + 1
		enterMode(modes[modeIndex])
	end)
	
	-- Set up app mode bindings
	if appModeBinds then
		appModeBinds(appMode)
	end
	
	-- Set up window mode bindings
	if winModeBinds then
		winModeBinds(winMode)
	end
	
	-- Initialize
	enterMode("NOR")
end

function M.getModeObjects()
	return modeObjects
end

return M