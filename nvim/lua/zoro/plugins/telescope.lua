return {
	{
		"nvim-telescope/telescope.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},

			"nvim-telescope/telescope-ui-select.nvim",
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			local k = vim.keymap.set

			k("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			k("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			k("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			k("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			k("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
			k("n", "<leader>fc", builtin.grep_string, { desc = "Find word under cursor" })
			k("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
		end,
	},
}
