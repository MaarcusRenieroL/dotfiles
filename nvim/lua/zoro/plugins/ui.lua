local zoro_lualine = {
  normal = {
    a = { fg = "#0d120e", bg = "#4ade80", gui = "bold" },
    b = { fg = "#f0fdf4", bg = "#1e3a29" },
    c = { fg = "#e2ece4", bg = "#161f18" },
  },
  insert = {
    a = { fg = "#0d120e", bg = "#e11d48", gui = "bold" },
    b = { fg = "#f0fdf4", bg = "#1e3a29" },
    c = { fg = "#e2ece4", bg = "#161f18" },
  },
  visual = {
    a = { fg = "#0d120e", bg = "#a855f7", gui = "bold" },
    b = { fg = "#f0fdf4", bg = "#1e3a29" },
    c = { fg = "#e2ece4", bg = "#161f18" },
  },
  replace = {
    a = { fg = "#0d120e", bg = "#eab308", gui = "bold" },
    b = { fg = "#f0fdf4", bg = "#1e3a29" },
    c = { fg = "#e2ece4", bg = "#161f18" },
  },
  command = {
    a = { fg = "#0d120e", bg = "#38bdf8", gui = "bold" },
    b = { fg = "#f0fdf4", bg = "#1e3a29" },
    c = { fg = "#e2ece4", bg = "#161f18" },
  },
  inactive = {
    a = { fg = "#475569", bg = "#161f18" },
    b = { fg = "#475569", bg = "#161f18" },
    c = { fg = "#475569", bg = "#0d120e" },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = zoro_lualine,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "neo-tree" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
