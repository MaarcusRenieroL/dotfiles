return {
	{
		"mfussenegger/nvim-dap",
	},

	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		keys = {
			{ "<F5>" },
			{ "<F10>" },
			{ "<F11>" },
			{ "<F12>" },
			{ "<leader>b" },
			{ "<leader>dr" },
			{ "<leader>du" },
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			local k = vim.keymap.set

			k("n", "<F5>", dap.continue, { desc = "Debug continue" })
			k("n", "<F10>", dap.step_over, { desc = "Debug step over" })
			k("n", "<F11>", dap.step_into, { desc = "Debug step into" })
			k("n", "<F12>", dap.step_out, { desc = "Debug step out" })
			k("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			k("n", "<leader>dr", dap.repl.open, { desc = "Open debug REPL" })
			k("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })
		end,
	},
}
