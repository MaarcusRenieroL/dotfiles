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
				{ "<leader>g", group = "Git/GitHub" },
				{ "<leader>h", group = "Git hunks" },
				{ "<leader>j", group = "Java" },
				{ "<leader>m", group = "Marks" },
				{ "<leader>s", group = "Split" },
				{ "<leader>t", group = "Toggle/Todo" },
				{ "<leader>w", group = "Window/Write" },
				{ "<leader>x", group = "Diagnostics/Trouble" },
				{ "<leader>D", group = "Database" },
				{ "<leader>R", group = "REST" },
				{ "<leader>T", group = "Test" },
			})
		end,
	},
}
