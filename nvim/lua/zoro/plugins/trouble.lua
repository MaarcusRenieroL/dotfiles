return {
	"folke/trouble.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		require("trouble").setup()

		local k = vim.keymap.set

		k("n", "<leader>xx", "<cmd>Trouble diagnostics toggle")
		k("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle")
		k("n", "<leader>xd", "<cmd>Trouble document_diagnostics toggle")
		k("n", "<leader>xq", "<cmd>Trouble quickfix toggle")
		k("n", "<leader>xl", "<cmd>Trouble loclist toggle")
	end,
}
