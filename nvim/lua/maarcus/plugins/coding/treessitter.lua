return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function(_, opts)
      require("nvim-treesitter").setup({
        automatic_installation = true,

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
      })
    end,
  }
