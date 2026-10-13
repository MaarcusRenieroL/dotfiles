-- the big logo needs ~110 columns; narrower windows get a compact title instead
local function wide()
	return vim.o.columns >= 112
end
local function narrow()
	return vim.o.columns < 112
end

return {
	"folke/snacks.nvim",
	priority = 900,
	lazy = false,

	---@type snacks.Config
	opts = {
		-- notifications are handled by nvim-notify + noice
		notifier = { enabled = false },
		dashboard = {
			width = 60,
			preset = {
				keys = {
					{ icon = "󰈞 ", key = "f", desc = "Find file", action = ":Telescope find_files" },
					{ icon = "󰺮 ", key = "g", desc = "Live grep", action = ":Telescope live_grep" },
					{ icon = "󰋚 ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
					{ icon = "󰦛 ", key = "s", desc = "Restore session", action = ":lua require('persistence').load()" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = "󰩈 ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ padding = 1 },
				{ text = { { "███╗   ███╗ █████╗  █████╗ ██████╗  ██████╗██╗   ██╗███████╗   ██████╗ ███████╗██╗   ██╗", hl = "ZoroHdr1" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "████╗ ████║██╔══██╗██╔══██╗██╔══██╗██╔════╝██║   ██║██╔════╝   ██╔══██╗██╔════╝██║   ██║", hl = "ZoroHdr2" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "██╔████╔██║███████║███████║██████╔╝██║     ██║   ██║███████╗   ██║  ██║█████╗  ██║   ██║", hl = "ZoroHdr3" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "██║╚██╔╝██║██╔══██║██╔══██║██╔══██╗██║     ██║   ██║╚════██║   ██║  ██║██╔══╝  ╚██╗ ██╔╝", hl = "ZoroHdr4" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║╚██████╗╚██████╔╝███████║██╗██████╔╝███████╗ ╚████╔╝ ", hl = "ZoroHdr5" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝╚═════╝ ╚══════╝  ╚═══╝  ", hl = "ZoroHdr6" } }, align = "center", padding = 0, enabled = wide },
				{ text = { { "maarcus.dev", hl = "ZoroHdr1" } }, align = "center", padding = 0, enabled = narrow },
				{ text = { { "builds range.", hl = "SnacksDashboardFooter" } }, align = "center", padding = 2 },
				{ section = "keys", gap = 0, padding = 2 },
				{ section = "recent_files", icon = "󰋚 ", title = "Recent", indent = 2, padding = 1, limit = 5 },
				{ section = "projects", icon = " ", title = "Projects", indent = 2, padding = 1, limit = 4 },
				{ section = "startup" },
			},
		},
		lazygit = { enabled = true },
		terminal = { enabled = true },
		zen = { enabled = true },
		scratch = { enabled = true },
		picker = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		styles = { float = { border = "rounded" } },
	},

	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
		{ "<leader>.", function() Snacks.scratch() end, desc = "Scratch buffer" },
		{ "<leader>tt", function() Snacks.terminal() end, desc = "Toggle terminal" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
	},
}
