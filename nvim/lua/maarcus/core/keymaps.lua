vim.g.mapleader = " "

local k = vim.keymap.set

k("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k("n", "<leader>se", "<C-w>=", { desc = "Make splits of equal size" })
k("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split window" })

k("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
k("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
k("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

k("n", "<Tab>", "<cmd>:lua require('nvchad.tabufline').next()<CR>", { desc = "Go to next buffer" })
k("n", "<S-Tab>", "<cmd>:lua require('nvchad.tabufline').prev()<CR>", { desc = "Go to previous buffer" })
k("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })
k("n", "<leader>bax", "<cmd>:lua require('nvchad.tabufline').closeAllBufs(true)")

k("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
k("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

k("n", "<leader>tt", "<cmd>Trouble<CR>", { desc = "Open/close trouble list" })

k("n", "nh", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
k("n", "ph", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
k("n", "vh", "<cmd>Gitsigns preview_hunk", { desc = "Preview Hunk" })

k("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })

k("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references" })
k("n", "gD", "<cmd>Telescope lsp_definitions<CR>", { desc = "Show LSP definitions" })
k("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" })
k("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
k("n", "<leader>rs", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
k("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under the cursor" })

k("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to function or varaible definition" })
k("n", "<leader>gr", vim.lsp.buf.references, { desc = "List the function or variable calls" })
k("n", "<leader>ca", vim.lsp.buf.code_action, {})
k("n", "<leader>rn", vim.lsp.buf.code_action, {})
k("n", "<space>rn", vim.lsp.buf.rename, {})

k({ "n", "v" }, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })
