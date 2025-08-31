local modes = require("modes")
local apps = require("apps")
local windows = require("windows")
local clipboard = require("clipboard")
local scrolling = require("scrolling")

-- Setup modes with app and window bindings
modes.setup(apps.bindKeys, windows.bindKeys)

-- Clipboard mgr
clipboard.setup()

-- Vim-style scrolling in normal mode
scrolling.setup()

-- Reload Config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)
