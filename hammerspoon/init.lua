local modes = require("modes")
local apps = require("apps")
local windows = require("windows")
local clipboard = require("clipboard")

-- Setup modes with app and window bindings
modes.setup(apps.bindKeys, windows.bindKeys)
clipboard.setup()

-- Reload Config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

