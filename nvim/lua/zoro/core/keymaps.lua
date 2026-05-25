vim.g.mapleader = " "

local keymap = vim.keymap.set

-- clear search highlights
keymap("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- window splits
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
keymap("n", "<leader>wh", "<C-w>H", { desc = "Move split left" })
keymap("n", "<leader>wj", "<C-w>J", { desc = "Move split down" })
keymap("n", "<leader>wk", "<C-w>K", { desc = "Move split up" })
keymap("n", "<leader>wl", "<C-w>L", { desc = "Move split right" })

-- better indenting
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- move selected lines
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
