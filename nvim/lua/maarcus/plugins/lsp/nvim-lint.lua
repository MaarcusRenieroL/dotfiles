return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },

	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			html = {},
			css = { "stylelint" },
			scss = { "stylelint" },
			json = {},
			java = {}, -- Java handled by LSP, not external linter
		}

		-- Auto lint on save
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
