return {
	"folke/persistence.nvim",
	event = "BufReadPre",

	config = function()
		require("persistence").setup()

		local persistence = require("persistence")
		local k = vim.keymap.setup

		k("n", "<leader>qs", persistence.load())
		k("n", "<leader>ql", persistence.load({ last = true }))
		k("n", "<leader>qs", persistence.stop())
	end,
}
