return {
	{
		"nvim-treesitter/nvim-treesitter",

		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					-- core
					"lua",
					"vim",
					"vimdoc",
					"bash",

					-- web
					"html",
					"css",
					"scss",
					"javascript",
					"typescript",
					"tsx",
					"json",

					-- config
					"yaml",
					"toml",
					"dockerfile",
					"gitignore",

					-- databases
					"sql",

					-- markdown
					"markdown",
					"markdown_inline",

					-- java
					"java",

					-- mobile
					"swift",
				},

				highlight = {
					enable = true,
				},

				indent = {
					enable = true,
				},
			})
		end,
	},
}
