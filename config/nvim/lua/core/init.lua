-- Core vim settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 0
vim.g.embark_terminal_italics = 1
vim.g.have_nerd_font = true

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.fileformat = "unix"
vim.opt.breakindent = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 0
vim.opt.hlsearch = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.cmdheight = 1
vim.opt.laststatus = 3

-- Spell check for English (UK)
vim.opt.spell = true
vim.opt.spelllang = "en_gb"

-- Gruvbox-themed backgrounds for popups
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#282828", fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#282828" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#504945" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#282828" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "#282828" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#282828" })

-- Bufferline backgrounds to match editor
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#282828" })
vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "#282828" })
vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { bg = "#282828" })
vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "#282828" })

-- Font configuration with fallback
vim.opt.guifont = "JetBrains Mono Nerd Font"

-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.cmd('set rtp^="' .. os.getenv "HOME" .. '/.opam/default/share/ocp-indent/vim"')
-- Suppress deprecation warnings from plugins
vim.deprecate = function() end
