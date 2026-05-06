return {
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			require("gitsigns").setup()

			local k = vim.keymap.set

			k("n", "]h", require("gitsigns").next_hunk)
			k("n", "[h", require("gitsigns").prev_hunk)

			k("n", "<leader>hs", require("gitsigns").stage_hunk)
			k("n", "<leader>hr", require("gitsigns").reset_hunk)

			k("n", "<leader>hp", require("gitsigns").preview_hunk)
		end,
	},
}
