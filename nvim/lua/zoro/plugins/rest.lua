-- REST client: write requests in .http files and run them inside Neovim.
-- Great for testing REST endpoints, JWT auth flows, etc. Needs curl (+ jq).
return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		display_mode = "split",
		split_direction = "vertical",
		default_view = "body",
	},
	keys = {
		{ "<leader>Rr", function() require("kulala").run() end, desc = "REST: run request", ft = { "http", "rest" } },
		{ "<leader>Ra", function() require("kulala").run_all() end, desc = "REST: run all", ft = { "http", "rest" } },
		{ "<leader>Rp", function() require("kulala").replay() end, desc = "REST: replay last", ft = { "http", "rest" } },
		{ "<leader>Rt", function() require("kulala").toggle_view() end, desc = "REST: toggle body/headers", ft = { "http", "rest" } },
		{ "<leader>Rc", function() require("kulala").copy() end, desc = "REST: copy as curl", ft = { "http", "rest" } },
		{ "<leader>Rn", function() require("kulala").jump_next() end, desc = "REST: next request", ft = { "http", "rest" } },
		{ "<leader>RN", function() require("kulala").jump_prev() end, desc = "REST: prev request", ft = { "http", "rest" } },
	},
}
