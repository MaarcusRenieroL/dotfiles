return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		ensure_installed = {
			"beautysh",
			"yaml-language-server",
			"xmlformatter",
			"sqlls",
			"typescript-language-server",
			"sql-formatter",
			"prisma-language-server",
			"stylua",
			"lua-language-server",
			"jdtls",
			"jsonlint",
			"json-lsp",
			"docker-compose-language-service",
			"dockerfile-language-server",
			"astro-language-server",
			"sonarlint-language-server",
			"angular-language-server",
			"tailwindcss-language-server",
			"css-lsp",
			"prettier",
			"html-lsp",
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}
