local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
  { "erik7386/vimdiffext" },
  -- require("plugins.catppuccin"),
  require("plugins.gruvbox"),
  require("plugins.lf"),

  require("plugins.gitsigns"),
  require("plugins.which-key"),
  require("plugins.telescope"),
  require("plugins.lspconfig"),
  require("plugins.conform"),
  require("plugins.blink-cmp"),
  require("plugins.mini"),
  require("plugins.treesitter"),
  -- require 'plugins.debug',
  -- require 'plugins.lint',
}, {
  dev = {
    path = "~/dev/personal-gh",
    patterns = { "erik7386", "catppuccin" },
    fallback = true,
  },
})
