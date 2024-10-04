return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[]],
			[[]],
			[[]],
			[[]],
			[[]],
			[[   ██╗ ██╗ █████╗  ██████╗██╗  ██╗    ███████╗ ██████╗ ███╗   ██╗███████╗]],
			[[   █║  ██║██╔══██╗██╔════╝██║ ██╔╝    ╚══███╔╝██╔═══██╗████╗  ██║██╔════╝]],
			[[   ██████║███████║██║     █████╔╝       ███╔╝ ██║   ██║██╔██╗ ██║█████╗  ]],
			[[   █╔══██║██╔══██║██║     ██╔═██╗      ███╔╝  ██║   ██║██║╚██╗██║██╔══╝  ]],
			[[   █║  ██║██║  ██║╚██████╗██║  ██╗    ███████╗╚██████╔╝██║ ╚████║███████╗]],
			[[   ═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("t", "  Open Nvim Tree", ":NvimTreeToggle<CR>"),
			dashboard.button("f", "  Find files", ":Telescope find_files<CR>"),
			dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
			dashboard.button("l", "  Lazy Git", ":LazyGit<CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		dashboard.section.footer.val = "Have a productive coding session!"

		dashboard.config.opts.noautocmd = true
		alpha.setup(dashboard.config)
	end,
}
