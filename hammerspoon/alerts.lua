local M = {}

function M.setup()
	hs.alert.defaultStyle = {
		strokeWidth = 2,
		strokeColor = { white = 1, alpha = 0.1 },
		fillColor = { white = 0.1, alpha = 0.85 },
		textColor = { white = 1 },
		textFont = "Monaspace Neon",
		textSize = 20,
		radius = 10,
		padding = 15,
		atScreenEdge = 0,
		fadeInDuration = 0.15,
		fadeOutDuration = 0.15,
	}
end

return M