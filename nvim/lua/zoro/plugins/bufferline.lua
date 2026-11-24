return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        indicator = { style = "underline" },
        offsets = {
          { filetype = "neo-tree", text = "  explorer", text_align = "left", separator = false },
        },
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = true,
        always_show_bufferline = false,
      },
    })

    local k = vim.keymap.set
    k("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    k("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
    k("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
    k("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
    k("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
  end,
}
