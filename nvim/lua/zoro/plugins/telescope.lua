return {
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = function()
      local telescope = require("telescope")

      telescope.setup({})

      local k = vim.keymap.set

      k("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
      k("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
      k("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
      k("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
    end
  }
}
