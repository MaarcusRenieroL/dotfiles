-- Database client inside Neovim (PostgreSQL, MySQL, MongoDB, ...).
-- Add connections with :DBUIAddConnection or set g:dbs (see below).
return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{
			"kristijanhusak/vim-dadbod-completion",
			ft = { "sql", "mysql", "plsql" },
			lazy = true,
		},
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	keys = {
		{ "<leader>Du", "<cmd>DBUIToggle<CR>", desc = "Database: toggle UI" },
		{ "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Database: find buffer" },
		{ "<leader>Da", "<cmd>DBUIAddConnection<CR>", desc = "Database: add connection" },
	},
	init = function()
		-- Persist saved connections + queries across sessions.
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
		vim.g.db_ui_execute_on_save = 0
		vim.g.db_ui_show_database_icon = 1

		-- Optional: pre-seed connections without committing secrets, e.g. in
		-- a machine-local file, set:
		--   vim.g.dbs = { dev = "postgres://user:pass@localhost:5432/app" }
		-- Mongo:  "mongodb://localhost:27017/app"
		-- MySQL:  "mysql://user:pass@localhost:3306/app"
	end,
	config = function()
		-- SQL buffers get dadbod completion through nvim-cmp.
		local ok, cmp = pcall(require, "cmp")
		if ok then
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("zoro-dadbod-cmp", { clear = true }),
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					cmp.setup.buffer({
						sources = cmp.config.sources({
							{ name = "vim-dadbod-completion" },
						}, {
							{ name = "buffer", keyword_length = 3 },
						}),
					})
				end,
			})
		end
	end,
}
