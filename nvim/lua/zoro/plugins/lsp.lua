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
					"sql-formatter",

					-- linters
					"eslint_d",
					"shellcheck",
					"markdownlint-cli2",
					"hadolint",

					-- debug adapters
					"js-debug-adapter",

					-- language servers / tooling
					"lua-language-server",
					"html-lsp",
					"css-lsp",
					"tailwindcss-language-server",
					"json-lsp",
					"yaml-language-server",
					"bash-language-server",
					"typescript-language-server",
					"emmet-language-server",
					"angular-language-server",
					"prisma-language-server",
					"dockerfile-language-server",
					"docker-compose-language-service",
					"sqlls",
					"taplo",
					"marksman",

					-- java (jdtls is driven by nvim-jdtls, see java.lua)
					"jdtls",
					"google-java-format",
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
			"hrsh7th/cmp-nvim-lsp",
			"b0o/SchemaStore.nvim",
		},

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
					},
				},
			})

			-- JSON with SchemaStore catalog (package.json, tsconfig, GitHub
			-- Actions, AWS CloudFormation, docker-compose, ...).
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- YAML with SchemaStore (CloudFormation/SAM, GitHub Actions,
			-- docker-compose, k8s, ...). Disable the built-in store first.
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
						keyOrdering = false,
					},
				},
			})

			-- Angular: only attaches in projects with angular.json.
			vim.lsp.config("angularls", {
				root_markers = { "angular.json", "nx.json" },
			})

			-- SQL language server (Postgres/MySQL dialects).
			vim.lsp.config("sqlls", {
				filetypes = { "sql", "mysql" },
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"yamlls",
					"bashls",
					"emmet_language_server",
					"angularls",
					"prismals",
					"dockerls",
					"docker_compose_language_service",
					"sqlls",
					"taplo",
					"marksman",
				},
				automatic_enable = false,
			})

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable("bashls")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("angularls")
			vim.lsp.enable("prismals")
			vim.lsp.enable("dockerls")
			vim.lsp.enable("docker_compose_language_service")
			vim.lsp.enable("sqlls")
			vim.lsp.enable("taplo")
			vim.lsp.enable("marksman")
			-- jdtls is started per-project by nvim-jdtls (see java.lua)

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
						"<leader>cl",
						vim.lsp.codelens.run,
						vim.tbl_extend("force", opts, { desc = "Run code lens" })
					)
					k(
						"n",
						"<leader>ds",
						vim.lsp.buf.document_symbol,
						vim.tbl_extend("force", opts, { desc = "Document symbols" })
					)
					k(
						"n",
						"<leader>ws",
						vim.lsp.buf.workspace_symbol,
						vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
					)

					if vim.lsp.inlay_hint then
						k("n", "<leader>th", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
								{ bufnr = event.buf }
							)
						end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
					end

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
