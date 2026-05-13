return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
	},

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},

		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"jsonls",
				},
			})

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("jsonls")

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					local k = vim.keymap.set

					k("n", "gd", vim.lsp.buf.definition, opts)
					k("n", "gD", vim.lsp.buf.declaration, opts)
					k("n", "gi", vim.lsp.buf.implementation, opts)
					k("n", "gr", vim.lsp.buf.references, opts)
					k("n", "K", vim.lsp.buf.hover, opts)
					k("n", "<leader>rn", vim.lsp.buf.rename, opts)
					k("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					k("n", "[d", vim.diagnostic.goto_prev, opts)
					k("n", "]d", vim.diagnostic.goto_next, opts)
					k("n", "<leader>e", vim.diagnostic.open_float, opts)
				end,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},

		config = function()
			require("mason-tool-installer").setup({

				ensure_installed = {
					"stylua",
					"prettier",
					"eslint_d",
					"shfmt",
					"shellcheck",
					"json-lsp",
					"yaml-language-server",
				},
			})
		end,
	},
}
