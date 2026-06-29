local languages = {
	"lua",
	"vim",
	"vimdoc",
	"bash",
	"html",
	"css",
	"scss",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"yaml",
	"toml",
	"dockerfile",
	"gitignore",
	"sql",
	"graphql",
	"http",
	"prisma",
	"regex",
	"markdown",
	"markdown_inline",
	"java",
	"swift",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup()

			local installed = ts.get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, languages)

			if #missing > 0 then
				ts.install(missing)
			end

			vim.treesitter.language.register("tsx", "typescriptreact")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("zoro-treesitter", { clear = true }),
				pattern = {
					"lua",
					"vim",
					"help",
					"sh",
					"bash",
					"html",
					"css",
					"scss",
					"javascript",
					"typescript",
					"typescriptreact",
					"json",
					"yaml",
					"toml",
					"dockerfile",
					"gitignore",
					"sql",
					"graphql",
					"http",
					"prisma",
					"markdown",
					"java",
					"swift",
				},
				callback = function(event)
					pcall(vim.treesitter.start, event.buf)
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
