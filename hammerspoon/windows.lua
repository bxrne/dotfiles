local M = {}

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

function M.bindKeys(winMode)
	-- Snap bindings
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
end

return M