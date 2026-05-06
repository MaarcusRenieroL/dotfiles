return {
  {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },

    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },

          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },

          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
        },

        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
        })
      end)
    end,
  },
}
