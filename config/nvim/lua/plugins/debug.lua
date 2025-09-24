return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'mxsdev/nvim-dap-vscode-js',
    },
    config = function()
      require('config.debug')
    end,
  },
}
