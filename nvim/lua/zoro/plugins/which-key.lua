return {
	{
		"folke/which-key.nvim",

		event = "VeryLazy",

		config = function()
			local wk = require("which-key")

			wk.setup()

			wk.add({
				{ "<leader>b", group = "Buffer/Breakpoint" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
					{ "<leader>f", group = "Find" },
					{ "<leader>g", group = "Git" },
					{ "<leader>h", group = "Git hunks" },
					{ "<leader>m", group = "Marks" },
					{ "<leader>s", group = "Split" },
					{ "<leader>t", group = "Todo" },
					{ "<leader>w", group = "Window/Write" },
					{ "<leader>x", group = "Diagnostics/Trouble" },
				})
		end,
	},
}
