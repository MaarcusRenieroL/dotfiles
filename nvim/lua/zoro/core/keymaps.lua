vim.g.mapleader = " "

local k = vim.keymap.set


-- clear search highlights
k("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
k("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
k("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
k("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- window splits
k("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
k("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
k("n", "<M-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
k("n", "<M-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
k("n", "<M-Left>", "<cmd>vertical resize -4<CR>", { desc = "Decrease window width" })
k("n", "<M-Right>", "<cmd>vertical resize +4<CR>", { desc = "Increase window width" })

-- window navigation
k("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
k("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
k("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
k("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
k("n", "<leader>wh", "<C-w>H", { desc = "Move split left" })
k("n", "<leader>wj", "<C-w>J", { desc = "Move split down" })
k("n", "<leader>wk", "<C-w>K", { desc = "Move split up" })
k("n", "<leader>wl", "<C-w>L", { desc = "Move split right" })

-- better indenting
k("v", "<", "<gv", { desc = "Indent left and reselect" })
k("v", ">", ">gv", { desc = "Indent right and reselect" })

-- move selected lines
k("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
k("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
