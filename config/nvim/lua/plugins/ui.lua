-- UI and visual plugins
return {
	-- Icons (consolidated)
	{
		"echasnovski/mini.icons",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},

	{
  'NickvanDyke/opencode.nvim',
  dependencies = {
    { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },
  config = function()
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`
    }

    vim.opt.autoread = true

    vim.keymap.set('n', '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle embedded' })
    vim.keymap.set('n', '<leader>oa', function() require('opencode').ask('@cursor: ') end, { desc = 'Ask about this' })
    vim.keymap.set('v', '<leader>oa', function() require('opencode').ask('@selection: ') end, { desc = 'Ask about selection' })
    vim.keymap.set('n', '<leader>o+', function() require('opencode').prompt('@buffer', { append = true }) end, { desc = 'Add buffer to prompt' })
    vim.keymap.set('v', '<leader>o+', function() require('opencode').prompt('@selection', { append = true }) end, { desc = 'Add selection to prompt' })
    vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
    vim.keymap.set('n', '<leader>on', function() require('opencode').command('session_new') end, { desc = 'New session' })
    vim.keymap.set('n', '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, { desc = 'Messages half page up' })
    vim.keymap.set('n', '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, { desc = 'Messages half page down' })
    vim.keymap.set({ 'n', 'v' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select prompt' })
  end,
},

	-- cmds in center
	-- lazy.nvim
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				config = function()
					require("notify").setup(require "config.notify")
				end,
			},
		},
		config = function()
			require("noice").setup(require "config.noice")
		end,
	},

	-- Theme
	--

	{
		"ellisonleao/gruvbox.nvim",
		name = "gruxbox",
		priority = 1000,
		config = function()
			require "config.theme"
		end,
	},

	-- transparent
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup(require "config.transparent")
			vim.cmd "TransparentEnable"
		end,
	},

	-- Better buffer tabs (replacing barbar for performance)
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "echasnovski/mini.icons",
		config = function()
			require("bufferline").setup(require "config.bufferline")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons", "SmiteshP/nvim-navic" },
		config = function()
			require "config.lualine"
		end,
	},

	-- Navigation breadcrumbs
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("nvim-navic").setup {
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
			}
		end,
	},

	-- Loading notifications
	{
		"j-hui/fidget.nvim",
		opts = {},
	},

	-- Symbols outline
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup(require "config.symbols-outline")
			vim.keymap.set("n", "<leader>so", "<cmd>SymbolsOutline<cr>", { desc = "Toggle symbols outline" })
		end,
	},

	-- Pomodoro timer
	{
		"bxrne/pomo.nvim",
		name = "pomo",
		opts = {
			session_minutes = 1,
			break_minutes = 2,
		},
		config = function()
			require("pomo").setup {}
		end,
	},
}
