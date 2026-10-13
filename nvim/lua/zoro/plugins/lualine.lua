return {
	{
		"nvim-lualine/lualine.nvim",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			-- maarcus.dev palette (nvim/lua/zoro/palette.lua, generated from theme/palette.env)
			local pal = require("zoro.palette")
			local c = {
				bg = pal.bg, card = pal.card, surface = pal.surface, fg = pal.fg, muted = pal.muted,
				accent = pal.accent, violet = pal.violet, amber = pal.amber, danger = pal.red, blue = pal.blue,
			}

			local function mode(color)
				return {
					a = { fg = c.bg, bg = color, gui = "bold" },
					b = { fg = c.fg, bg = c.surface },
					c = { fg = c.muted, bg = c.bg },
				}
			end

			local zoro = {
				normal = mode(c.accent),
				insert = mode(c.blue),
				visual = mode(c.violet),
				replace = mode(c.danger),
				command = mode(c.amber),
				inactive = {
					a = { fg = c.muted, bg = c.bg },
					b = { fg = c.muted, bg = c.bg },
					c = { fg = c.muted, bg = c.bg },
				},
			}

			require("lualine").setup({
				options = {
					theme = zoro,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "", right = "" } } },
					lualine_b = { "branch", "diff" },
					lualine_c = { { "filename", path = 1 }, "diagnostics" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { { "location", separator = { left = "", right = "" } } },
				},
			})
		end,
	},
}
