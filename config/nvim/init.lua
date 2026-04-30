local opt = vim.opt
local g = vim.g

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 200
opt.timeoutlen = 300
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true

if not vim.pack or type(vim.pack.add) ~= "function" then
  vim.schedule(function()
    vim.notify(
      "vim.pack is not available in this Neovim build. Update Neovim or switch back to lazy.nvim.",
      vim.log.levels.ERROR
    )
  end)
  return
end

-- Plugins
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/Shatur/neovim-ayu",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/hrsh7th/nvim-cmp",   -- Completion menu
  "https://github.com/hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/karb94/neoscroll.nvim",
  "https://github.com/stevearc/oil.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/akinsho/bufferline.nvim", -- Modern buffer tabline
  "https://github.com/github/copilot.vim", -- GitHub Copilot inline completion
  "https://github.com/lewis6991/gitsigns.nvim", -- Git signs in buffers
})

local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

-- UI Setup
pcall(function()
  require("ayu").setup({ mirage = false, overrides = {} })
  vim.cmd.colorscheme("ayu-dark")
end)

-- BUFFERLINE
pcall(function()
  require("bufferline").setup {
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "slant",
      -- Remove numbers from tab tiles
      close_command = "bdelete! %d",
      offsets = {
        {filetype = "NvimTree", text = "File Explorer", text_align = "center"},
      },
      show_buffer_close_icons = true,
      show_close_icon = false,
      enforce_regular_tabs = true,
    },
  }
end)

-- Buffer navigation: <Tab> next, <S-Tab> previous
map('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })

pcall(function()
  require("lualine").setup({
    options = {
      theme = "ayu_dark",
      globalstatus = true,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "alpha", "dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = { modified = " [+]", readonly = " [ro]", unnamed = "[No Name]" },
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end)

local ts_parsers = {
  "bash",
  "c",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "yaml",
  "zig",
}

pcall(function()
  local nts = require("nvim-treesitter")
  nts.install(ts_parsers)

  autocmd("PackChanged", {
    callback = function()
      pcall(nts.update)
    end,
  })
end)

-- COMPLETION (nvim-cmp, ghost text only, hides popup window)
pcall(function()
  local cmp = require("cmp")
  cmp.setup({
    window = {
      completion = {
        border = 'none',
        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        max_width = 0,
        min_width = 0,
      },
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = {
      { name = 'nvim_lsp' },
    },
    experimental = {
      ghost_text = false,
    },
  })
end)

autocmd("FileType", {
  callback = function(args)
    local ok, lang = pcall(vim.treesitter.language.get_lang, args.match)
    if not ok or not lang then
      return
    end

    local added = pcall(vim.treesitter.language.add, lang)
    if added then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      pcall(vim.treesitter.start)
    end
  end,
})

autocmd({ "InsertLeave", "TextChanged" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(bufnr) ~= "" and vim.bo.buflisted and vim.bo.modifiable then
      vim.cmd("silent! update")
    end
  end,
})

-- LSP SETUP (uses new API for Neovim 0.12+)
pcall(function()
  local servers = { "lua_ls", "gopls", "ts_ls", "pyright", "bashls", "rust_analyzer", "zls" }
  for _, server in ipairs(servers) do
    vim.lsp.config(server, {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })
    vim.lsp.enable(server)
  end
end)

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "",
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})

map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

pcall(function()
  require("fzf-lua").setup({})
  map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
  map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
  map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
end)

pcall(function()
  require("treesitter-context").setup({
    max_lines = 3,
    multiline_threshold = 1,
    separator = "-",
    min_window_height = 20,
    line_numbers = true,
  })
end)

pcall(function()
  require("neoscroll").setup({ duration_multiplier = 0.4 })
end)


pcall(function()
  require("oil").setup({
    default_file_explorer = false,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    view_options = {
      show_hidden = true,
      columns = { "icon", "permissions", "size", "mtime", "git" },
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<C-h>"] = false,
      ["<C-l>"] = false,
    },
  })
  map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer (oil)" })
end)

-- GITSIGNS
pcall(function()
  require('gitsigns').setup({
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  })
  map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = 'Next hunk' })
  map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = 'Prev hunk' })
end)

-- HARPOON2 (safe mappings)
pcall(function()
  local harpoon = require("harpoon")
  harpoon:setup({})

  map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
  map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
  -- Only select if entry exists, prevents crash
  for i = 1, 4 do
    map("n", "<leader>" .. i, function()
      local ok = pcall(function() harpoon:list():select(i) end)
      if not ok then vim.notify("No file at Harpoon slot " .. i, vim.log.levels.WARN) end
    end, { desc = "Harpoon file "..i })
  end
  map("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
  map("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon next" })
end)

-- Helpful defaults
-- GENERAL KEYMAPS
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map('n', '<Leader>h', '<C-w>h', { desc = 'Move to left window' })
map('n', '<Leader>j', '<C-w>j', { desc = 'Move to bottom window' })
map('n', '<Leader>k', '<C-w>k', { desc = 'Move to top window' })
map('n', '<Leader>l', '<C-w>l', { desc = 'Move to right window' })

-- Auto-remove buffers if file deleted from disk
autocmd({"BufRead", "BufEnter", "FocusGained"}, {
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if
      name ~= ""
      and vim.api.nvim_buf_get_option(args.buf, "buftype") == ""
      and vim.api.nvim_buf_get_option(args.buf, "filetype") ~= "oil"
      and vim.fn.filereadable(name) == 0
      and vim.api.nvim_buf_get_option(args.buf, "buflisted")
    then
      vim.schedule(function()
        if vim.api.nvim_buf_is_loaded(args.buf) then
          vim.cmd("bdelete " .. args.buf)
        end
      end)
    end
  end,
})

