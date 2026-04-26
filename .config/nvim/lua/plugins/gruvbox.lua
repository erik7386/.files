return {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  lazy = false,
  priority = 1000,
  config = function()
    local gb = require("gruvbox")
    local p = gb.palette
    ---@diagnostic disable-next-line: missing-fields
    gb.setup({
      transparent_mode = false,
      italic = { strings = false, emphasis = false, comments = true, operators = false, folds = true },
      overrides = {
        Function = { fg = p.bright_orange },
        LspReferenceRead = { fg = p.bright_blue, bg = p.light0, reverse = true },
        LspReferenceText = { fg = p.bright_blue, bg = p.light0, reverse = true },
        LspReferenceWrite = { fg = p.bright_blue, bg = p.light0, reverse = true },
        MiniStatuslineModeNormal = { fg = p.dark0, bg = p.faded_green },
        StatusLine = { fg = p.light1, bg = p.dark2, reverse = false },
        StatusLineNC = { fg = p.light4, bg = p.dark1, reverse = false },
        -- WhichKeySeparator = { fg = p.gray },
      },
    })
    vim.api.nvim_command("colorscheme gruvbox")

    vim.api.nvim_create_user_command("ToggleTransparentBackground", function()
      ---@class GruvboxConfig
      local gbc = gb.config
      gbc.transparent_mode = not gbc.transparent_mode
      gbc.overrides.StatusLine.bg = gbc.transparent_mode and "NONE" or p.dark2
      gbc.overrides.StatusLineNC.bg = gbc.transparent_mode and "NONE" or p.dark1
      gb.setup({ gbc })
      vim.api.nvim_command("colorscheme gruvbox")
    end, {})
    vim.keymap.set("n", "<leader>tt", function()
      vim.api.nvim_command("ToggleTransparentBackground")
    end, { desc = "[T]oggle [T]ransparent Background" })
  end,
}
