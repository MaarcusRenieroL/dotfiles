vim.g.mapleader = " "

local k = vim.keymap.set

k("n", "<leader>w", ":w<CR>", { desc = "Write and Quit file" })
k("n", "wq", ":wqa<CR>", { desc = "Write and Quit file" })

k("n", "<leader>nh", ":nohls<CR>", { desc = "Clear Highlighting" })

k("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
k("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

k("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
k("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
k("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
k("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

k("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
k("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
k("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

k("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
k("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

k("n", "<leader>tt", "<cmd>TroubleToggle<CR>", { desc = "Open/close trouble list" })
k("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Open trouble workspace diagnostics" })
k("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open trouble document diagnostics" })
k("n", "<leader>tq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open trouble quickfix list" })
k("n", "<leader>tl", "<cmd>TroubleToggle loclist<CR>", { desc = "Open trouble location list" })

k("n", "nh", "<cmd>Gitsigns next_hunk", { desc = "Next Hunk" })
k("n", "ph", "<cmd>Gitsigns prev_hunk", { desc = "Previous Hunk" })

k("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })

k("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references" })
k("n", "gD", "<cmd>Telescope lsp_definitions<CR>", { desc = "Show LSP definitions" })
k("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" })
k("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
k("n", "<leader>rs", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
k("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under the cursor" })
