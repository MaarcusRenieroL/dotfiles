return {
  {
    "mfussenegger/nvim-dap",
  },

  {
    "rcarriga/nvim-dap-ui",

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

      k("n", "<F5>", dap.continue)
      k("n", "<F10>", dap.step_over)
      k("n", "<F11>", dap.step_into)
      k("n", "<F12>", dap.step_out)

      k("n", "<leader>b", dap.toggle_breakpoint)
      k("n", "<leader>dr", dap.repl.open)
    end,
  },
}
