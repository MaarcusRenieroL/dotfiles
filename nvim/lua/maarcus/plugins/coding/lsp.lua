return {
	{
		"nvim-java/nvim-java",
		config = false,
		dependencies = {
			{
				"neovim/nvim-lspconfig",
				opts = {
					setup = {
						jdtls = function()
							require("java").setup({})
						end,
					},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			lspconfig.jdtls.setup({
				capabilities = capabilities,
				cmd = {
					"jdtls",
					"--jvm-arg=" .. string.format("-javaagent:%s", vim.fn.expand("$MASON/share/jdtls/lombok.jar")),
				},
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			lspconfig.angularls.setup({
				capabilities = capabilities,
			})
		end,
	},
}
