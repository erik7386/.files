-- [[ Visual options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.breakindent = true
vim.o.signcolumn = "yes"
vim.o.splitright = true
-- vim.o.splitbelow = true
-- vim.o.list = true
vim.opt.listchars = {
  eol = "$",
  tab = "»·",
  space = "·",
  trail = "·",
  extends = ">",
  precedes = "<",
  nbsp = "␣",
}
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.colorcolumn = "80"
-- vim.o.scrolloff = 1
vim.o.sidescroll = 1
vim.o.sidescrolloff = 1
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.wrap = false
-- vim.o.fillchars:append({ diff = "╱" })
vim.opt.fillchars:append({ diff = " " })
-- vim.o.confirm = true
vim.opt.iskeyword:append('-')

-- [[ Search options ]]
vim.opt.path:append("**")
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- [[ Backup options ]]
vim.o.undofile = true

-- [[ Misc options ]]
vim.o.mouse = "a"
vim.o.updatetime = 50
vim.o.timeoutlen = 300
