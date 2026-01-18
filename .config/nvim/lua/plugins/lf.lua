return {
  "lmburns/lf.nvim",
  lazy = false,
  cmd = "Lf",
  dependencies = {
    "akinsho/toggleterm.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    height = vim.fn.float2nr(vim.fn.round(0.90 * (vim.o.lines - vim.o.laststatus))),
    width = vim.fn.float2nr(vim.fn.round(0.90 * vim.o.columns)),
    border = "curved",
    highlights = { NormalFloat = { guibg = "NONE" } },
    winblend = 0,
    escape_quit = true,
  },
  keys = {
    { "<leader>l", "<cmd>Lf<cr>", desc = "lf" },
  },
}
