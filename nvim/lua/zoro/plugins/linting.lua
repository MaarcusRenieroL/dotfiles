return {
	"mfussenegger/nvim-lint",

	event = {
		"BufReadPre",
		"BufNewFile",
	},

	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			markdown = { "markdownlint-cli2" },
			["markdown.mdx"] = { "markdownlint-cli2" },
			dockerfile = { "hadolint" },
		}

		local lint_group = vim.api.nvim_create_augroup("zoro-lint", { clear = true })

		vim.api.nvim_create_autocmd({
			"BufEnter",
			"BufWritePost",
			"InsertLeave",
		}, {
			group = lint_group,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Run linting" })
	end,
}
