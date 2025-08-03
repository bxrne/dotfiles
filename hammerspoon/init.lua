-- NOTE: App navigation

-- Bind C to open Google Chrome
hs.hotkey.bind({ "alt" }, "c", function()
	hs.application.launchOrFocus("Google Chrome")
	-- 	hs.alert.show("Opened Chrome")
end)

-- Bind T to open Ghostty
hs.hotkey.bind({ "alt" }, "t", function()
	hs.application.launchOrFocus("Ghostty")
	--‰hs.alert.show("Opened Ghostty")
end)

-- Bind W to open Windows App
hs.hotkey.bind({ "alt" }, "w", function()
	hs.application.launchOrFocus("Windows App")
end)

-- NOTE: Always bring Finder windows to the front
function applicationWatcher(appName, eventType, appObject)
	if eventType == hs.application.watcher.activated then
		if appName == "Finder" then
			-- Bring all Finder windows forward when one gets activated
			appObject:selectMenuItem({ "Window", "Bring All to Front" })
		end
	end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
