local k = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- GENERAL
-- ============================================================================
k("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
k("n", "<C-h>", "<C-w>h", { desc = "Left window" })
k("n", "<C-j>", "<C-w>j", { desc = "Lower window" })
k("n", "<C-k>", "<C-w>k", { desc = "Upper window" })
k("n", "<C-l>", "<C-w>l", { desc = "Right window" })
k("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
k("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
k("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
k("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })
k("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- ============================================================================
-- BUFFER + WINDOW MGMT
-- ============================================================================
for i = 1, 9 do
  k("n", ("<leader>%d"):format(i), ("<cmd>BufferLineGoToBuffer %d<CR>"):format(i), { desc = "Go to buffer " .. i })
end
k("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
k("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
k("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
k("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close others" })

-- ============================================================================
-- FILE EXPLORER (NvimTree)
-- ============================================================================
k("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
k("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Focus current file" })

-- ============================================================================
-- SEARCH (Telescope + Spectre)
-- ============================================================================
k("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
k("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
k("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
k("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
k("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Find keymaps" })
k("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
k("n", "<leader>sr", function() require("spectre").open() end, { desc = "Search & Replace (Spectre)" })

-- ============================================================================
-- LSP & DIAGNOSTICS
-- ============================================================================
k("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
k("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
k("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
k("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Implementations" })
k("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Type definitions" })
k({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
k("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
k("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Buffer diagnostics" })
k("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
k("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
k("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
k("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
k("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- ============================================================================
-- GIT
-- ============================================================================
k("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
k("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
k("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
k("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })
k("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
k("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })

-- ============================================================================
-- TROUBLE (Diagnostics / Lists)
-- ============================================================================
k("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics list" })
k("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols outline" })
k("n", "<leader>tL", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
k("n", "<leader>tQ", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })

-- ============================================================================
-- AERIAL (Outline)
-- ============================================================================
k("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
k("n", "{", "<cmd>AerialPrev<CR>", { desc = "Prev symbol" })
k("n", "}", "<cmd>AerialNext<CR>", { desc = "Next symbol" })

-- ============================================================================
-- FLASH (Enhanced Navigation)
-- ============================================================================
k({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
k({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- ============================================================================
-- FOLDING (UFO)
-- ============================================================================
k("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
k("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })

-- ============================================================================
-- FORMAT / CODE ACTIONS
-- ============================================================================
k({ "n", "v" }, "<leader>mp", function()
  require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
end, { desc = "Format file or range" })

-- ============================================================================
-- UI / UTILITY
-- ============================================================================
k("n", "<leader>nn", function()
  require("noice").cmd("history")
end, { desc = "Noice message history" })

k("n", "<leader>wn", function()
  require("notify")("Window resized!", "info", { title = "UI Event" })
end, { desc = "Test notification" })

k("n", "<leader>ww", "<cmd>WhichKey<CR>", { desc = "Which-Key menu" })

k("n", "<leader>da", "<cmd>Alpha<CR>", { desc = "Open dashboard" })

-- ============================================================================
-- MISC / QUALITY OF LIFE
-- ============================================================================
k("n", "<leader>ps", "<cmd>Lazy sync<CR>", { desc = "Sync plugins" })
k("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "Install plugins" })
k("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "Update plugins" })

k("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
k("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
k("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
