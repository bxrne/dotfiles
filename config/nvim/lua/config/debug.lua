local dap = require('dap')
local dapui = require('dapui')

-- Setup DAP UI
dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			position = "left",
			size = 40,
		},
		{
			elements = {
				{ id = "repl", size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			position = "bottom",
			size = 10,
		},
	},
})

-- Setup virtual text
require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = false,
	show_stop_reason = true,
	commented = false,
	only_first_definition = true,
	all_references = false,
	filter_references_pattern = '<module',
	virt_text_pos = 'eol',
	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil
})

-- Go debugging
dap.adapters.go = {
	type = 'executable',
	command = 'dlv',
	args = { 'dap', '-l', '127.0.0.1:38697' },
}

require('dap-go').setup({
	delve = {
		path = "dlv",
		initialize_timeout_sec = 20,
		port = "${port}",
		args = {},
		build_flags = "",
		detached = vim.fn.has("win32") == 1,
		cwd = nil,
	},
	dap_configurations = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "go",
			name = "Debug Package",
			request = "launch",
			program = "${workspaceFolder}",
		},
		{
			type = "go",
			name = "Debug Test",
			request = "launch",
			mode = "test",
			program = "${file}",
		},
	},
	tests = {
		verbose = false,
	},
})

-- Python debugging
dap.adapters.python = {
	type = 'executable',
	command = 'python',
	args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
	{
		type = 'python',
		request = 'launch',
		name = 'Debug current file',
		program = '${file}',
		console = 'integratedTerminal',
	},
	{
		type = 'python',
		request = 'launch',
		name = 'Debug module',
		module = function()
			return vim.fn.input('Module name: ')
		end,
		console = 'integratedTerminal',
	},
	{
		type = 'python',
		request = 'launch',
		name = 'Debug tests',
		module = 'pytest',
		args = function()
			return vim.fn.split(vim.fn.input('Pytest args: '), ' ')
		end,
		console = 'integratedTerminal',
	},
}

-- TypeScript/JavaScript debugging
require('dap-vscode-js').setup({
	adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
})

for _, adapter in ipairs({ 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }) do
	dap.adapters[adapter] = {
		type = 'server',
		host = 'localhost',
		port = '${port}',
		executable = {
			command = 'node',
			args = { vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter' },
		},
	}
end

dap.configurations.typescript = {
	{
		type = 'pwa-node',
		request = 'launch',
		name = 'Debug current TypeScript file',
		program = '${file}',
		cwd = '${workspaceFolder}',
		sourceMaps = true,
		protocol = 'inspector',
		outFiles = { '${workspaceFolder}/dist/**/*.js' },
	},
	{
		type = 'pwa-node',
		request = 'launch',
		name = 'Debug TypeScript tests',
		program = '${workspaceFolder}/node_modules/.bin/jest',
		args = { '--runInBand', '${file}' },
		cwd = '${workspaceFolder}',
		sourceMaps = true,
		console = 'integratedTerminal',
		internalConsoleOptions = 'neverOpen',
	},
	{
		type = 'pwa-chrome',
		request = 'launch',
		name = 'Debug with Chrome',
		url = 'http://localhost:3000',
		webRoot = '${workspaceFolder}',
		sourceMaps = true,
	},
}

dap.configurations.javascript = dap.configurations.typescript

-- OCaml debugging (requires ocamlearlybird)
dap.adapters.ocaml = {
	type = 'executable',
	command = 'ocamlearlybird',
	args = { 'dap' },
}

dap.configurations.ocaml = {
	{
		type = 'ocaml',
		name = 'Debug OCaml',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/main.exe')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},
	},
}

-- DAP UI listeners
dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
	dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
	dapui.close()
end

-- Debug keybindings
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Continue' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<Leader>B', function()
	dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Set Conditional Breakpoint' })
vim.keymap.set('n', '<Leader>lp', function()
	dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Debug: Set Log Point' })
vim.keymap.set('n', '<Leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
vim.keymap.set('n', '<Leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
vim.keymap.set('n', '<Leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
vim.keymap.set('n', '<Leader>de', dapui.eval, { desc = 'Debug: Evaluate Expression' })
vim.keymap.set('v', '<Leader>de', dapui.eval, { desc = 'Debug: Evaluate Selection' })