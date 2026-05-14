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
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
				window = {
					width = 32,
				},
			})

			vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
		end,
	},
}
