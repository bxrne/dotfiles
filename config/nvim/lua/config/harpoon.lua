return function()
	local harpoon = require "harpoon"
	harpoon:setup()

	vim.keymap.set("n", "<leader>a", function()
		harpoon:list():add()
	end, { desc = "Add to harpoon" })
	vim.keymap.set("n", "<leader>h", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Harpoon menu" })

	-- Quick file access
	for i = 1, 4 do
		vim.keymap.set("n", "<leader>" .. i, function()
			harpoon:list():select(i)
		end, { desc = "Harpoon file " .. i })
	end

	vim.keymap.set("n", "<leader>hp", function()
		harpoon:list():prev()
	end, { desc = "Previous harpoon" })
	vim.keymap.set("n", "<leader>hn", function()
		harpoon:list():next()
	end, { desc = "Next harpoon" })
end