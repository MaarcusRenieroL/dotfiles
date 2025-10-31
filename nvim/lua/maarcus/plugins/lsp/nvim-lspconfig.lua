return {
	"neovim/nvim-lspconfig",

	config = function()
		local lsp = require("lspconfig")
		local cmp_cap = require("cmp_nvim_lsp").default_capabilities()

		-- JS / TS / React / Next
		lsp.ts_ls.setup({
			capabilities = cmp_cap,
			on_attach = function(_, bufnr)
				vim.bo[bufnr].tabstop = 2
			end,
		})

		-- HTML
		lsp.html.setup({
			capabilities = cmp_cap,
		})

		-- CSS / SCSS
		lsp.cssls.setup({
			capabilities = cmp_cap,
		})

		-- Tailwind CSS
		lsp.tailwindcss.setup({
			capabilities = cmp_cap,
		})

		-- JSON
		lsp.jsonls.setup({
			capabilities = cmp_cap,
		})

		-- Java (Spring Boot)
		lsp.jdtls.setup({
			capabilities = cmp_cap,
		})

		local severity = vim.diagnostic.severity

		vim.diagnostic.config({
			signs = {
				text = {
					[severity.ERROR] = " ",
					[severity.WARN] = " ",
					[severity.HINT] = "󰠠 ",
					[severity.INFO] = " ",
				},
			},
		})
	end,
}
