return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
		},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			default_file_explorer = false, -- neo-tree stays the sidebar explorer
			view_options = { show_hidden = true },
			float = { border = "rounded" },
			keymaps = { ["<C-h>"] = false, ["<C-l>"] = false },
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Parent directory (oil)" },
			{ "<leader>fo", "<cmd>Oil --float<CR>", desc = "Oil float" },
		},
	},
}
