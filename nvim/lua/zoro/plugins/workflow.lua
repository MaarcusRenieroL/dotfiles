return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({ settings = { save_on_toggle = true } })

			local k = vim.keymap.set
			k("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
			k("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
			for i = 1, 4 do
				k("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon file " .. i })
			end
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{ "<leader>Ss", function() require("persistence").load() end, desc = "Restore session" },
			{ "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
			{ "<leader>Sd", function() require("persistence").stop() end, desc = "Don't save session" },
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		ft = { "markdown" },
		keys = { { "<leader>tm", "<cmd>Markview toggle<CR>", desc = "Toggle markdown render" } },
	},
}
