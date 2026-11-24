return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      -- Only render in normal, command, and terminal modes.
      -- When entering insert mode (editing), it automatically falls back to raw editor mode.
      render_modes = { "n", "c", "t" },
      anti_conceal = {
        enabled = true,
        ignore = {
          code_background = true,
          sign = true,
        },
      },
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = false,
        style = "full",
        position = "left",
        language_pad = 2,
        border = "thin",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰄵 " },
      },
      pipe_table = {
        enabled = true,
        preset = "round",
        style = "full",
      },
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Auto-enable conceallevel for markdown files so rich text displays properly
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = ""
        end,
      })

      -- Keymap to toggle rich text mode manually if desired
      vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", {
        desc = "Toggle Markdown rich text preview",
      })
    end,
  },
}
