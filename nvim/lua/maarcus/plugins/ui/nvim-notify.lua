return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			enabled = true,
			timeout = 100,
			background_colour = "#000000",
		})
	end,
}
