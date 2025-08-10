local M = {}
local history = {}
local historySize = 20

-- Save M change
local function storeClipboard()
	local content = hs.pasteboard.getContents()
	if content and content ~= history[1] then
		table.insert(history, 1, content)
		if #history > historySize then
			table.remove(history)
		end
	end
end

-- Show chooser UI
local function showChooser()
	hs.chooser
		.new(function(selection)
			if selection then
				hs.pasteboard.setContents(selection.text)
				hs.eventtap.keyStroke({ "cmd" }, "v")
			end
		end)
		:choices(hs.fnutils.imap(history, function(item)
			return { text = item }
		end))
		:show()
end

function M.setup()
	-- Watch for changes
	hs.pasteboard.watcher.new(storeClipboard):start()

	-- Hotkey to show history
	hs.hotkey.bind({ "cmd" }, "e", showChooser)
end

return M
