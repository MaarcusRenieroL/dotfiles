return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
  },

  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
        },
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("jsonls")

      local k = vim.keymap.set

      k("n", "gd", vim.lsp.buf.definition)
      k("n", "K", vim.lsp.buf.hover)
      k("n", "<leader>rn", vim.lsp.buf.rename)
      k("n", "<leader>ca", vim.lsp.buf.code_action)
    end,
  },
}
