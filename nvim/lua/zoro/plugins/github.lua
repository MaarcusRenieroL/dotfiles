-- GitHub + rich diffs.
return {
	-- Review/manage PRs and issues without leaving Neovim. Needs `gh` + auth
	-- (run `gh auth login` once).
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			picker = "telescope",
		},
		keys = {
			{ "<leader>gp", "<cmd>Octo pr list<CR>", desc = "GitHub: pull requests" },
			{ "<leader>gi", "<cmd>Octo issue list<CR>", desc = "GitHub: issues" },
			{ "<leader>gr", "<cmd>Octo review start<CR>", desc = "GitHub: start review" },
			{ "<leader>go", "<cmd>Octo<CR>", desc = "GitHub: Octo menu" },
		},
	},

	-- Side-by-side diffs, merge-conflict resolution, and file history.
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git: diff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: file history" },
			{ "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Git: close diff view" },
		},
	},
}
