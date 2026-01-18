-- [[ Keymaps not related to plugins ]]

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Hide highlight search" })

-- vim.keymap.set('n', 'j', "gj", { desc = 'Move display lines down' })
-- vim.keymap.set('n', 'k', "gk", { desc = 'Move display lines up' })
vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system" })
vim.keymap.set("x", "<leader><leader>p", '"_dP', { desc = "Paste, remember yank" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines. Remember cursor pos" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down. Center of window" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up. Center of window" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next, center, unfold line" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search prev, center, unfold line" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "[T]oggle [D]iagnostics" })

vim.keymap.set("n", "<leader>z", function()
  vim.api.nvim_command("tab split")
  vim.keymap.set("n", "<leader>z", function()
    vim.api.nvim_command("tabclose")
    vim.keymap.del("n", "<leader>z", { buffer = 0 })
  end, { buffer = 0 })
end, { desc = "Toggle [Z]oom on current buffer" })

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.hl.on_yank()
--   end,
-- })
