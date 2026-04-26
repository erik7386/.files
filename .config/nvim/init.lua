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
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    -- linehl = { [vim.diagnostic.severity.ERROR] = "ErrorMsg" },
    -- numhl = { [vim.diagnostic.severity.WARN] = "WarningMsg" },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- [[ Modular config structure ]]
require("options")
require("keymaps")
require("lazy-plugins")
