return {
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup()

			local k = vim.keymap.set

			k("n", "]h", gitsigns.next_hunk, { desc = "Next git hunk" })
			k("n", "[h", gitsigns.prev_hunk, { desc = "Previous git hunk" })

			k("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
			k("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
			k("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
			k("n", "<leader>hb", gitsigns.blame_line, { desc = "Blame line" })
		end,
	},
}
