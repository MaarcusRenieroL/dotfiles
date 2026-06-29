return {
	{
		"mfussenegger/nvim-dap",
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap" },
		opts = { commented = true },
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
			{ "<leader>d", desc = "Debug" },
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup({ commented = true })

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- JavaScript / TypeScript / Node via js-debug-adapter (mason).
			local mason = vim.fn.stdpath("data") .. "/mason"
			local js_debug = mason .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

			for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
				dap.adapters[adapter] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = { js_debug, "${port}" },
					},
				}
			end

			local js_filetypes = {
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
			}

			for _, ft in ipairs(js_filetypes) do
				dap.configurations[ft] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch current file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest test",
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
					},
				}
			end

			local k = vim.keymap.set

			k("n", "<F5>", dap.continue, { desc = "Debug continue" })
			k("n", "<F10>", dap.step_over, { desc = "Debug step over" })
			k("n", "<F11>", dap.step_into, { desc = "Debug step into" })
			k("n", "<F12>", dap.step_out, { desc = "Debug step out" })
			k("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			k("n", "<leader>dc", dap.continue, { desc = "Continue" })
			k("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "Conditional breakpoint" })
			k("n", "<leader>dr", dap.repl.open, { desc = "Open debug REPL" })
			k("n", "<leader>dl", dap.run_last, { desc = "Run last" })
			k("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
			k("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })
			k({ "n", "v" }, "<leader>de", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "Evaluate expression" })
		end,
	},
}
