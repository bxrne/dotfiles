local alerts = require("alerts")
local modes = require("modes")
local apps = require("apps")
local windows = require("windows")

-- Setup alert styles
alerts.setup()

-- Setup modes with app and window bindings
modes.setup(apps.bindKeys, windows.bindKeys)

-- Reload Config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)