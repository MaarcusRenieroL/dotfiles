return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree", "lazy", "alpha" },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = {
          { "branch", icon = "" },
          { "diff",   symbols = { added = " ", modified = " ", removed = " " } },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " [+]",
              readonly = " ",
              unnamed = "[No Name]",
            },
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_active_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return " " .. table.concat(names, ", ")
            end,
            cond = function()
              return vim.tbl_count(vim.lsp.get_active_clients({ bufnr = 0 })) > 0
            end,
          },
          { "encoding" },
          {
            "fileformat",
            icons_enabled = true,
            symbols = { unix = "", dos = "", mac = "" },
          },
          { "filetype", icon_only = true },
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", icon = "" } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " [+]", readonly = " ", unnamed = "[No Name]" },
          },
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = nil,
      extensions = { "nvim-tree", "fugitive", "quickfix", "toggleterm", "man" },
    })
  end,
}
