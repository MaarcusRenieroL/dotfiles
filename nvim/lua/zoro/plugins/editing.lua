return {
	{
		"windwp/nvim-autopairs",

		event = "InsertEnter",

		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"numToStr/Comment.nvim",

		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},

		config = function()
			require("Comment").setup()
		end,
	},

	{
		"kylechui/nvim-surround",

		version = "*",

		event = "VeryLazy",

		config = function()
			require("nvim-surround").setup({})
		end,
	},
}
