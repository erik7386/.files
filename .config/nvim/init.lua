--
-- [[ NEOVIM config ]]
-- Based on https://github.com/nvim-lua/kickstart.nvim.git
--

-- [[ Use same leader throughout the config ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ General settings for plugins and more... ]]
vim.g.have_nerd_font = true
vim.g.diff_translations = 0
vim.diagnostic.config({
  -- severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    -- linehl = { [vim.diagnostic.severity.ERROR] = "ErrorMsg" },
    -- numhl = { [vim.diagnostic.severity.WARN] = "WarningMsg" },
  },
})

-- [[ Modular config structure ]]
require("options")
require("keymaps")
require("lazy-plugins")
