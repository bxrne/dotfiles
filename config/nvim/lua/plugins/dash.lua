return {
	  {
    "goolord/alpha-nvim",
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      local startify = require("alpha.themes.startify")
      startify.file_icons.provider = "mini"
      require("alpha").setup(
        startify.config
      )
    end,
  },
}
