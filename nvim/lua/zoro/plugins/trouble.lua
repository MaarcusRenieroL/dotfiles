return {
	"folke/trouble.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		require("trouble").setup()

		local k = vim.keymap.set

		k("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
		k("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
		k("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>")
		k("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>")
		k("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>")
		k("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>")
	end,
}
