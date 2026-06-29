return {
	{
		"windwp/nvim-autopairs",

		event = "InsertEnter",

		config = function()
			local autopairs = require("nvim-autopairs")

			autopairs.setup({})

			local ok, cmp = pcall(require, "cmp")
			if ok then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
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
