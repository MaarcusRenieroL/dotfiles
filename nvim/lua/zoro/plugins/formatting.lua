return {
	{
		"stevearc/conform.nvim",

		event = {
			"BufWritePre",
		},

		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },

					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },

					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },

					sh = { "shfmt" },
					bash = { "shfmt" },
				},

				format_on_save = {
					timeout_ms = 1000,
					lsp_fallback = true,
				},
			})

			vim.keymap.set("n", "<leader>fm", function()
				conform.format({
					async = true,
					lsp_fallback = true,
				})
			end, { desc = "Format file" })
		end,
	},
}
