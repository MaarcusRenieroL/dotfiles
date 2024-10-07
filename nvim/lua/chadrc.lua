local M = {}

M.ui = {
	cmp = {
		icons_left = true,
		lspkind_text = true,
		style = "default",
		format_colors = {
			tailwind = true,
			icon = "󱓻",
		},
	},

	telescope = { style = "bordered" },
	statusline = {
		enabled = true,
		theme = "minimal",
		separator_style = "round",
		order = nil,
		modules = nil,
	},
	tabufline = {
		enabled = true,
	},
}

M.lsp = {
	signature = true,
}

M.base46 = {
	theme = "yoru",
	integrations = {},
}

return M
