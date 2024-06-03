return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}

-- change the base, mantle and crust colors of catppuccin mocha theme in .local/share/nvim/lazy/lua/catppuccin/palettes/mocha.lua
