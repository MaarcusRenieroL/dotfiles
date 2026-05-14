return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},

		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- formatters
					"stylua",
					"prettier",
					"shfmt",

					-- linters
					"eslint_d",
					"shellcheck",

					-- language servers / tooling
					"lua-language-server",
					"html-lsp",
					"css-lsp",
					"json-lsp",
					"yaml-language-server",
					"bash-language-server",
					"typescript-language-server",

					-- useful later
					"java-debug-adapter",
					"java-test",
				},
			})
		end,
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
					"yamlls",
					"bashls",
				},
			})

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable("bashls")

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 2,
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
				group = vim.api.nvim_create_augroup("zoro-lsp-attach", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf, silent = true }
					local k = vim.keymap.set

					k("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
					k("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
					k(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, { desc = "Go to implementation" })
					)
					k("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
					k("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

					k("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
					k(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code action" })
					)

					k(
						"n",
						"[d",
						vim.diagnostic.goto_prev,
						vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
					)
					k("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
					k(
						"n",
						"<leader>e",
						vim.diagnostic.open_float,
						vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
					)
				end,
			})
		end,
	},
}
