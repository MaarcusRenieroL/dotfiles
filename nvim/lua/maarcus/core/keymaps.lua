vim.g.mapleader = " "

local k = vim.keymap.set

k("n", "<leader>w", ":w<CR>", { desc = "Write and Quit file" })
k("n", "wq", ":wqa<CR>", { desc = "Write and Quit file" })

k("n", "<leader>nh", ":nohls<CR>", { desc = "Clear Highlighting" })

k("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
k("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
