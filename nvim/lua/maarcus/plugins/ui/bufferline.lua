return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		require("bufferline").setup({
			options = {
				offsets = { { filetype = "NvimTree", text = "Nvim Tree", padding = 1 } },
			},
		})
		require("transparent").clear_prefix("Bufferline")
	end,
}
