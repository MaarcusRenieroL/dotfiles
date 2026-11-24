return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      spec = {
        { "<leader>f", group = "Find / Telescope" },
        { "<leader>s", group = "Splits" },
        { "<leader>w", group = "Window / Save" },
        { "<leader>h", group = "Git Hunks" },
        { "<leader>c", group = "Code / LSP Actions" },
        { "<leader>b", group = "Buffers" },
        { "<leader>m", group = "Formatting" },
      },
    },
  },
}
