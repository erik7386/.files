-- [[ Visual options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
-- vim.opt.splitbelow = true
-- vim.opt.list = true
vim.opt.listchars = {
  eol = "$",
  tab = "»·",
  space = "·",
  trail = "·",
  extends = ">",
  precedes = "<",
  nbsp = "␣",
}
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
-- vim.opt.scrolloff = 1
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 1
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = false
-- vim.opt.fillchars:append({ diff = "╱" })
vim.opt.fillchars:append({ diff = " " })

-- [[ Search options ]]
vim.opt.path:append("**")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- [[ Backup options ]]
vim.opt.undofile = true

-- [[ Misc options ]]
vim.opt.mouse = "a"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
