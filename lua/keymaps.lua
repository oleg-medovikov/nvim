local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


keymap("i", "ii", "<esc>:w<cr>", opts)
keymap("n", "<space><space>", ":Telescope find_files<cr>", opts)


keymap("n", "<C-t>", ":tabnew<cr>", opts)
keymap("i", "C-t", "<esc>:tabnew<cr>", opts)
keymap("n", "C-l", ":tabnext<cr>", opts)
keymap("i", "C-l", "<esc>:tabnext<cr>", opts)
keymap("n", "C-h", ":tabprevious<cr>", opts)
keymap("i", "C-h", "<esc>:tabprevious<cr>", opts)
