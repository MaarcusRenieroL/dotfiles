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
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						".next/",
						".turbo/",
						"coverage/",
					},
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!**/.git/*",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
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
			k("n", "<leader>fF", function()
				builtin.find_files({ no_ignore = true, hidden = true })
			end, { desc = "Find all files" })
			k("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			k("n", "<leader>fG", function()
				builtin.live_grep({ additional_args = { "--no-ignore" } })
			end, { desc = "Live grep all files" })
			k("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			k("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			k("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
			k("n", "<leader>fc", builtin.grep_string, { desc = "Find word under cursor" })
			k("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
			k("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
			k("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find document symbols" })
			k("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Find workspace symbols" })
			k("n", "<leader>gc", builtin.git_commits, { desc = "Find git commits" })
			k("n", "<leader>gb", builtin.git_branches, { desc = "Find git branches" })
			k("n", "<leader>gf", builtin.git_files, { desc = "Find git files" })
		end,
	},
}
