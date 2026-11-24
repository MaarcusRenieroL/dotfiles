return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Diagnostic icons in gutter
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Capabilities for autocompletion
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local k = vim.keymap.set

          opts.desc = "Show LSP references"
          k("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

          opts.desc = "Go to declaration"
          k("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP definitions"
          k("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

          opts.desc = "Show LSP implementations"
          k("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

          opts.desc = "Show LSP type definitions"
          k("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

          opts.desc = "See available code actions"
          k({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Smart rename"
          k("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Show line diagnostics"
          k("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Go to previous diagnostic"
          k("n", "[d", vim.diagnostic.goto_prev, opts)

          opts.desc = "Go to next diagnostic"
          k("n", "]d", vim.diagnostic.goto_next, opts)

          opts.desc = "Show documentation for what is under cursor"
          k("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Restart LSP"
          k("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
        end,
      })

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Set default capabilities across all LSPs
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Custom configuration for specific language servers
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      -- Servers corresponding to user's tech stack:
      -- Java/Spring Boot, TypeScript/React/Next.js/Node, Rust, Python/FastAPI, SQL/Postgres, Lua, Bash
      mason_lspconfig.setup({
        ensure_installed = {
          "ts_ls",
          "tailwindcss",
          "html",
          "cssls",
          "pyright",
          "rust_analyzer",
          "jdtls",
          "sqlls",
          "lua_ls",
          "bashls",
          "jsonls",
          "yamlls",
          "dockerls",
        },
        automatic_enable = true,
      })

      -- Install formatters and linters automatically via Mason
      mason_tool_installer.setup({
        ensure_installed = {
          "prettierd",
          "prettier",
          "stylua",
          "isort",
          "black",
          "google-java-format",
          "shfmt",
        },
      })
    end,
  },
}
