return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},

		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false,
						hide_by_name = {},
						hide_by_pattern = {},
						always_show = {
							".gitignore",
							".env",
						},
						never_show = {},
					},

					follow_current_file = {
						enabled = true,
					},

					use_libuv_file_watcher = true,
				},

				window = {
					width = 32,

					mappings = {
						["<BS>"] = "close_node",
						["h"] = "close_node",
						["l"] = "open",
					},
				},
			})

			vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<CR>", {
				desc = "Toggle file explorer",
			})
			vim.keymap.set("n", "<leader>fe", "<cmd>Neotree reveal<CR>", {
				desc = "Reveal file explorer",
			})
		end,
	},
}
