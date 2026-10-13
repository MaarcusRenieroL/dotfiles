return {
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				background_colour = "#0b1219",
				stages = "fade",
				timeout = 3000,
				render = "wrapped-compact",
				icons = { ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎" },
			})
			vim.notify = require("notify")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		keys = {
			{ "<leader>nl", function() require("noice").cmd("last") end, desc = "Last message" },
			{ "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss notifications" },
			{ "<leader>nH", function() require("noice").cmd("history") end, desc = "Message history" },
		},
	},
}
