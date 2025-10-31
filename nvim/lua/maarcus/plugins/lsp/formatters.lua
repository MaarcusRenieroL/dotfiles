return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },

	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				lua = { "stylua" },
				java = { "google-java-format" },
			},

			format_on_save = {
				timeout_ms = 1500,
				lsp_fallback = true,
			},
		})
	end,
}
