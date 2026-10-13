-- Zoro: maarcus.dev palette (navy base, emerald accent) on top of catppuccin's
-- plugin integrations, so every plugin picks up the colours automatically.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      local p = require("zoro.palette")
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          bufferline = true, cmp = true, gitsigns = true, mason = true, neotree = true,
          treesitter = true, telescope = { enabled = true }, which_key = true,
          indent_blankline = { enabled = true, colored_indent_levels = false },
          native_lsp = { enabled = true, underlines = { errors = { "undercurl" }, warnings = { "undercurl" } } },
          flash = true, harpoon = true, noice = true, notify = true, snacks = { enabled = true }, dap = true, dap_ui = true, diffview = true, octo = true, lsp_trouble = true,
        },
        custom_highlights = function(c)
          return {
            WinSeparator = { fg = c.surface1 },
            FloatBorder = { fg = c.green },
            FloatTitle = { fg = c.base, bg = c.green, bold = true },
            CursorLine = { bg = c.surface0 },
            CursorLineNr = { fg = c.green, bold = true },
            ColorColumn = { bg = c.mantle },
            Visual = { bg = c.surface1 },
            MatchParen = { fg = c.green, bold = true, underline = true },
            TelescopeSelection = { bg = c.surface1, fg = c.green, bold = true },
            TelescopePromptBorder = { fg = c.green },
            TelescopeResultsBorder = { fg = c.surface2 },
            TelescopePreviewBorder = { fg = c.surface2 },
            TelescopePromptPrefix = { fg = c.green },
            ZoroHdr1 = { fg = "#6ee7b7", bold = true },
            ZoroHdr2 = { fg = "#5dd4a6", bold = true },
            ZoroHdr3 = { fg = "#4bc295", bold = true },
            ZoroHdr4 = { fg = "#3aaf84", bold = true },
            ZoroHdr5 = { fg = "#289d73", bold = true },
            ZoroHdr6 = { fg = "#178a62", bold = true },
            SnacksDashboardHeader = { fg = c.green, bold = true },
            SnacksDashboardTitle = { fg = c.green, bold = true },
            SnacksDashboardIcon = { fg = c.green },
            SnacksDashboardKey = { fg = c.green, bold = true },
            SnacksDashboardDesc = { fg = c.text },
            SnacksDashboardFile = { fg = c.text },
            SnacksDashboardDir = { fg = c.overlay1 },
            SnacksDashboardFooter = { fg = c.overlay1, italic = true },
            SnacksDashboardSpecial = { fg = c.mauve },
            IblIndent = { fg = c.surface0 },
            IblScope = { fg = c.green },
          }
        end,
        color_overrides = {
          mocha = {
            base = p.bg, mantle = p.mantle, crust = p.crust,
            surface0 = p.card, surface1 = p.surface, surface2 = p.surface2,
            overlay0 = p.overlay, overlay1 = p.comment, overlay2 = p.muted,
            subtext0 = p.muted, subtext1 = p.subtext, text = p.fg,
            rosewater = "#fca5a5", flamingo = "#fda4af", pink = "#f0abfc",
            mauve = p.violet, lavender = "#c4b5fd",
            red = p.red, maroon = "#fb923c", peach = p.orange, yellow = p.amber,
            green = p.accent, teal = p.cyan, sky = "#5eead4", sapphire = "#38bdf8", blue = p.blue,
          },
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
