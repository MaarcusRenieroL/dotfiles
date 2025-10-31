return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local layout = require("telescope.actions.layout")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "bottom", -- 🔍 Search bar at bottom
          preview_width = 0.6,        -- 📄 Preview takes 60% of the width
          width = 0.95,
          height = 0.9,
        },
        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        selection_caret = "❯ ",
        preview = {
          hide_on_startup = false, -- always show preview
        },
        mappings = {
          i = {
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-p>"] = layout.toggle_preview, -- toggle preview on/off
          },
        },
      },
      pickers = {
        find_files = {
          previewer = true,
        },
        live_grep = {
          previewer = true,
        },
        buffers = {
          previewer = true,
        },
      },
    })
  end,
}
