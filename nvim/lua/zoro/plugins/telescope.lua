return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Fuzzy find files in cwd" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Fuzzy find recent files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find string in cwd" },
      { "<leader>fs", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor in cwd" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find open buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help tags" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate " },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
