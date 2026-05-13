return {
	"akinsho/bufferline.nvim",

	version = "*",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
				always_show_bufferline = false,
			},
		})

		local k = vim.keymap.set

		k("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>")
		k("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>")

		k("n", "<leader>bd", "<cmd>bdelete<CR>")
		k("n", "<leader>bp", "<cmd>BufferLinePick<CR>")
		k("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>")
	end,
}
