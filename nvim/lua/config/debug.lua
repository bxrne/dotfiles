local dap = require('dap')

-- Configure Delve adapter
dap.adapters.go = {
	type = 'executable',
	command = 'dlv',
	args = { 'dap', '-l', '127.0.0.1:38697' },
}

-- Setup nvim-dap-go for Go-specific configurations
require('dap-go').setup()

-- Optional: Manual configurations for flexibility
dap.configurations.go = {
	{
		type = 'go',
		name = 'Debug',
		request = 'launch',
		program = '${file}', -- Debug current file
	},
	{
		type = 'go',
		name = 'Debug Package',
		request = 'launch',
		program = '${workspaceFolder}', -- Debug entire package
	},
	{
		type = 'go',
		name = 'Debug Test',
		request = 'launch',
		mode = 'test',
		program = '${file}', -- Debug current test file
	},
}

-- Keybindings for debugging
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Continue' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<Leader>B', function()
	dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Set Conditional Breakpoint' })

-- Optional: Setup nvim-dap-ui for a graphical debugging interface
local dapui = require('dapui')
dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
	dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
	dapui.close()
end
