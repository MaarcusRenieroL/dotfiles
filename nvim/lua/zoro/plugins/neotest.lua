-- Unified test runner: Jest/Vitest for JS/TS, JUnit for Java/Spring Boot.
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap",
		-- adapters
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
		"rcasia/neotest-java",
	},
	keys = {
		{ "<leader>Tt", function() require("neotest").run.run() end, desc = "Test: nearest" },
		{ "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: file" },
		{ "<leader>Ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: all (suite)" },
		{ "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest" },
		{ "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Test: run last" },
		{ "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test: summary" },
		{ "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test: output" },
		{ "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Test: output panel" },
		{ "<leader>TS", function() require("neotest").run.stop() end, desc = "Test: stop" },
		{ "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test: watch file" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "pnpm test --",
				}),
				require("neotest-vitest"),
				require("neotest-java"),
			},
			status = { virtual_text = true },
			output = { open_on_run = false },
		})
	end,
}
