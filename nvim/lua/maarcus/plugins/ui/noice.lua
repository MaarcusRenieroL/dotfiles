return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
        },
      },
      hover = {
        enabled = true,
      },
      documentation = {
        view = "hover",
      },
      message = {
        enabled = true,
      },
    },

    cmdline = {
      view = "cmdline_popup",
      format = {
        cmdline = { icon = "" },
        search_down = { icon = " ⬇" },
        search_up = { icon = " ⬆" },
      },
    },

    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      hover = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
      mini = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },

    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
