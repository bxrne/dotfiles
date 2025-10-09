return {
	  {
    "goolord/alpha-nvim",
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      require('config.dash')()
    end,
  },
}
