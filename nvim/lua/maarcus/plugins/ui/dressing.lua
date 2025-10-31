return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      border = "rounded",
      relative = "editor",
    },
    select = {
      backend = { "telescope", "builtin" },
      builtin = {
        border = "rounded",
      },
    },
  },
}
